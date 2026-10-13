import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums.dart';
import '../../core/format.dart';
import '../../core/router.dart';
import '../../data/db/database.dart';
import '../../data/repositories/attachment_repository.dart';
import '../../data/repositories/record_models.dart';
import '../../providers.dart';
import '../../services/photo_picker.dart';
import '../../widgets/attachment_thumb.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/placeholder_view.dart';
import '../photo_viewer/photo_viewer_screen.dart';
import '../record_form/photo_sheet.dart';

typedef DocumentQuery = ({int vehicleId, DocType? type, String search});

/// All photos and documents of a vehicle matching the filter.
final documentsProvider =
    StreamProvider.family<List<DocumentEntry>, DocumentQuery>(
      (ref, q) => ref
          .watch(attachmentRepositoryProvider)
          .watchDocuments(q.vehicleId, type: q.type, query: q.search),
    );

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _searching = false;
  DocType? _type;
  String _search = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => setState(() => _search = text.trim()),
    );
  }

  void _closeSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {
      _searching = false;
      _search = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = ref.watch(currentVehicleProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search part, station, caption, date…',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : const Text('Documents'),
        actions: [
          if (vehicle != null)
            IconButton(
              tooltip: _searching ? 'Close search' : 'Search',
              icon: Icon(_searching ? Icons.close : Icons.search),
              onPressed: _searching
                  ? _closeSearch
                  : () => setState(() => _searching = true),
            ),
        ],
        bottom: vehicle == null
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      for (final type in DocType.values) ...[
                        FilterChip(
                          avatar: Icon(type.icon, size: 18),
                          label: Text(type.label),
                          selected: _type == type,
                          showCheckmark: false,
                          onSelected: (on) =>
                              setState(() => _type = on ? type : null),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: vehicle == null
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.note_add_outlined),
              label: const Text('Add document'),
              onPressed: () => _addDocuments(vehicle),
            ),
      body: vehicle == null
          ? const PlaceholderView(
              icon: Icons.photo_library_outlined,
              title: 'No vehicle',
              subtitle: 'Add a vehicle on the Home tab first',
            )
          : _grid(vehicle),
    );
  }

  Widget _grid(Vehicle vehicle) {
    final docs = ref.watch(
      documentsProvider((vehicleId: vehicle.id, type: _type, search: _search)),
    );
    final filtered = _type != null || _search.isNotEmpty;

    return docs.when(
      skipLoadingOnReload: true,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (list) {
        if (list.isEmpty) {
          return filtered
              ? const PlaceholderView(
                  icon: Icons.search_off,
                  title: 'Nothing found',
                  subtitle: 'Try another type or search words',
                )
              : const PlaceholderView(
                  icon: Icons.photo_library_outlined,
                  title: 'No documents yet',
                  subtitle:
                      'Receipts attached to records appear here. '
                      'Add an insurance policy or registration with the button',
                );
        }
        final photos = [
          for (final d in list)
            ViewerPhoto(
              fileName: d.attachment.fileName,
              docType: d.attachment.docType,
              caption: _titleOf(d),
            ),
        ];
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: list.length,
          itemBuilder: (context, i) => _DocumentTile(
            entry: list[i],
            onTap: () => openPhotoViewer(context, photos, initialIndex: i),
            onLongPress: () => _showActions(list[i]),
          ),
        );
      },
    );
  }

  /// Picks photos and saves them as documents not linked to a record.
  Future<void> _addDocuments(Vehicle vehicle) async {
    final source = await askPhotoSource(context);
    if (source == null) return;
    final paths = await ref.read(photoPickerProvider).pick(source);
    if (paths.isEmpty || !mounted) return;

    final import = ref.read(photoImporterProvider);
    final names = [for (final path in paths) await import(path)];
    if (!mounted) return;

    // One type and caption for the whole batch (e.g. pages of a policy).
    final result = await showPhotoSheet(
      context,
      AttachmentDraft(fileName: names.first, docType: DocType.insurance),
    );
    final repo = ref.read(attachmentRepositoryProvider);
    if (result case PhotoSheetUpdate(:final docType, :final caption)) {
      for (final name in names) {
        await repo.addDocument(
          vehicleId: vehicle.id,
          fileName: name,
          type: docType,
          caption: caption,
        );
      }
    } else {
      // Dismissed or removed: nothing is saved, so drop the files.
      await ref.read(fileStorageProvider).deleteAll(names);
    }
  }

  Future<void> _showActions(DocumentEntry entry) async {
    final record = entry.record;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit type & caption'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            if (record != null)
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text('Open record "${record.title}"'),
                onTap: () => Navigator.pop(context, 'record'),
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;

    final a = entry.attachment;
    final repo = ref.read(attachmentRepositoryProvider);
    switch (action) {
      case 'edit':
        final result = await showPhotoSheet(
          context,
          AttachmentDraft(
            id: a.id,
            fileName: a.fileName,
            docType: a.docType,
            caption: a.caption,
          ),
        );
        if (result case PhotoSheetUpdate(:final docType, :final caption)) {
          await repo.updateCaption(a.id, caption: caption, type: docType);
        } else if (result is PhotoSheetRemove) {
          await _delete(entry);
        }
      case 'record':
        await context.push(Routes.record(record!.id));
      case 'delete':
        await _delete(entry);
    }
  }

  Future<void> _delete(DocumentEntry entry) async {
    final ok = await confirm(
      context,
      title: 'Delete document?',
      message: entry.record == null
          ? 'The photo will be deleted.'
          : 'The photo will be removed from "${entry.record!.title}".',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok) return;
    await ref.read(attachmentRepositoryProvider).delete(entry.attachment);
  }
}

String _titleOf(DocumentEntry d) =>
    d.attachment.caption ?? d.record?.title ?? d.attachment.docType.label;

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.entry,
    required this.onTap,
    required this.onLongPress,
  });

  final DocumentEntry entry;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = entry.attachment;
    final date = entry.record?.date ?? a.createdAt;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) => AttachmentThumb(
                fileName: a.fileName,
                docType: a.docType,
                size: c.maxWidth,
                onTap: onTap,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _titleOf(entry),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge,
          ),
          Text(
            formatDate(date),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
