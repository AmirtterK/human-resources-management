import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/services/department_service.dart';
import 'package:hr_management/services/employee_service.dart';

/// Dialog for transferring an employee to a different department.
/// Used by Personnel Manager (PM) role.
class TransferEmployeeDialog extends StatefulWidget {
  final Employee employee;
  final VoidCallback? onTransferred;

  const TransferEmployeeDialog({
    super.key,
    required this.employee,
    this.onTransferred,
  });

  @override
  State<TransferEmployeeDialog> createState() => _TransferEmployeeDialogState();
}

class _TransferEmployeeDialogState extends State<TransferEmployeeDialog> {
  List<Department> _departments = [];
  int? _selectedDepartmentId;
  DateTime _effectiveDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dateController.text = "${_effectiveDate.year}-${_effectiveDate.month.toString().padLeft(2, '0')}-${_effectiveDate.day.toString().padLeft(2, '0')}";
    _fetchDepartments();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _fetchDepartments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final list = await DepartmentService.getDepartments();
      setState(() {
        _departments = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _effectiveDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _effectiveDate) {
      setState(() {
        _effectiveDate = picked;
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _transferEmployee() async {
    if (_selectedDepartmentId == null) return;
    
    // Check if same department
    if (_selectedDepartmentId == widget.employee.departmentId) {
      setState(() {
        _errorMessage = 'Please select a different department';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final result = await EmployeeService.transferEmployee(
        widget.employee.id,
        _selectedDepartmentId!,
        _effectiveDate,
      );

      if (!mounted) return;

      if (result['success'] == true || result['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Employee transferred successfully'),
            backgroundColor: Colors.green,
          ),
        );
        if (widget.onTransferred != null) widget.onTransferred!();
        Navigator.of(context).pop();
      } else {
        throw Exception(result['message'] ?? 'Unknown error');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDeptName = widget.employee.department.isNotEmpty
        ? widget.employee.department
        : 'Not assigned';

    return AlertDialog(
      title: const Text('Transfer Employee'),
      content: SizedBox(
        width: 400,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee info
                  Text(
                    'Employee: ${widget.employee.fullName}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current Department: $currentDeptName',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  
                  // Department dropdown
                  DropdownButtonFormField<int>(
                    value: _selectedDepartmentId,
                    decoration: const InputDecoration(
                      labelText: 'Transfer to Department *',
                      border: OutlineInputBorder(),
                    ),
                    items: _departments
                        .map(
                          (d) => DropdownMenuItem<int>(
                            value: int.tryParse(d.id) ?? 0,
                            child: Text(d.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDepartmentId = value;
                        _errorMessage = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Effective Date Picker
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Effective Date *',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  
                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (_selectedDepartmentId == null || _isSubmitting)
              ? null
              : _transferEmployee,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff0A866F),
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Transfer'),
        ),
      ],
    );
  }
}
