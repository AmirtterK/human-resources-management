import 'package:flutter/material.dart';

class AddEmployeeToBodieDialog extends StatefulWidget {
  const AddEmployeeToBodieDialog({super.key});

  @override
  State<AddEmployeeToBodieDialog> createState() => _AddEmployeeToBodieDialogState();
}

class _AddEmployeeToBodieDialogState extends State<AddEmployeeToBodieDialog> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  String? _selectedGrade;

  final List<String> _grades = [
    'Grade A',
    'Grade B',
    'Grade C',
    'Grade D',
  ];

  @override
  void dispose() {
    _employeeIdController.dispose();
    super.dispose();
  }

  void _handleValidate() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee added successfully')),
      );
      Navigator.of(context).pop();
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
                  'إضافة عامل جديد',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff0A866F),
                    fontFamily: 'Alfont',
                  ),
                ),
                const SizedBox(height: 24),
                
                const Text(
                  "Employee's ID",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _employeeIdController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Enter Employee's ID",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter employee ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Grade code',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedGrade,
                  decoration: InputDecoration(
                    hintText: 'CP310',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    isDense: true,
                  ),
                  items: _grades.map((String grade) {
                    return DropdownMenuItem<String>(
                      value: grade,
                      child: Text(
                        grade,
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGrade = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a grade';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Grade : chief principal assistant Doctor',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  'الطبيب الأستاذ المساعد الرئيسي',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    fontFamily: 'Alfont',
                  ),
                ),
                const SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: _handleValidate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF09866F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Validate',
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