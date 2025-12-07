import 'package:flutter/material.dart';
import 'package:hr_management/services/employee_service.dart';

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
  
  // Rank enum options from API
  final List<String> _rankOptions = ['A1', 'A2', 'A3', 'A4', 'B1', 'B2', 'B3', 'C1', 'C2'];
  
  // Speciality options - temporary, will be from API later
  final List<int> _specialityOptions = [1, 2, 3];
  
  // Department options - temporary, will be from API later
  final List<int> _departmentOptions = [1, 2, 3];

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _stepController.dispose();
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
        // Build date of birth in Java LocalDate format (YYYY-MM-DD)
        String dateOfBirth = '${_yearController.text}-${_monthController.text.padLeft(2, '0')}-${_dayController.text.padLeft(2, '0')}';

        // Prepare employee data matching server EmployeeDTOPM format
        final employeeData = {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'dateOfBirth': dateOfBirth,
          'address': _addressController.text.trim(),
          'originalRank': _selectedRank,
          'departmentId': _selectedDepartmentId ?? 0,
          'specialityId': _selectedSpecialityId ?? 0,
          'step': int.tryParse(_stepController.text.trim()) ?? 0,
          'reference': 'REF-${DateTime.now().millisecondsSinceEpoch}',
          'status': 'ACTIVE',
        };

        // Send to API
        await EmployeeService.addEmployee(employeeData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Employee added successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Call the callback to refresh the employee list
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
                    items: _departmentOptions.map((id) {
                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text('Department $id', style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDepartmentId = value;
                      });
                    },
                    validator: (value) => value == null ? 'Required' : null,
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
