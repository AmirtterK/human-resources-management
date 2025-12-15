import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/types.dart';
import 'package:hr_management/components/StatusChip.dart';
import 'package:hr_management/data/data.dart';
import 'package:intl/intl.dart';

class EmployeesTable extends StatelessWidget {
  final List<Employee> employees;
  final Function(Employee, BuildContext)? onEmployeePressed;

  final String title;

  const EmployeesTable({
    super.key,
    required this.employees,
    this.onEmployeePressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth,
            child: DataTable(
              dividerThickness: 1,
              headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
              columnSpacing: 0,
              horizontalMargin: 24,
              dataRowMinHeight: 56,
              dataRowMaxHeight: 56,
              columns: [
                const DataColumn(
                  label: Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: 50),
                        Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(136, 0, 0, 0),

                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const DataColumn(
                  label: Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            color: Colors.black,
                            thickness: 0.8,
                            width: 1,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Rank',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(136, 0, 0, 0),
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            color: Colors.black,
                            thickness: 0.8,
                            width: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (user != User.agent)
                  DataColumn(
                    label: Expanded(
                      child: Row(
                        children: [
                          const Spacer(),
                          const Text(
                            'Status',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(136, 0, 0, 0),
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                DataColumn(
                  label: Expanded(
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            color: Colors.black,
                            thickness: 0.8,
                            width: 1,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          title == 'ExtendedBodiesTab'
                              ? 'Grade(EN)'
                              : 'Body/Specialty',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(136, 0, 0, 0),

                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            color: Colors.black,
                            thickness: 0.8,
                            width: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Row(
                      children: [
                        const Spacer(),
                        Text(
                          title == 'RetirementTab'
                              ? 'Request Date'
                              : title == 'ExtendedBodiesTab'
                              ? 'Grade(AR)'
                              : 'Department',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(136, 0, 0, 0),

                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),

                if (!(title == "ExtendedBodiesTab") && onEmployeePressed != null)
                  const DataColumn(
                    label: Expanded(child: Center(child: SizedBox(width: 48))),
                  ),
              ],
              rows: employees.map((employee) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey[300],
                            child: Text(
                              employee.fullName[0],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              employee.fullName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Center(child: Text(employee.rank))),
                    if (user != User.agent)
                      DataCell(
                        Center(child: StatusChip(
                          status: employee.status,
                          retireRequest: employee.retireRequest,
                        )),
                      ),
                    if (title == 'ExtendedBodiesTab')
                      DataCell(Center(child: Text(employee.gradeEn ?? '')))
                    else
                      DataCell(Center(child: Text(employee.specialty))),
                    if (title == 'RetirementTab')
                      DataCell(
                        Center(
                          child: Text(
                            DateFormat(
                              'dd/MM/yyyy',
                            ).format(employee.requestDate ?? DateTime.now()),
                          ),
                        ),
                      )
                    else if (title == 'ExtendedBodiesTab')
                      DataCell(Center(child: Text(employee.gradeAr ?? '')))
                    else
                      DataCell(Center(child: Text(employee.department))),
                    if (!(title == "ExtendedBodiesTab") && onEmployeePressed != null)
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Builder(
                            builder: (buttonContext) => IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              onPressed: () => {
                                onEmployeePressed!(employee, buttonContext),
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
