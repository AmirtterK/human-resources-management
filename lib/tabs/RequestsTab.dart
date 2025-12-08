import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/types.dart';
import 'package:hr_management/components/EmployeesTable.dart';
import 'package:hr_management/data/data.dart';
import 'package:hr_management/services/employee_service.dart';
import 'package:hr_management/services/pdf_service.dart';
import 'package:popover/popover.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Employee> _allRequests = [];
  List<Employee> _filteredRequests = [];
  Employee? selectedEmployee;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
    _searchController.addListener(_filterRequests);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final requests = await EmployeeService.getRetirementRequests();
      setState(() {
        _allRequests = requests;
        _filteredRequests = requests;
        _isLoading = false;
      });
      print('Loaded ${requests.length} retirement requests');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _allRequests = [];
        _filteredRequests = [];
      });
      print('Error fetching requests: $e');
    }
  }

  void _filterRequests() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredRequests = _allRequests;
      } else {
        _filteredRequests = _allRequests.where((employee) {
          final nameMatch = employee.fullName.toLowerCase().contains(query);
          final idMatch = employee.id.toLowerCase().contains(query);
          return nameMatch || idMatch;
        }).toList();
      }
    });
  }

  Future<void> _extractEmployeeList() async {
    if (_filteredRequests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No employees to export'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await PdfService.generateEmployeeListPDF(_filteredRequests, title: 'Retirees');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Employee list exported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 80),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 20,
                    ),
                    child: _buildHeaderSection(),
                  ),
                  const SizedBox(height: 24),
                  _buildTableSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        const Text(
          'Retirement Requests',
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xff289581),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: _fetchRequests,
          icon: Icon(
            Icons.refresh,
            color: Color(0xff289581),
          ),
          tooltip: 'Refresh data',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by ID or Names',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        OutlinedButton(
          onPressed: _extractEmployeeList,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal,
            side: const BorderSide(color: Colors.teal),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text('Extract List'),
        ),
        if (user == User.agent) ...{
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.expand_more_rounded, size: 30),
              ],
            ),
          ),
        },
      ],
    );
  }

  Widget _buildTableSection() {
    if (_isLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xff289581),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                'Failed to load requests: $_errorMessage',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _fetchRequests,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredRequests.isEmpty) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No retirement requests found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: EmployeesTable(
          title: 'RequestsTab',
          employees: _filteredRequests,
          onEmployeePressed: _showEmployeeActions,
        ),
      ),
    );
  }

  Future<void> _validateRequest(Employee employee) async {
    print('Attempting to VALIDATE request for employee ${employee.id}...');
    try {
      // Build payload matching strict structure
      final payload = {
        'firstName': employee.firstName ?? (employee.fullName.split(' ').isNotEmpty ? employee.fullName.split(' ').first : ''),
        'lastName': employee.lastName ?? (employee.fullName.split(' ').length > 1 ? employee.fullName.split(' ').sublist(1).join(' ') : ''),
        'dateOfBirth': employee.dateOfBirth?.toIso8601String().split('T').first ?? employee.requestDate?.toIso8601String().split('T').first,
        'address': employee.address ?? '',
        'originalRank': employee.rank, // Assuming 'rank' maps to 'originalRank'
        'departmentId': employee.departmentId,
        'specialityId': employee.specialityId,
        'step': employee.step,
        'reference': employee.reference ?? '',
        'retireRequest': false,
        'status': 'RETIRED' // We must set status to retired
      };

      // Remove nulls if any, though most have fallbacks
      payload.removeWhere((key, value) => value == null);
      print('Sending validate payload: $payload');

      final result = await EmployeeService.modifyEmployee(
        employee.id,
        payload,
      );
      
      print('Validate result: $result');

      if (!mounted) return;
      
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Retirement request validated'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchRequests(); // Refresh list to remove the processed item
      } else {
        throw Exception(result['message'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Error in _validateRequest: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error validating request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _denyRequest(Employee employee) async {
    print('Attempting to DENY request for employee ${employee.id}...');
    try {
      // Build payload matching strict structure
      final payload = {
        'firstName': employee.firstName ?? (employee.fullName.split(' ').isNotEmpty ? employee.fullName.split(' ').first : ''),
        'lastName': employee.lastName ?? (employee.fullName.split(' ').length > 1 ? employee.fullName.split(' ').sublist(1).join(' ') : ''),
        'dateOfBirth': employee.dateOfBirth?.toIso8601String().split('T').first ?? employee.requestDate?.toIso8601String().split('T').first,
        'address': employee.address ?? '',
        'originalRank': employee.rank,
        'departmentId': employee.departmentId,
        'specialityId': employee.specialityId,
        'step': employee.step,
        'reference': employee.reference ?? '',
        'retireRequest': false,
        // Status remains unchanged (ACTIVE)
      };

      payload.removeWhere((key, value) => value == null);
      print('Sending deny payload: $payload');

      final result = await EmployeeService.modifyEmployee(
        employee.id,
        payload,
      );
      
      print('Deny result: $result');
      
      if (!mounted) return;
      
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Retirement request denied'),
            backgroundColor: Colors.orange,
          ),
        );
        _fetchRequests(); // Refresh list to remove the processed item
      } else {
        throw Exception(result['message'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Error in _denyRequest: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error denying request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEmployeeActions(Employee employee, BuildContext buttonContext) {
    setState(() {
      selectedEmployee = employee;
    });
    // Archiver's options
    double popHeight = 80;
    
    showPopover(
      context: buttonContext,
      backgroundColor: Colors.white,
      width: 200,
      height: popHeight,
      arrowWidth: 0,
      arrowHeight: 0,
      direction: PopoverDirection.left,
      bodyBuilder: (context) => Material(
        color: Colors.white,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(buttonContext).pop();
                _validateRequest(employee);
              },
              child: Container(
                color: Color(0xffEEFFFA),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Validate",
                  style: TextStyle(color: Color(0xff0A866F), fontSize: 14),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1),
            InkWell(
              onTap: () {
                Navigator.of(buttonContext).pop();
                _denyRequest(employee);
              },
              child: Container(
                color: Color(0xffFFF8F8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Deny",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
