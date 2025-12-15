import 'package:flutter/material.dart';
import 'package:hr_management/classes/Domain.dart';
import 'package:hr_management/services/speciality_service.dart';

/// Dialog for managing domains (ASM role).
/// Allows creating and deleting domains.
class ManageDomainsDialog extends StatefulWidget {
  const ManageDomainsDialog({super.key});

  @override
  State<ManageDomainsDialog> createState() => _ManageDomainsDialogState();
}

class _ManageDomainsDialogState extends State<ManageDomainsDialog> {
  List<Domain> _domains = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  final TextEditingController _nameController = TextEditingController();
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _fetchDomains();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _fetchDomains() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await SpecialityService.getDomains();
      setState(() {
        _domains = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createDomain() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _isCreating = true;
      _errorMessage = null;
    });

    try {
      await SpecialityService.createDomain(name: name);
      _nameController.clear();
      await _fetchDomains();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isCreating = false;
      });
    }
  }

  Future<void> _deleteDomain(String id) async {
    // Confirm deletion
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this domain? This may affect linked specialties.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await SpecialityService.deleteDomain(domainId: id);
      await _fetchDomains();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Domains'),
      content: SizedBox(
        width: 400,
        height: 500,
        child: Column(
          children: [
            // Add Domain Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'New Domain Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isCreating ? null : _createDomain,
                  icon: _isCreating 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                    : const Icon(Icons.add_circle, color: Color(0xff289581), size: 32),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            
            // Error Message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ),

            // Domains List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _domains.isEmpty 
                      ? const Center(child: Text('No domains found.'))
                      : ListView.separated(
                          itemCount: _domains.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final domain = _domains[index];
                            return ListTile(
                              title: Text(domain.name),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                onPressed: () => _deleteDomain(domain.id),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
