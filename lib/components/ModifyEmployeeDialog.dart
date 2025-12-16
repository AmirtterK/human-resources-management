import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/classes/Grade.dart';
import 'package:hr_management/services/employee_service.dart';
import 'package:hr_management/services/department_service.dart';
import 'package:hr_management/services/body_service.dart';
import 'package:hr_management/services/grade_service.dart';

/// Dialog for modifying an existing employee's details.
/// Allows updating personal info, rank, step, and assignment.
class ModifyEmployeeDialog extends StatefulWidget {
  final Employee employee;

  const ModifyEmployeeDialog({super.key, required this.employee});

  @override
  State<ModifyEmployeeDialog> createState() => _ModifyEmployeeDialogState();
}

class _ModifyEmployeeDialogState extends State<ModifyEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _referenceController = TextEditingController();

  // Dropdown selections
  int? _selectedDepartmentId;
  int? _selectedBodyId;
  int? _selectedGradeId;
  int? _selectedSpecialityId;
  String? _selectedRank;

  // Data lists
  List<Department> _departments = [];
  List<Body> _bodies = [];
  List<Grade> _grades = [];
  final List<int> _specialityOptions = [1, 2, 3];
  final List<String> _rankOptions = [
    'A1', 'A2', 'A3', 'A4',
    'B1', 'B2', 'B3',
    'C1', 'C2',
  ];

  late int _currentStep;
  bool _isSubmitting = false;
  bool _isLoadingGrades = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _fetchInitialData();
  }

  void _initializeFields() {
    // Name
    if (widget.employee.firstName != null && widget.employee.firstName!.isNotEmpty) {
      _firstNameController.text = widget.employee.firstName!;
    } else {
      final parts = widget.employee.fullName.trim().split(RegExp(r'\s+'));
      _firstNameController.text = parts.isNotEmpty ? parts.first : '';
    }
    
    if (widget.employee.lastName != null && widget.employee.lastName!.isNotEmpty) {
      _lastNameController.text = widget.employee.lastName!;
    } else {
      final parts = widget.employee.fullName.trim().split(RegExp(r'\s+'));
      _lastNameController.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }
    
    // Step, Reference, Address
    _currentStep = widget.employee.step;
    _referenceController.text = widget.employee.reference ?? '';
    _addressController.text = widget.employee.address ?? '';

    // Rank
    if (_rankOptions.contains(widget.employee.rank)) {
      _selectedRank = widget.employee.rank;
    } else if (_rankOptions.isNotEmpty) {
      _selectedRank = _rankOptions.first;
    }

    // IDs
    _selectedDepartmentId = widget.employee.departmentId;
    _selectedSpecialityId = widget.employee.specialityId;
    _selectedBodyId = widget.employee.bodyId;
    _selectedGradeId = widget.employee.gradeId;

    // Date of Birth
    final dateToUse = widget.employee.dateOfBirth ?? widget.employee.requestDate;
    if (dateToUse != null) {
      _dayController.text = dateToUse.day.toString();
      _monthController.text = dateToUse.month.toString();
      _yearController.text = dateToUse.year.toString();
    }
  }

  Future<void> _fetchInitialData() async {
    // Structural data fetching removed as fields are removed from UI
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _handleApplyChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Date of Birth
      String dobString = '';
      if (_yearController.text.isNotEmpty && _monthController.text.isNotEmpty && _dayController.text.isNotEmpty) {
        String year = _yearController.text.padLeft(4, '0');
        String month = _monthController.text.padLeft(2, '0');
        String day = _dayController.text.padLeft(2, '0');
        dobString = '$year-$month-$day';
      }

      final Map<String, dynamic> payload = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'dateOfBirth': dobString, // Validator ensures this is not empty
        'address': _addressController.text.trim(),
        'specialityId': _selectedSpecialityId,
        'reference': _referenceController.text.trim(),
      };

      // Backend requires specialityId (Long). 
      if (_selectedSpecialityId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Please select a speciality'), backgroundColor: Colors.red),
        );
        setState(() => _isSubmitting = false);
        return;
      }
      
      // Usually modify requires all fields. If null, we shouldn't send? 
      // But endpoint expects a complete DTO.
      // Assuming validation prevents nulls for required fields (Department, Speciality).

      try {
        await EmployeeService.modifyEmployee(widget.employee.id, payload);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee modified successfully'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to modify: $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  void _promoteStep() {
    setState(() => _currentStep++);
  }

  void _promoteRank() {
    if (_selectedRank == null) return;
    final idx = _rankOptions.indexOf(_selectedRank!);
    if (idx >= 0 && idx < _rankOptions.length - 1) {
      setState(() => _selectedRank = _rankOptions[idx + 1]);
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
            side: const BorderSide(color: Color(0x2609866F), width: 1)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   const Text(
                    'Modify Employee',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xff0A866F)),
                  ),
                  const SizedBox(height: 24),
                  
                  // Name Fields
                  Row(
                    children: [
                      Expanded(child: _buildTextField('First Name', _firstNameController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('Last Name', _lastNameController)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // DOB
                  _buildLabel('Date of birth'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildDateField(_dayController, 'DD', 1, 31)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildDateField(_monthController, 'MM', 1, 12)),
                      const SizedBox(width: 8),
                      Expanded(flex: 2, child: _buildDateField(_yearController, 'YYYY', 1900, 2100)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildTextField('Address', _addressController),
                  const SizedBox(height: 16),
                  _buildTextField('Reference', _referenceController),
                  const SizedBox(height: 16),

                  // Structural fields (Rank, Step, Body, Grade, Department) removed from UI.
                  // Only Personal Info and Speciality remain (if needed).


                  // Speciality Dropdown
                  DropdownButtonFormField<int>(
                    value: _specialityOptions.contains(_selectedSpecialityId) ? _selectedSpecialityId : null,
                    decoration: _buildInputDecoration('Select Speciality'),
                    items: _specialityOptions.map((id) => DropdownMenuItem(
                      value: id,
                      child: Text('Speciality $id'),
                    )).toList(),
                    onChanged: (val) => setState(() => _selectedSpecialityId = val),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleApplyChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF289581),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: _isSubmitting 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Apply Changes'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffEF5350),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          decoration: _buildInputDecoration('Enter $label'),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildDateField(TextEditingController controller, String hint, int min, int max) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 13, color: Colors.black87),
      decoration: _buildInputDecoration(hint),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Req';
        final n = int.tryParse(value);
        if (n == null || n < min || n > max) return 'Inv';
        return null;
      },
    );
  }

  Widget _buildRankCard() {
    return _buildInfoCard('Current Rank', _selectedRank ?? '-', () => _promoteRank(), 'Promote');
  }

  Widget _buildStepCard() {
    return _buildInfoCard('Current Step', '$_currentStep', () => _promoteStep(), '+1');
  }

  Widget _buildInfoCard(String title, String value, VoidCallback onPromote, String btnLabel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 24,
                child: ElevatedButton(
                  onPressed: onPromote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff289581),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    textStyle: const TextStyle(fontSize: 10),
                  ),
                  child: Text(btnLabel, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87));
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      isDense: true,
    );
  }
}
