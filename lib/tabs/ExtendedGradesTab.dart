import 'package:flutter/material.dart';
import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/classes/Grade.dart';
import 'package:hr_management/services/grade_service.dart';

class ExtendedGradesTab extends StatefulWidget {
  final Body? body;
  final VoidCallback onReturn;
  const ExtendedGradesTab({
    super.key,
    required this.body,
    required this.onReturn,
  });

  @override
  State<ExtendedGradesTab> createState() => _ExtendedGradesTabState();
}

class _ExtendedGradesTabState extends State<ExtendedGradesTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Grade> _grades = [];
  List<Grade> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchGrades();
    _searchController.addListener(_filter);
  }

  Future<void> _fetchGrades() async {
    final id = widget.body?.id ?? '';
    try {
      final list = await GradeService.getGradesByBody(id);
      setState(() {
        _grades = list;
        _filtered = list;
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
        _filtered = _grades;
      } else {
        _filtered = _grades.where((g) {
          return g.code.toLowerCase().contains(q) ||
              g.designationFR.toLowerCase().contains(q) ||
              g.designationAR.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  Future<void> _showCreateDialog() async {
    final codeCtrl = TextEditingController();
    final frCtrl = TextEditingController();
    final arCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Grade'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeCtrl,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: frCtrl,
                decoration: const InputDecoration(labelText: 'Designation FR'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: arCtrl,
                decoration: const InputDecoration(labelText: 'Designation AR'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        await GradeService.createGrade(
          bodyId: widget.body!.id,
          code: codeCtrl.text,
          designationFR: frCtrl.text,
          designationAR: arCtrl.text,
        );
        await _fetchGrades();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Grade created')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Future<void> _showModifyDialog(Grade grade) async {
    final codeCtrl = TextEditingController(text: grade.code);
    final frCtrl = TextEditingController(text: grade.designationFR);
    final arCtrl = TextEditingController(text: grade.designationAR);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modify Grade'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeCtrl,
                decoration: const InputDecoration(labelText: 'Code'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: frCtrl,
                decoration: const InputDecoration(labelText: 'Designation FR'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: arCtrl,
                decoration: const InputDecoration(labelText: 'Designation AR'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        await GradeService.modifyGrade(
          bodyId: widget.body!.id,
          gradeId: grade.id,
          code: codeCtrl.text,
          designationFR: frCtrl.text,
          designationAR: arCtrl.text,
        );
        await _fetchGrades();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Grade modified')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Future<void> _deleteGrade(Grade grade) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Grade'),
        content: Text('Delete ${grade.code}?'),
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
      try {
        await GradeService.deleteGrade(
          bodyId: widget.body!.id,
          gradeId: grade.id,
        );
        await _fetchGrades();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Grade deleted')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 20,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "${widget.body!.nameEn} / ",
                          style: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        Text(
                          " ${widget.body!.nameAr}",
                          style: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 24,
                            fontFamily: 'Alfont',
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: widget.onReturn,
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: const Text('Return'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xffEF5350),
                            side: const BorderSide(color: Color(0xffEF5350)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: _fetchGrades,
                          icon: const Icon(Icons.refresh, color: Colors.teal),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search grades',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _showCreateDialog,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.teal,
                            side: const BorderSide(color: Colors.teal),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text('Add Grade'),
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
                              final g = _filtered[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      g.code,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Text(
                                      '|',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      g.designationFR,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Text(
                                      '|',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      g.designationAR,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontFamily: 'Alfont',
                                      ),
                                    ),
                                    const Spacer(),
                                    OutlinedButton(
                                      onPressed: () => _showModifyDialog(g),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.teal,
                                        side: const BorderSide(
                                          color: Colors.teal,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Modify'),
                                    ),
                                    const SizedBox(width: 12),
                                    OutlinedButton(
                                      onPressed: () => _deleteGrade(g),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
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
