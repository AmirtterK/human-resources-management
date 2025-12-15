import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/classes/Grade.dart';
import 'package:hr_management/services/body_service.dart';
import 'package:hr_management/services/grade_service.dart';
import 'package:hr_management/services/employee_service.dart';

/// Dialog for promoting an employee (PM role).
/// PM must select new Grade and Step, and provide Justification.
class PromoteEmployeeDialog extends StatefulWidget {
  final Employee employee;
  final VoidCallback? onPromoted;

  const PromoteEmployeeDialog({
    super.key,
    required this.employee,
    this.onPromoted,
  });

  @override
  State<PromoteEmployeeDialog> createState() => _PromoteEmployeeDialogState();
}

class _PromoteEmployeeDialogState extends State<PromoteEmployeeDialog> {
  // Cascading dropdowns structure: Body -> Grade
  List<Body> _bodies = [];
  List<Grade> _grades = [];
  
  int? _selectedBodyId;
  int? _selectedGradeId;
  String? _selectedRank; // New Step: Rank selection
  int _step = 1;

  final List<String> _ranks = [
    'A1', 'A2', 'A3', 'A4',
    'B1', 'B2', 'B3',
    'C1', 'C2',
  ];
  final TextEditingController _justificationController = TextEditingController();
  
  bool _isLoading = true;
  bool _isLoadingGrades = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Pre-initialize step if available
    _step = widget.employee.step > 0 ? widget.employee.step + 1 : 1; 
    _fetchBodies();
  }

  @override
  void dispose() {
    _justificationController.dispose();
    super.dispose();
  }

  Future<void> _fetchBodies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final bodies = await BodyService.getBodies();
      setState(() {
        _bodies = bodies;
        
        // Initialize Body selection from employee data
        if (widget.employee.bodyId != null) {
          final existingBody = bodies.any((b) => int.tryParse(b.id) == widget.employee.bodyId);
          if (existingBody) {
             _selectedBodyId = widget.employee.bodyId;
             _fetchGradesForBody(_selectedBodyId!);
          }
        }
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

  Future<void> _promote() async {
    if (_selectedGradeId == null || _selectedRank == null || _justificationController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please select grade, rank and provide justification.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isSubmitting = true;
    });

    try {
      await EmployeeService.promoteEmployee(
        employeeId: widget.employee.id,
        gradeId: _selectedGradeId!,
        rank: _selectedRank!, // Pass selected rank
        step: _step,
        justification: _justificationController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Employee promoted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      if (widget.onPromoted != null) widget.onPromoted!();
      Navigator.of(context).pop();

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
      title: const Text('Promote Employee'),
      content: SizedBox(
        width: 450,
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Promoting: ${widget.employee.fullName}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  // Body Selection
                  DropdownButtonFormField<int>(
                    value: _selectedBodyId,
                    decoration: const InputDecoration(
                      labelText: 'Select Body (Corps)',
                      border: OutlineInputBorder(),
                    ),
                    items: _bodies.map((b) => DropdownMenuItem<int>(
                      value: int.tryParse(b.id) ?? 0,
                      child: Text(b.designationFR.isNotEmpty ? b.designationFR : b.nameEn),
                    )).toList(),
                    onChanged: widget.employee.bodyId != null ? null : (val) {
                      setState(() {
                        _selectedBodyId = val;
                        _errorMessage = null;
                      });
                      if (val != null) {
                        _fetchGradesForBody(val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Grade Selection
                  _isLoadingGrades 
                  ? const Center(child: Padding(
                      padding: EdgeInsets.all(8.0), 
                      child: CircularProgressIndicator()))
                  : DropdownButtonFormField<int>(
                    value: _selectedGradeId,
                    decoration: const InputDecoration(
                      labelText: 'Select New Grade *',
                      border: OutlineInputBorder(),
                    ),
                    items: _grades.map((g) => DropdownMenuItem<int>(
                      value: int.tryParse(g.id) ?? 0,
                      child: Text(g.designationFR.isNotEmpty ? g.designationFR : g.code),
                    )).toList(),
                    onChanged: _selectedBodyId == null ? null : (val) {
                      setState(() {
                        _selectedGradeId = val;
                        _errorMessage = null; 
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Rank Selection
                  DropdownButtonFormField<String>(
                    value: _selectedRank,
                    decoration: const InputDecoration(
                      labelText: 'Select New Rank *',
                      border: OutlineInputBorder(),
                    ),
                    items: _ranks.map((r) => DropdownMenuItem<String>(
                      value: r,
                      child: Text(r),
                    )).toList(),
                    onChanged: (val) {
                      setState(() {
                         _selectedRank = val;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Step Selection
                  TextFormField(
                    initialValue: _step.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'New Step',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                       final n = int.tryParse(val);
                       if (n != null) {
                         _step = n;
                       }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Justification
                  TextFormField(
                    controller: _justificationController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Justification (Required)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ]
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
          onPressed: _isSubmitting ? null : _promote,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A866F),
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Promote'),
        ),
      ],
    );
  }
}
