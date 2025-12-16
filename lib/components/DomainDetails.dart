import 'package:flutter/material.dart';
import 'package:hr_management/classes/Speciality.dart';
import 'package:hr_management/services/speciality_service.dart';

class DomainDetails extends StatefulWidget {
  final String domainId;
  final String domainName;
  final List<Speciality> initialSpecialities;
  final VoidCallback onReturn;

  const DomainDetails({
    super.key,
    required this.domainId,
    required this.domainName,
    required this.onReturn,
    this.initialSpecialities = const [],
  });

  @override
  State<DomainDetails> createState() => _DomainDetailsState();
}

class _DomainDetailsState extends State<DomainDetails> {
  final List<Speciality> _specialties = [];
  final _specialtyController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _specialtyController.dispose();
    super.dispose();
  }

  void _addSpecialty() async {
    if (_specialtyController.text.isEmpty) return;
    try {
      final created = await SpecialityService.createSpeciality(
        domainId: widget.domainId,
        name: _specialtyController.text,
      );
      if (created != null) {
        setState(() {
          _specialties.insert(0, created);
          _specialtyController.clear();
        });
      } else {
        await _fetchSpecialities();
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Speciality added')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  void _removeSpecialty(int index) async {
    final spec = _specialties[index];
    try {
      await SpecialityService.deleteSpeciality(
        specialityId: spec.id.toString(),
      );
      setState(() {
        _specialties.removeAt(index);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Speciality deleted')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    // Use initial specialities from parent domain
    _specialties.addAll(widget.initialSpecialities);
    // If no initial specialities provided, try to fetch
    if (widget.initialSpecialities.isEmpty) {
      _fetchSpecialities();
    }
  }

  Future<void> _fetchSpecialities() async {
    setState(() => _loading = true);
    try {
      final list = await SpecialityService.getSpecialities();
      final did = int.tryParse(widget.domainId);
      final filtered = list.where((s) => s.domainId == did).toList();
      setState(() {
        _specialties.clear();
        _specialties.addAll(filtered);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Domain Of ${widget.domainName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff0A866F),
                ),
              ),
              OutlinedButton.icon(
                onPressed: widget.onReturn,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Return'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xffEF5350),
                  side: const BorderSide(color: Color(0xffEF5350)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 24),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'List Of Specialities',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff0A866F),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _specialtyController,
                              decoration: InputDecoration(
                                hintText: 'Enter Speciality',

                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff0A866F),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: _addSpecialty,
                              icon: const Icon(Icons.add, color: Colors.white),
                              iconSize: 20,
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: _specialties.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey[300]!,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Text(
                                            _specialties[index].name,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffEF5350),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () =>
                                              _removeSpecialty(index),
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                          iconSize: 16,
                                          padding: const EdgeInsets.all(10),
                                          constraints: const BoxConstraints(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
