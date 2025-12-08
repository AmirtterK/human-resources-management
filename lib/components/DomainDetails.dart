import 'package:flutter/material.dart';

class DomainDetails extends StatefulWidget {
  final String domainName;
  final VoidCallback onReturn;

  const DomainDetails({
    super.key,
    required this.domainName,
    required this.onReturn,
  });

  @override
  State<DomainDetails> createState() => _DomainDetailsState();
}

class _DomainDetailsState extends State<DomainDetails> {
  final List<String> _specialties = ['Breast Surgeon'];
  final List<Map<String, String>> _grades = [
    {'name': 'chief', 'code': '707'},
  ];
  final _specialtyController = TextEditingController();
  final _gradeController = TextEditingController();
  final _gradeArController = TextEditingController(); // Added Arabic controller
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _specialtyController.dispose();
    _gradeController.dispose();
    _gradeArController.dispose(); // Dispose Arabic controller
    _codeController.dispose();
    super.dispose();
  }

  void _addSpecialty() {
    if (_specialtyController.text.isNotEmpty) {
      setState(() {
        _specialties.add(_specialtyController.text);
        _specialtyController.clear();
      });
    }
  }

  void _removeSpecialty(int index) {
    setState(() {
      _specialties.removeAt(index);
    });
  }

  void _addGrade() {
    if (_gradeController.text.isNotEmpty) {
      setState(() {
        _grades.add({
          'name': _gradeController.text,
          'nameAr': _gradeArController.text, // Add Arabic name
          'code': _codeController.text,
        });
        _gradeController.clear();
        _gradeArController.clear(); // Clear Arabic controller
        _codeController.clear();
      });
    }
  }

  void _removeGrade(int index) {
    setState(() {
      _grades.removeAt(index);
    });
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
                                  fontSize: 13,fontWeight: FontWeight.w500,
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
                        child: ListView.builder(
                          itemCount: _specialties.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _specialties[index],
                                      style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffEF5350),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () => _removeSpecialty(index),
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

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'List Of Grades',
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
                            flex: 1,
                            child: TextField(
                              controller: _gradeController,
                              decoration: InputDecoration(
                                hintText: 'Grade (EN)',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,fontWeight: FontWeight.w500,
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
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _gradeArController,
                              decoration: InputDecoration(
                                hintText: 'Grade (AR)',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,fontWeight: FontWeight.w500,
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
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _codeController,
                              decoration: InputDecoration(
                                hintText: 'Code',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,fontWeight: FontWeight.w500,
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
                              onPressed: _addGrade,
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
                        child: ListView.builder(
                          itemCount: _grades.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _grades[index]['name']!,
                                      style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _grades[index]['nameAr'] ?? '', // Display nameAr
                                      style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.right, // Standard for Arabic
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 80, // Slightly reduced width for code
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _grades[index]['code']!,
                                    style: const TextStyle(fontSize: 13,fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffEF5350),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () => _removeGrade(index),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
