import 'package:flutter/material.dart';
import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/components/BodieCard.dart';
import 'package:hr_management/services/body_service.dart';
import 'package:hr_management/services/employee_service.dart';
import 'package:hr_management/tabs/ExtendedGradesTab.dart';

/// Tab for viewing bodies to select and manage their grades.
class GradesTab extends StatefulWidget {
  const GradesTab({super.key});

  @override
  State<GradesTab> createState() => _GradesTabState();
}

class _GradesTabState extends State<GradesTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Body> _bodies = [];
  List<Body> _filtered = [];
  Map<String, int> _counts = {};
  bool _loading = true;
  Body? _selected;
  bool _viewing = false;

  @override
  void initState() {
    super.initState();
    _fetchBodies();
    _searchController.addListener(_filter);
  }

  Future<void> _fetchBodies() async {
    try {
      final fetched = await BodyService.getBodies();
      List<Employee> employees = [];
      try {
        employees = await EmployeeService.getEmployees();
      } catch (_) {}
      final Map<String, int> counts = {};
      for (final b in fetched) {
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
        _bodies = fetched;
        _filtered = fetched;
        _counts = counts;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _filter() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = _bodies;
      } else {
        _filtered = _bodies.where((b) {
          return b.code.toLowerCase().contains(q) ||
              b.designationFR.toLowerCase().contains(q) ||
              b.designationAR.toLowerCase().contains(q) ||
              b.id.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  void _seeGrades(Body body) {
    setState(() {
      _selected = body;
      _viewing = true;
    });
  }

  void _return() {
    setState(() {
      _viewing = false;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_viewing) {
      return ExtendedGradesTab(body: _selected, onReturn: _return);
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
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                    child: Row(
                      children: [
                        const Text(
                          'Grades',
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
                          icon: const Icon(Icons.refresh, color: Color(0xff289581)),
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
                                hintText: 'Search bodies',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: _filtered.length,
                            itemBuilder: (context, index) {
                              final b = _filtered[index];
                              return BodieCard(
                                body: b,
                                onViewDetails: () => _seeGrades(b),
                                primaryLabel: 'See Grades',
                                memberCount: _counts[b.id],
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
