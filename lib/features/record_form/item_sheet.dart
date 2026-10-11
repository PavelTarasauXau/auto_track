import 'package:flutter/material.dart';

import '../../core/enums.dart';
import '../../core/format.dart';
import '../../data/repositories/record_models.dart';

/// Bottom sheet to add or edit a work/part line. Resolves to `null` when
/// dismissed.
Future<ItemDraft?> showItemSheet(BuildContext context, {ItemDraft? item}) {
  return showModalBottomSheet<ItemDraft>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ItemSheet(item: item),
  );
}

class _ItemSheet extends StatefulWidget {
  const _ItemSheet({this.item});

  final ItemDraft? item;

  @override
  State<_ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends State<_ItemSheet> {
  final _formKey = GlobalKey<FormState>();
  late ItemKind _kind = widget.item?.kind ?? ItemKind.work;
  late final _name = TextEditingController(text: widget.item?.name);
  late final _partNumber = TextEditingController(text: widget.item?.partNumber);
  late final _cost = TextEditingController(
    text: decimalToInput(widget.item?.cost),
  );

  @override
  void dispose() {
    _name.dispose();
    _partNumber.dispose();
    _cost.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final partNumber = _partNumber.text.trim();
    Navigator.pop(
      context,
      ItemDraft(
        kind: _kind,
        name: _name.text.trim(),
        partNumber: _kind == ItemKind.part && partNumber.isNotEmpty
            ? partNumber.toUpperCase()
            : null,
        cost: parseDecimal(_cost.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Keep the fields above the keyboard.
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.item == null ? 'Add item' : 'Edit item',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SegmentedButton<ItemKind>(
              segments: const [
                ButtonSegment(
                  value: ItemKind.work,
                  icon: Icon(Icons.handyman_outlined),
                  label: Text('Work'),
                ),
                ButtonSegment(
                  value: ItemKind.part,
                  icon: Icon(Icons.settings_outlined),
                  label: Text('Part'),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Name *',
                hintText: _kind == ItemKind.work
                    ? 'e.g. Oil change'
                    : 'e.g. Oil filter',
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            if (_kind == ItemKind.part) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _partNumber,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Part number'),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _cost,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Cost'),
              validator: _optionalDecimal,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: Text(widget.item == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}

String? _optionalDecimal(String? v) =>
    v == null || v.trim().isEmpty || parseDecimal(v) != null
    ? null
    : 'Enter a number';
