import 'package:flutter/material.dart';
import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/components/AddBodieDialog.dart';
import 'package:hr_management/components/BodieCard.dart';
import 'package:hr_management/data/data.dart';
import 'package:hr_management/services/body_service.dart';
import 'package:hr_management/services/employee_service.dart';
import 'package:hr_management/tabs/ExtendedBodiesTab.dart';

class BodiesTab extends StatefulWidget {
  const BodiesTab({super.key});

  @override
  State<BodiesTab> createState() => _BodiesTabState();
}

class _BodiesTabState extends State<BodiesTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Body> _filteredBodies = [];
  List<Body> _bodies = [];
  bool _isViewingDetails = false;
  bool _isLoading = true;
  Body? _selectedBody;
  Map<String, int> _memberCounts = {};

  @override
  void initState() {
    super.initState();
    _fetchBodies();
    _searchController.addListener(_filterBodies);
  }

  Future<void> _fetchBodies() async {
    try {
      final fetchedBodies = await BodyService.getBodies();
      // Fetch employees and compute member counts per body
      List<Employee> employees = [];
      try {
        employees = await EmployeeService.getEmployees();
      } catch (e) {
        // If employees fail to load, still show bodies with 0 counts
        print('Failed to fetch employees for counts: $e');
      }

      final Map<String, int> counts = {};
      for (final b in fetchedBodies) {
        final bid = int.tryParse(b.id);
        final c = employees.where((e) {
          final idMatch = bid != null && e.bodyId == bid;
          final enMatch = (e.bodyEn?.toLowerCase() == b.nameEn.toLowerCase());
          final arMatch = (e.bodyAr?.toLowerCase() == b.nameAr.toLowerCase());
          return idMatch || enMatch || arMatch;
        }).length;
        counts[b.id] = c;
      }

      setState(() {
        _bodies = fetchedBodies;
        _filteredBodies = fetchedBodies;
        _memberCounts = counts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching bodies: $e');
      setState(() {
        _isLoading = false;
      });
      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load bodies: $e')));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBodies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBodies = _bodies;
      } else {
        _filteredBodies = _bodies.where((body) {
          final codeMatch = body.code.toLowerCase().contains(query);
          final designationFRMatch = body.designationFR.toLowerCase().contains(
            query,
          );
          final designationARMatch = body.designationAR.toLowerCase().contains(
            query,
          );
          final idMatch = body.id.toLowerCase().contains(query);
          return codeMatch ||
              designationFRMatch ||
              designationARMatch ||
              idMatch;
        }).toList();
      }
    });
  }

  void _addBody() {
    showDialog(
      context: context,
      builder: (context) => const AddBodyDialog(),
    ).then((bodyData) async {
      if (bodyData != null) {
        final map = bodyData as Map<String, dynamic>;
        final code = (map['id'] ?? '').toString();
        final designationFR = (map['name'] ?? '').toString();
        final designationAR = (map['nameAr'] ?? '').toString();

        try {
          final created = await BodyService.createBody(
            code: code,
            designationFR: designationFR,
            designationAR: designationAR,
          );

          if (created != null) {
            setState(() {
              _bodies.insert(0, created);
              _filterBodies();
            });
          } else {
            await _fetchBodies();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Body created successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to create body: $e')));
        }
      }
    });
  }

  void _viewDetails(Body body) {
    setState(() {
      _isViewingDetails = true;
      _selectedBody = body;
    });
  }

  void _returnToList() {
    setState(() {
      _isViewingDetails = false;
      _selectedBody = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isViewingDetails) {
      return ExtendedBodiesTab(body: _selectedBody, onReturn: _returnToList);
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
                          'Bodies',
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff289581),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: _fetchBodies,
                          icon: const Icon(
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
                        const SizedBox(width: 20),
                        OutlinedButton.icon(
                          onPressed: _addBody,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Body'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xff289581),
                            side: const BorderSide(color: Color(0xff289581)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _filteredBodies.isEmpty
                        ? const Center(
                            child: Text(
                              'No bodies found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: _filteredBodies.length,
                            itemBuilder: (context, index) {
                              final b = _filteredBodies[index];
                              return BodieCard(
                                body: b,
                                onViewDetails: () => _viewDetails(b),
                                onDelete: () => _confirmDelete(b),
                                memberCount: _memberCounts[b.id],
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

  Future<void> _confirmDelete(Body body) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Body'),
        content: Text('Are you sure you want to delete ${body.nameEn}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _deleteBody(body);
    }
  }

  Future<void> _deleteBody(Body body) async {
    try {
      await BodyService.deleteBody(id: body.id);
      setState(() {
        _bodies.removeWhere((x) => x.id == body.id);
        _filteredBodies.removeWhere((x) => x.id == body.id);
        _memberCounts.remove(body.id);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Body deleted')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete body: $e')));
    }
  }
}
