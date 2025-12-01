import 'package:flutter/material.dart';

class AddDomainDialog extends StatefulWidget {
  const AddDomainDialog({super.key});

  @override
  State<AddDomainDialog> createState() => _AddDomainDialogState();
}

class _AddDomainDialogState extends State<AddDomainDialog> {
  final _formKey = GlobalKey<FormState>();
  final _domainNameController = TextEditingController();

  @override
  void dispose() {
    _domainNameController.dispose();
    super.dispose();
  }

  void _handleApplyChanges() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_domainNameController.text);
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
                  'Add Domain',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0A866F),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Domain Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _domainNameController,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: "Enter the domain name",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter domain name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _handleApplyChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF09866F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Apply Changes',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffEF5350),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}