import 'package:flutter/material.dart';
import 'package:hr_management/services/employee_service.dart';
import 'package:hr_management/services/department_service.dart';
import 'package:hr_management/services/body_service.dart';
import 'package:hr_management/services/grade_service.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/classes/Grade.dart';

class AddEmployeeDialog extends StatefulWidget {
  final VoidCallback? onEmployeeAdded;

  const AddEmployeeDialog({super.key, this.onEmployeeAdded});

  @override
  State<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _stepController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  // Dropdowns
  String? _selectedRank;
  int? _selectedSpecialityId;
  int? _selectedDepartmentId;
  int? _selectedBodyId;
  int? _selectedGradeId;
  
  // Data Lists
  List<Department> _departments = [];
  List<Body> _bodies = [];
  List<Grade> _grades = [];

  // Rank enum options
  final List<String> _rankOptions = ['A1', 'A2', 'A3', 'A4', 'B1', 'B2', 'B3', 'C1', 'C2'];
  
  // Speciality options - temporary
  final List<int> _specialityOptions = [1, 2, 3];

  DateTime _startDate = DateTime.now();
  final TextEditingController _startDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDateController.text = "${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}";
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      final deps = await DepartmentService.getDepartments();
      final bodies = await BodyService.getBodies();
      if (mounted) {
        setState(() {
          _departments = deps;
          _bodies = bodies;
        });
      }
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    }
  }

  Future<void> _fetchGradesForBody(int bodyId) async {
    setState(() {
      _grades = [];
      _selectedGradeId = null;
    });
    try {
      final grades = await GradeService.getGradesByBody(bodyId.toString());
      if (mounted) {
        setState(() {
          _grades = grades;
        });
      }
    } catch (e) {
      debugPrint('Error loading grades: $e');
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
        _startDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _stepController.dispose();
    _startDateController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _handleApplyChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Build date of birth
        String dateOfBirth = '${_yearController.text}-${_monthController.text.padLeft(2, '0')}-${_dayController.text.padLeft(2, '0')}';

        // Prepare employee data
        final employeeData = {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'dateOfBirth': dateOfBirth,
          'address': _addressController.text.trim(),
          'originalRank': _selectedRank,
          'departmentId': _selectedDepartmentId ?? 0,
          'bodyId': _selectedBodyId,
          'gradeId': _selectedGradeId,
          'specialityId': _selectedSpecialityId ?? 0,
          'step': int.tryParse(_stepController.text.trim()) ?? 0,
          'reference': 'REF-${DateTime.now().millisecondsSinceEpoch}',
          'status': 'ACTIVE',
        };

        // 1. Add Employee
        final addResponse = await EmployeeService.addEmployee(employeeData);
        
        // 2. Assign Employee (if Body/Grade selected)
        if (_selectedBodyId != null && _selectedGradeId != null && _selectedDepartmentId != null) {
          // Identify ID from response (handle generic success message or full object)
          String? newEmployeeId;
          
          // If response contains 'id' directly or inside 'param'/'body' 
          // Usually Add returns the created object or id.
          // Based on service code, it returns json.decode(response.body).
          if (addResponse.containsKey('id')) {
            newEmployeeId = addResponse['id'].toString();
          }
          
          if (newEmployeeId != null) {
             await EmployeeService.assignRecruit(
              newEmployeeId,
              _selectedDepartmentId!,
              _selectedBodyId!,
              _selectedGradeId!,
              _startDate, // Use chosen start date
            );
          } else {
            // If ID missing, maybe log or warn? But basic Add suceeded.
            print('Warning: ID not returned from addEmployee, skipping assignment');
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Employee added and assigned successfully'),
              backgroundColor: Colors.green,
            ),
          );

          widget.onEmployeeAdded?.call();
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = e.toString();
          if (errorMessage.startsWith('Exception: ')) {
            errorMessage = errorMessage.replaceFirst('Exception: ', '');
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
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
          constraints: const BoxConstraints(maxHeight: 580),
          width: 400,
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Add Employee',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0A866F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // First Name & Last Name Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('First Name *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _firstNameController,
                              style: const TextStyle(fontSize: 13),
                              decoration: _inputDecoration('Enter first name'),
                              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Last Name *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _lastNameController,
                              style: const TextStyle(fontSize: 13),
                              decoration: _inputDecoration('Enter last name'),
                              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Date of Birth
                  const Text('Date of Birth *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dayController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 13),
                          decoration: _inputDecoration('DD'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Required';
                            final day = int.tryParse(value);
                            if (day == null || day < 1 || day > 31) return '1-31';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _monthController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 13),
                          decoration: _inputDecoration('MM'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Required';
                            final month = int.tryParse(value);
                            if (month == null || month < 1 || month > 12) return '1-12';
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
                          style: const TextStyle(fontSize: 13),
                          decoration: _inputDecoration('YYYY'),
                          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Address
                  const Text('Address *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _addressController,
                    style: const TextStyle(fontSize: 13),
                    decoration: _inputDecoration('Enter address'),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  // Rank & Step Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Original Rank *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: _selectedRank,
                              decoration: _inputDecoration('Select rank'),
                              items: _rankOptions.map((rank) {
                                return DropdownMenuItem<String>(
                                  value: rank,
                                  child: Text(rank, style: const TextStyle(fontSize: 13)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRank = value;
                                });
                              },
                              validator: (value) => value == null ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Step *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _stepController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 13),
                              decoration: _inputDecoration('Enter step'),
                              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Speciality Dropdown
                  const Text('Speciality *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<int>(
                    value: _selectedSpecialityId,
                    decoration: _inputDecoration('Select speciality'),
                    items: _specialityOptions.map((id) {
                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text('Speciality $id', style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecialityId = value;
                      });
                    },
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  // Department Dropdown
                  const Text('Department *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<int>(
                    value: _selectedDepartmentId,
                    decoration: _inputDecoration('Select department'),
                    items: _departments.map((d) {
                      return DropdownMenuItem<int>(
                        value: int.tryParse(d.id) ?? 0,
                        child: Text(d.name, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDepartmentId = value;
                      });
                    },
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                   // Body Dropdown
                  const Text('Body (Corps)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<int>(
                    value: _selectedBodyId,
                    decoration: _inputDecoration('Select body'),
                    items: _bodies.map((b) {
                      return DropdownMenuItem<int>(
                        value: int.tryParse(b.id) ?? 0,
                        child: Text(b.designationFR.isNotEmpty ? b.designationFR : b.nameEn, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBodyId = value;
                        _selectedGradeId = null;
                      });
                      if (value != null) _fetchGradesForBody(value);
                    },
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  // Grade Dropdown
                  const Text('Grade *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<int>(
                    value: _selectedGradeId,
                    decoration: _inputDecoration('Select grade'),
                    items: _grades.map((g) {
                      return DropdownMenuItem<int>(
                        value: int.tryParse(g.id) ?? 0,
                        child: Text(g.designationFR.isNotEmpty ? g.designationFR : g.code, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: _selectedBodyId == null ? null : (val) => setState(() => _selectedGradeId = val),
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),

                  // Start Date Picker (for Assignment)
                  const Text('Assignment Start Date', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87)),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _startDateController,
                    readOnly: true,
                    style: const TextStyle(fontSize: 13),
                    decoration: _inputDecoration('Select start date').copyWith(suffixIcon: const Icon(Icons.calendar_today, size: 20)),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleApplyChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF09866F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                              )
                            : const Text('Apply Changes', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffEF5350),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          elevation: 0,
                        ),
                        child: const Text('Cancel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      isDense: true,
    );
  }
}
