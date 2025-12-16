import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/types.dart';

// This file retains global state for the application, such as the current user and lists of data.

/// The currently logged-in user type.
User user = User.archiver;

List<Body> bodies = [];
List<Department> departments = [];
List<Employee> employees = [];
List<Employee> retiredEmployees = [];