import 'package:flutter/material.dart';
import 'package:hr_management/components/AddDomainDialog.dart';
import 'package:hr_management/components/DomainCard.dart';
import 'package:hr_management/components/DomainDetails.dart';

class DomainsTab extends StatefulWidget {
  const DomainsTab({super.key});

  @override
  State<DomainsTab> createState() => _DomainsTabState();
}

class _DomainsTabState extends State<DomainsTab> {
  List<String> domains = ['Surgery Domain'];
  List<String> _filteredDomains = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isModifying = false;
  String? _selectedDomain;

  @override
  void initState() {
    super.initState();
    _filteredDomains = domains;
    _searchController.addListener(_filterDomains);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDomains() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredDomains = domains;
      } else {
        _filteredDomains = domains.where((domain) {
          return domain.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _addDomain() {
    showDialog(
      context: context,
      builder: (context) => const AddDomainDialog(),
    ).then((domainName) {
      if (domainName != null && domainName.isNotEmpty) {
        setState(() {
          domains.add(domainName);
          _filterDomains(); // Re-filter to include new domain if it matches
        });
      }
    });
  }

  void _modifyDomain(String domainName) {
    setState(() {
      _isModifying = true;
      _selectedDomain = domainName;
    });
  }

  void _returnToList() {
    setState(() {
      _isModifying = false;
      _selectedDomain = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isModifying) {
      return DomainDetails(
          domainName: _selectedDomain!, onReturn: _returnToList);
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
                          'Domains',
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
                                hintText: 'Search by Name',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        OutlinedButton.icon(
                          onPressed: _addDomain,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Domains'),
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
                      itemCount: _filteredDomains.length,
                      itemBuilder: (context, index) {
                        return DomainCard(
                          domainName: _filteredDomains[index],
                          onModify: () => _modifyDomain(_filteredDomains[index]),
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
