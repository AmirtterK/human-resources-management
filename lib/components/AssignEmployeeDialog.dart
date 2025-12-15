import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/classes/Grade.dart';
import 'package:hr_management/services/department_service.dart';
import 'package:hr_management/services/body_service.dart';
import 'package:hr_management/services/grade_service.dart';
import 'package:hr_management/services/employee_service.dart';

/// Dialog for assigning an employee to department, body, and grade.
/// Used by Personnel Manager (PM) role.
class AssignEmployeeDialog extends StatefulWidget {
  final Employee employee;
  final VoidCallback? onAssigned;

  const AssignEmployeeDialog({
    super.key,
    required this.employee,
    this.onAssigned,
  });

  @override
  State<AssignEmployeeDialog> createState() => _AssignEmployeeDialogState();
}

class _AssignEmployeeDialogState extends State<AssignEmployeeDialog> {
  List<Department> _departments = [];
  List<Body> _bodies = [];
  List<Grade> _grades = [];
  
  int? _selectedDepartmentId;
  int? _selectedBodyId;
  int? _selectedGradeId;
  DateTime _startDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  
  bool _isLoading = true;
  bool _isLoadingGrades = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dateController.text = "${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}";
    _fetchData();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final departments = await DepartmentService.getDepartments();
      final bodies = await BodyService.getBodies();
      setState(() {
        _departments = departments;
        _bodies = bodies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchGradesForBody(int bodyId) async {
    setState(() {
      _isLoadingGrades = true;
      _grades = [];
      _selectedGradeId = null;
    });
    try {
      final grades = await GradeService.getGradesByBody(bodyId.toString());
      setState(() {
        _grades = grades;
        _isLoadingGrades = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingGrades = false;
        _errorMessage = 'Failed to load grades: $e';
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _assignEmployee() async {
    if (_selectedDepartmentId == null || 
        _selectedBodyId == null || 
        _selectedGradeId == null) {
      setState(() {
        _errorMessage = 'Please select all fields';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final result = await EmployeeService.assignRecruit(
        widget.employee.id,
        _selectedDepartmentId!,
        _selectedBodyId!,
        _selectedGradeId!,
        _startDate,
      );

      if (!mounted) return;

      if (result['success'] == true || result['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Employee assigned successfully'),
            backgroundColor: Colors.green,
          ),
        );
        if (widget.onAssigned != null) widget.onAssigned!();
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
    return AlertDialog(
      title: const Text('Assign Employee'),
      content: SizedBox(
        width: 450,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Employee info
                    Text(
                      'Employee: ${widget.employee.fullName}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),
                    
                    // Department dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedDepartmentId,
                      decoration: const InputDecoration(
                        labelText: 'Department *',
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
                    
                    // Body dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedBodyId,
                      decoration: const InputDecoration(
                        labelText: 'Body (Corps) *',
                        border: OutlineInputBorder(),
                      ),
                      items: _bodies
                          .map(
                            (b) => DropdownMenuItem<int>(
                              value: int.tryParse(b.id) ?? 0,
                              child: Text(b.designationFR.isNotEmpty 
                                  ? b.designationFR 
                                  : b.nameEn),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBodyId = value;
                          _errorMessage = null;
                        });
                        if (value != null) {
                          _fetchGradesForBody(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Grade dropdown
                    _isLoadingGrades
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : DropdownButtonFormField<int>(
                            value: _selectedGradeId,
                            decoration: InputDecoration(
                              labelText: 'Grade *',
                              border: const OutlineInputBorder(),
                              enabled: _selectedBodyId != null && _grades.isNotEmpty,
                            ),
                            items: _grades
                                .map(
                                  (g) => DropdownMenuItem<int>(
                                    value: int.tryParse(g.id) ?? 0,
                                    child: Text(g.designationFR.isNotEmpty 
                                        ? g.designationFR 
                                        : g.code),
                                  ),
                                )
                                .toList(),
                            onChanged: _selectedBodyId == null
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedGradeId = value;
                                      _errorMessage = null;
                                    });
                                  },
                          ),
                    
                    if (_selectedBodyId != null && _grades.isEmpty && !_isLoadingGrades) ...[
                      const SizedBox(height: 8),
                      Text(
                        'No grades found for the selected body',
                        style: TextStyle(color: Colors.orange.shade700, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Start Date Picker
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Start Date *',
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
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (_selectedDepartmentId == null ||
                  _selectedBodyId == null ||
                  _selectedGradeId == null ||
                  _isSubmitting)
              ? null
              : _assignEmployee,
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
              : const Text('Assign'),
        ),
      ],
    );
  }
}
