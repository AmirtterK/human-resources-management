import 'package:flutter/material.dart';

class AddBodyDialog extends StatefulWidget {
  const AddBodyDialog({super.key});

  @override
  State<AddBodyDialog> createState() => _AddBodyDialogState();
}

class _AddBodyDialogState extends State<AddBodyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _bodyNameController = TextEditingController();
  final _bodyNameArController = TextEditingController();
  final _bodyCodeController = TextEditingController();

  @override
  void dispose() {
    _bodyNameController.dispose();
    _bodyNameArController.dispose();
    _bodyCodeController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_formKey.currentState!.validate()) {
      final bodyData = {
        'id': _bodyCodeController.text,
        'name': _bodyNameController.text,
        'nameAr': _bodyNameArController.text,
        'totalMembers': 0,
      };
      Navigator.of(context).pop(bodyData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0x2609866F), width: 1),
        ),
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create a New Body',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0A866F),
                  ),
                ),
                const Text(
                  'إضافة هيئة جديدة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff0A866F),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Body Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _bodyNameController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Enter body name",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter body name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'اسم الهيئة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _bodyNameArController,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "ادخل اسم الهيئة",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Arabic name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Body Code',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _bodyCodeController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Enter body identifier",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter body code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                const Text(
                  'NOTE: MAKE SURE THE CODE BE SELF-DESCRIBING',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _handleCreate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF09866F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Create',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}