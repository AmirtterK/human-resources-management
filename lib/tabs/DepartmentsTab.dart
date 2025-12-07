import 'package:flutter/material.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/components/DepartmentCard.dart';
import 'package:hr_management/tabs/ExtendedDepartmentsTab.dart';
import 'package:hr_management/services/department_service.dart';

class DepartmentsTab extends StatefulWidget {
  const DepartmentsTab({super.key});

  @override
  State<DepartmentsTab> createState() => _DepartmentsTabState();
}

class _DepartmentsTabState extends State<DepartmentsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Department> _allDepartments = [];
  List<Department> _filteredDepartments = [];
  bool _isViewingDetails = false;
  Department? _selectedDepartment;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
    _searchController.addListener(_filterDepartments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDepartments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedDepartments = await DepartmentService.getDepartments();
      setState(() {
        _allDepartments = fetchedDepartments;
        _filteredDepartments = fetchedDepartments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _allDepartments = [];
        _filteredDepartments = [];
      });
    }
  }

  void _filterDepartments() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredDepartments = _allDepartments;
      } else {
        _filteredDepartments = _allDepartments.where((dept) {
          final nameMatch = dept.name.toLowerCase().contains(query);
          final idMatch = dept.id.toLowerCase().contains(query);
          return nameMatch || idMatch;
        }).toList();
      }
    });
  }

  void _viewDetails(Department department) {
    setState(() {
      _isViewingDetails = true;
      _selectedDepartment = department;
    });
  }

  void _returnToList() {
    setState(() {
      _isViewingDetails = false;
      _selectedDepartment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isViewingDetails) {
      return ExtendedDepartmentsTab(
        department: _selectedDepartment,
        onReturn: _returnToList,
      );
    }

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
                    child: Row(
                      children: [
                        const Text(
                          'Departments',
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff289581),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: _fetchDepartments,
                          icon: const Icon(
                            Icons.refresh,
                            color: Color(0xff289581),
                          ),
                          tooltip: 'Refresh',
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFFF5F5F5),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search by ID or Name',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff289581)),
                            ),
                          )
                        : _errorMessage != null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Error: $_errorMessage',
                                      style: const TextStyle(color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _fetchDepartments,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff289581),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : _filteredDepartments.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No departments found',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : GridView.builder(
                                    padding: const EdgeInsets.all(24.0),
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 350,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      mainAxisExtent: 140,
                                    ),
                                    itemCount: _filteredDepartments.length,
                                    itemBuilder: (context, index) {
                                      return DepartmentCard(
                                        department: _filteredDepartments[index],
                                        onSeeDetails:
                                            () => _viewDetails(_filteredDepartments[index]),
                                      );
                                    },
                                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
