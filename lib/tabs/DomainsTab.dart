import 'package:flutter/material.dart';
import 'package:hr_management/components/AddDomainDialog.dart';
import 'package:hr_management/components/DomainCard.dart';
import 'package:hr_management/components/DomainDetails.dart';
import 'package:hr_management/classes/Domain.dart';
import 'package:hr_management/services/domain_service.dart';

/// Tab for displaying and managing functionality domains.
class DomainsTab extends StatefulWidget {
  const DomainsTab({super.key});

  @override
  State<DomainsTab> createState() => _DomainsTabState();
}

class _DomainsTabState extends State<DomainsTab> {
  List<Domain> domains = [];
  List<Domain> _filteredDomains = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isModifying = false;
  Domain? _selectedDomain;

  @override
  void initState() {
    super.initState();
    _fetchDomains();
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
          return domain.name.toLowerCase().contains(query) ||
              domain.id.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _addDomain() {
    showDialog(
      context: context,
      builder: (context) => const AddDomainDialog(),
    ).then((domainName) async {
      if (domainName != null && domainName.isNotEmpty) {
        try {
          final created = await DomainService.createDomain(domainName);
          if (created != null) {
            setState(() {
              domains.insert(0, created);
              _filterDomains();
            });
          } else {
            await _fetchDomains();
          }
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Domain created')));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
        }
      }
    });
  }

  void _modifyDomain(Domain domain) {
    setState(() {
      _isModifying = true;
      _selectedDomain = domain;
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
        domainId: _selectedDomain!.id,
        domainName: _selectedDomain!.name,
        onReturn: _returnToList,
        initialSpecialities: _selectedDomain!.specialities,
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
                          'Domains',
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff289581),
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
                            foregroundColor: Color(0xff289581),
                            side: const BorderSide(color: Color(0xff289581)),
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
                        final d = _filteredDomains[index];
                        return DomainCard(
                          domainName: d.name,
                          onModify: () => _modifyDomain(d),
                          onDelete: () async {
                            try {
                              await DomainService.deleteDomain(d.id);
                              setState(() {
                                domains.removeWhere((x) => x.id == d.id);
                                _filteredDomains.removeWhere((x) => x.id == d.id);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Domain deleted')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                            }
                          },
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

  Future<void> _fetchDomains() async {
    try {
      final list = await DomainService.getDomains();
      setState(() {
        domains = list;
        _filteredDomains = list;
      });
    } catch (e) {
      // keep empty
    }
  }
}
