import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/services/employee_service.dart';
import 'package:hr_management/services/department_service.dart';

import 'package:hr_management/classes/Speciality.dart';
import 'package:hr_management/services/speciality_service.dart';

class ModifyRetireeDialog extends StatefulWidget {
  final Employee employee;

  const ModifyRetireeDialog({super.key, required this.employee});

  @override
  State<ModifyRetireeDialog> createState() => _ModifyRetireeDialogState();
}

class _ModifyRetireeDialogState extends State<ModifyRetireeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _referenceController = TextEditingController();

  int? _selectedDepartmentId;
  List<Department> _departments = [];

  int? _selectedSpecialityId;
  List<Speciality> _specialities = [];

  String? _selectedRank;
  final List<String> _rankOptions = [
    'A1',
    'A2',
    'A3',
    'A4',
    'B1',
    'B2',
    'B3',
    'C1',
    'C2',
  ];

  late int _currentStep;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _fetchDepartments();
    _fetchSpecialities();
  }

  void _initializeFields() {
    // Use firstName and lastName from employee if available, otherwise parse from fullName
    if (widget.employee.firstName != null &&
        widget.employee.firstName!.isNotEmpty) {
      _firstNameController.text = widget.employee.firstName!;
    } else {
      final parts = widget.employee.fullName.trim().split(RegExp(r'\s+'));
      _firstNameController.text = parts.isNotEmpty ? parts.first : '';
    }

    if (widget.employee.lastName != null &&
        widget.employee.lastName!.isNotEmpty) {
      _lastNameController.text = widget.employee.lastName!;
    } else {
      final parts = widget.employee.fullName.trim().split(RegExp(r'\s+'));
      _lastNameController.text = parts.length > 1
          ? parts.sublist(1).join(' ')
          : '';
    }

    _currentStep = widget.employee.step;
    _referenceController.text = widget.employee.reference ?? '';
    _addressController.text = widget.employee.address ?? '';

    // Rank default
    if (_rankOptions.contains(widget.employee.rank)) {
      _selectedRank = widget.employee.rank;
    } else if (_rankOptions.isNotEmpty) {
      _selectedRank = _rankOptions.first;
    }

    // Preselect department/speciality by IDs if available
    _selectedDepartmentId = widget.employee.departmentId;
    _selectedSpecialityId = widget.employee.specialityId;

    // Handle Date of Birth
    final dateToUse =
        widget.employee.dateOfBirth ?? widget.employee.requestDate;
    if (dateToUse != null) {
      _dayController.text = dateToUse.day.toString();
      _monthController.text = dateToUse.month.toString();
      _yearController.text = dateToUse.year.toString();
    }
  }

  Future<void> _fetchSpecialities() async {
    try {
      final specs = await SpecialityService.getSpecialities();
      setState(() {
        _specialities = specs;
        // Validate selected speciality ID
        if (_selectedSpecialityId != null &&
            !_specialities.any((s) => s.id == _selectedSpecialityId)) {
          _selectedSpecialityId = null;
        }
      });
    } catch (e) {
      debugPrint('Failed to fetch specialities: $e');
    }
  }

  Future<void> _fetchDepartments() async {
    try {
      final deps = await DepartmentService.getDepartments();
      setState(() {
        _departments = deps;
        _selectedDepartmentId ??= widget.employee.departmentId;
        if (_selectedDepartmentId != null &&
            !_departments.any(
              (d) => int.tryParse(d.id) == _selectedDepartmentId,
            )) {
          _selectedDepartmentId = null;
        }
      });
    } catch (e) {
      debugPrint('Failed to fetch departments: $e');
    }
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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Construct date string (YYYY-MM-DD)
      String dobString = '';
      if (_yearController.text.isNotEmpty &&
          _monthController.text.isNotEmpty &&
          _dayController.text.isNotEmpty) {
        String year = _yearController.text.padLeft(4, '0');
        String month = _monthController.text.padLeft(2, '0');
        String day = _dayController.text.padLeft(2, '0');
        dobString = '$year-$month-$day';
      }

      // Build payload matching strict structure required by backend
      final payload = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'dateOfBirth': dobString.isNotEmpty ? dobString : null,
        'address': _addressController.text.trim(),
        'originalRank': _selectedRank,
        'departmentId': _selectedDepartmentId,
        'specialityId': _selectedSpecialityId,
        'step': _currentStep,
        'reference': _referenceController.text.trim(),
        'retireRequest': false,
        'status': 'RETIRED', // Ensure status remains RETIRED
      };

      // Remove nulls - though most of these fields should be populated or allowed nulls
      payload.removeWhere((key, value) => value == null);

      try {
        await EmployeeService.modifyEmployee(widget.employee.id, payload);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Retiree modified successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to modify: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  void _promoteStep() {
    setState(() {
      _currentStep++;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Step promoted to $_currentStep (Click Apply Changes to save)',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _promoteRank() {
    if (_selectedRank == null) return;
    final idx = _rankOptions.indexOf(_selectedRank!);
    if (idx >= 0 && idx < _rankOptions.length - 1) {
      setState(() {
        _selectedRank = _rankOptions[idx + 1];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rank promoted to $_selectedRank'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Already at highest rank'),
          duration: Duration(seconds: 1),
        ),
      );
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
                    'Modify Retiree',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0A866F),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // First & Last Name
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('First Name'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _firstNameController,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              decoration: _buildInputDecoration(
                                'Enter first name',
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Last Name'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _lastNameController,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              decoration: _buildInputDecoration(
                                'Enter last name',
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date of Birth
                  _buildLabel('Date of birth'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dayController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          decoration: _buildInputDecoration('DD'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Req';
                            final n = int.tryParse(value);
                            if (n == null || n < 1 || n > 31) return 'Inv';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _monthController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          decoration: _buildInputDecoration('MM'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Req';
                            final n = int.tryParse(value);
                            if (n == null || n < 1 || n > 12) return 'Inv';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          decoration: _buildInputDecoration('YYYY'),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Required';
                            final n = int.tryParse(value);
                            if (n == null || n < 1900 || n > 2100)
                              return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Address
                  _buildLabel('Address'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    decoration: _buildInputDecoration('Enter the Address'),
                  ),
                  const SizedBox(height: 16),

                  // Reference
                  _buildLabel('Reference'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _referenceController,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    decoration: _buildInputDecoration('Enter the Reference'),
                  ),
                  const SizedBox(height: 16),

                  // Current Rank + Promote
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Current Rank'),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedRank,
                              items: _rankOptions.map((rank) {
                                return DropdownMenuItem(
                                  value: rank,
                                  child: Text(
                                    rank,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedRank = val),
                              decoration: _buildInputDecoration('Select Rank'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          const Text('', style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _promoteRank,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0A866F),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Promote',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Step + Promote
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Current Step'),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$_currentStep',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          const Text('', style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _promoteStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0A866F),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Promote',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Department
                  _buildLabel('Department'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedDepartmentId,
                    items: _departments
                        .map((dept) {
                          final parsedId = int.tryParse(dept.id);
                          if (parsedId == null) return null;
                          return DropdownMenuItem<int>(
                            value: parsedId,
                            child: Text(
                              dept.name,
                              style: const TextStyle(fontSize: 13),
                            ),
                          );
                        })
                        .whereType<DropdownMenuItem<int>>()
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedDepartmentId = val),
                    decoration: _buildInputDecoration('Select Department'),
                  ),
                  const SizedBox(height: 16),

                  // Speciality
                  _buildLabel('Speciality'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedSpecialityId,
                    items: _specialities.map((spec) {
                      return DropdownMenuItem(
                        value: spec.id,
                        child: Text(
                          spec.name,
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedSpecialityId = val),
                    decoration: _buildInputDecoration('Select Speciality'),
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0A866F),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Apply Changes',
                                style: TextStyle(color: Colors.white),
                              ),
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

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      isDense: true,
    );
  }
}
