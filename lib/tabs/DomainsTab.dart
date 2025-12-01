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
  bool _isModifying = false;
  String? _selectedDomain;

  void _addDomain() {
    showDialog(
      context: context,
      builder: (context) => const AddDomainDialog(),
    ).then((domainName) {
      if (domainName != null && domainName.isNotEmpty) {
        setState(() {
          domains.add(domainName);
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
    return Container(
      child: _isModifying
          ? DomainDetails(domainName: _selectedDomain!, onReturn: _returnToList)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton.icon(
                    onPressed: _addDomain,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Domains'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.teal,
                      side: const BorderSide(color: Colors.teal),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: domains.length,
                      itemBuilder: (context, index) {
                        return DomainCard(
                          domainName: domains[index],
                          onModify: () => _modifyDomain(domains[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
