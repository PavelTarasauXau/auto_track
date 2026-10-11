import 'package:flutter/material.dart';

import '../../core/enums.dart';
import '../../data/repositories/record_models.dart';
import '../../widgets/attachment_thumb.dart';

/// What the user chose in the photo sheet.
sealed class PhotoSheetResult {
  const PhotoSheetResult();
}

class PhotoSheetOpen extends PhotoSheetResult {
  const PhotoSheetOpen();
}

class PhotoSheetRemove extends PhotoSheetResult {
  const PhotoSheetRemove();
}

class PhotoSheetUpdate extends PhotoSheetResult {
  const PhotoSheetUpdate({required this.docType, this.caption});

  final DocType docType;
  final String? caption;
}

/// Bottom sheet to set the document type and caption of a photo, open it
/// or remove it. Resolves to `null` when dismissed.
Future<PhotoSheetResult?> showPhotoSheet(
  BuildContext context,
  AttachmentDraft photo,
) {
  return showModalBottomSheet<PhotoSheetResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _PhotoSheet(photo: photo),
  );
}

class _PhotoSheet extends StatefulWidget {
  const _PhotoSheet({required this.photo});

  final AttachmentDraft photo;

  @override
  State<_PhotoSheet> createState() => _PhotoSheetState();
}

class _PhotoSheetState extends State<_PhotoSheet> {
  late DocType _type = widget.photo.docType;
  late final _caption = TextEditingController(text: widget.photo.caption);

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  void _done() {
    final caption = _caption.text.trim();
    Navigator.pop(
      context,
      PhotoSheetUpdate(
        docType: _type,
        caption: caption.isEmpty ? null : caption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AttachmentThumb(
                fileName: widget.photo.fileName,
                size: 72,
                onTap: () => Navigator.pop(context, const PhotoSheetOpen()),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Photo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.open_in_full),
                label: const Text('Open'),
                onPressed: () => Navigator.pop(context, const PhotoSheetOpen()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final type in DocType.values)
                ChoiceChip(
                  avatar: Icon(type.icon, size: 18),
                  label: Text(type.label),
                  selected: _type == type,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _type = type),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _caption,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Caption',
              hintText: 'e.g. Warranty for brake pads',
              helperText: 'Used when searching documents',
            ),
            onSubmitted: (_) => _done(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove'),
                onPressed: () =>
                    Navigator.pop(context, const PhotoSheetRemove()),
              ),
              const Spacer(),
              FilledButton(onPressed: _done, child: const Text('Done')),
            ],
          ),
        ],
      ),
    );
  }
}
