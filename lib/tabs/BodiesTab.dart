import 'package:flutter/material.dart';
import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/components/AddBodieDialog.dart';
import 'package:hr_management/components/BodieCard.dart';
import 'package:hr_management/data/data.dart';
import 'package:hr_management/tabs/ExtendedBodiesTab.dart';

class BodiesTab extends StatefulWidget {
  const BodiesTab({super.key});

  @override
  State<BodiesTab> createState() => _BodiesTabState();
}

class _BodiesTabState extends State<BodiesTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Body> _filteredBodies = [];
  bool _isViewingDetails = false;
  Body? _selectedBody;

  @override
  void initState() {
    super.initState();
    _filteredBodies = bodies;
    _searchController.addListener(_filterBodies);
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
        _filteredBodies = bodies;
      } else {
        _filteredBodies = bodies.where((body) {
          final nameEnMatch = body.nameEn.toLowerCase().contains(query);
          final nameArMatch = body.nameAr.toLowerCase().contains(query);
          final idMatch = body.id.toLowerCase().contains(query);
          return nameEnMatch || nameArMatch || idMatch;
        }).toList();
      }
    });
  }

  void _addBody() {
    showDialog(
      context: context,
      builder: (context) => const AddBodyDialog(),
    ).then((bodyData) {
      if (bodyData != null) {
        setState(() {
          bodies.add(bodyData);
          _filterBodies(); // Re-filter to include new body if it matches
        });
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
      return ExtendedBodiesTab(
        body: _selectedBody,
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
                          'Bodies',
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
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
                        const SizedBox(width: 20),
                        OutlinedButton.icon(
                          onPressed: _addBody,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Body'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.teal,
                            side: const BorderSide(color: Colors.teal),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
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
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _filteredBodies.length,
                      itemBuilder: (context, index) {
                        return BodyCard(
                          body: _filteredBodies[index],
                          onViewDetails: () => _viewDetails(_filteredBodies[index]),
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