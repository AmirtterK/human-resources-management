import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/services/employee_service.dart';

class AddEmployeeToDepartmentDialog extends StatefulWidget {
  final int departmentId;
  final VoidCallback? onAssigned;

  const AddEmployeeToDepartmentDialog({
    super.key,
    required this.departmentId,
    this.onAssigned,
  });

  @override
  State<AddEmployeeToDepartmentDialog> createState() => _AddEmployeeToDepartmentDialogState();
}

class _AddEmployeeToDepartmentDialogState extends State<AddEmployeeToDepartmentDialog> {
  List<Employee> _employees = [];
  String? _selectedEmployeeId;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final list = await EmployeeService.getEmployees();
      setState(() {
        _employees = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _displayLabel(Employee e) {
    final nameParts = [e.firstName ?? '', e.lastName ?? '']
        .where((s) => s.trim().isNotEmpty)
        .toList();
    final baseName = nameParts.isNotEmpty ? nameParts.join(' ').trim() : e.fullName;
    return '$baseName - ${e.id} -';
  }

  Future<void> _assignEmployee() async {
    if (_selectedEmployeeId == null) return;
    try {
      final emp = _employees.firstWhere((e) => e.id == _selectedEmployeeId);
      String? dobString;
      if (emp.dateOfBirth != null) {
        final d = emp.dateOfBirth!;
        dobString = '${d.year.toString().padLeft(4,'0')}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
      }
      final Map<String, dynamic> payload = {
        'firstName': emp.firstName?.trim(),
        'lastName': emp.lastName?.trim(),
        'dateOfBirth': dobString,
        'address': emp.address?.trim(),
        'originalRank': emp.rank,
        'step': emp.step,
        'departmentId': widget.departmentId,
        'specialityId': emp.specialityId,
        'reference': emp.reference?.trim(),
      };
      payload.removeWhere((key, value) => value == null);

      await EmployeeService.modifyEmployee(_selectedEmployeeId!, payload);
      if (widget.onAssigned != null) widget.onAssigned!();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Employee to Department'),
      content: SizedBox(
        width: 400,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _fetchEmployees,
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                : DropdownButtonFormField<String>(
                    value: _selectedEmployeeId,
                    decoration: const InputDecoration(
                      labelText: 'Choose employee',
                      border: OutlineInputBorder(),
                    ),
                    items: _employees
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e.id,
                            child: Text(_displayLabel(e)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEmployeeId = value;
                      });
                    },
                  ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedEmployeeId == null ? null : _assignEmployee,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff0A866F),
            foregroundColor: Colors.white,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}