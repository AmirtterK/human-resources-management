import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/types.dart';

User user = User.pm;

final List<Employee> employees = [
  Employee(
    fullName: 'Juan Manuel Fangio',
    rank: 'Gold',
    category: 'A',
    specialty: 'Race Strategy',
    department: 'Team Operations',
    status: Status.toRetire,
  ),
  Employee(
    fullName: 'Mario Andretti',
    rank: 'Gold',
    category: 'A',
    specialty: 'Driver Coaching',
    department: 'Performance',
    status: Status.employed,
  ),
  Employee(
    fullName: 'Nigel Mansell',
    rank: 'Gold',
    category: 'C',
    specialty: 'Telemetry Analysis',
    department: 'Engineering',
    status: Status.employed,
  ),
  Employee(
    fullName: 'Michael Schumacher',
    rank: 'Gold',
    category: 'A',
    specialty: 'Fitness & Training',
    department: 'Sports Science',
    status: Status.employed,
  ),
  Employee(
    fullName: 'Alain Prost',
    rank: 'Gold',
    category: 'C',
    specialty: 'Aerodynamics',
    department: 'R&D',
    status: Status.employed,
  ),
  Employee(
    fullName: 'Niki Lauda',
    rank: 'Gold',
    category: 'C',
    specialty: 'Safety Management',
    department: 'Risk Control',
    status: Status.employed,
  ),
  Employee(
    fullName: 'Jochen Mass',
    rank: 'Gold',
    category: 'B',
    specialty: 'Environmental Strategy',
    department: 'Sustainability',
    status: Status.employed,
  ),
  Employee(
    fullName: 'Jim Clark',
    rank: 'Gold',
    category: 'B',
    specialty: 'Public Relations',
    department: 'Media & Outreach',
    status: Status.employed,
  ),
];
final List<Employee> retiredEmployees = [
  Employee(
    fullName: 'Sebastian Vettel',
    rank: 'Gold',
    category: 'A',
    specialty: 'Race Strategy',
    department: 'Team Operations',
    requestDate: DateTime(2022, 11, 20),
    status: Status.retired,
  ),
  Employee(
    fullName: 'Jenson Button',
    rank: 'Gold',
    category: 'A',
    specialty: 'Driver Coaching',
    department: 'Performance',
    requestDate: DateTime(2016, 11, 27),
    status: Status.retired,
  ),
];

final List<Department> departments = [
  Department(
    id: '1',
    name: 'Race Engineering',
    headName: 'Adrian Newey',
    totalStaffMembers: 45,
    emloyees: employees,
  ),
  Department(
    id: '2',
    name: 'Aerodynamics',
    headName: 'Guenther Steiner',
    totalStaffMembers: 38,
    emloyees: employees,
  ),
  Department(
    id: '3',
    name: 'Strategy',
    headName: 'Hannah Schmitz',
    totalStaffMembers: 22,
    emloyees: employees,
  ),
  Department(
    id: '4',
    name: 'Pit Crew Operations',
    headName: 'Gianpiero Lambiase',
    totalStaffMembers: 28,
    emloyees: employees,
  ),
  Department(
    id: '5',
    name: 'Vehicle Dynamics',
    headName: 'Rob Marshall',
    totalStaffMembers: 35,
    emloyees: employees,
  ),
  Department(
    id: '6',
    name: 'Engine Development',
    headName: 'Andy Cowell',
    totalStaffMembers: 52,
    emloyees: employees,
  ),
  Department(
    id: '6',
    name: 'Engine Development',
    headName: 'Andy Cowell',
    totalStaffMembers: 52,
    emloyees: employees,
  ),
  Department(
    id: '6',
    name: 'Engine Development',
    headName: 'Andy Cowell',
    totalStaffMembers: 52,
    emloyees: employees,
  ),
  Department(
    id: '6',
    name: 'Engine Development',
    headName: 'Andy Cowell',
    totalStaffMembers: 52,
    emloyees: employees,
  ),
];

List<String> domains = ['Surgery Domain'];

final List<Body> bodies = [
  Body(
    id: "#FERR01",
    nameEn: "Ferrari Body",
    nameAr: "هيئة فيراري",
    totalMembers: 3,
    employees: [
      Employee(
        fullName: "Charles Leclerc",
        rank: "Platinum",
        category: "A",
        specialty: "Driver",
        department: "Racing",
        status: Status.employed,
      ),
      Employee(
        fullName: "Carlos Sainz",
        rank: "Gold",
        category: "A",
        specialty: "Driver",
        department: "Racing",
        status: Status.employed,
      ),
      Employee(
        fullName: "Frédéric Vasseur",
        rank: "Diamond",
        category: "Management",
        specialty: "Team Principal",
        department: "Administration",
        status: Status.employed,
      ),
    ],
  ),

  Body(
    id: "#RBR02",
    nameEn: "Red Bull Racing Body",
    nameAr: "هيئة ريد بول",
    totalMembers: 3,
    employees: [
      Employee(
        fullName: "Max Verstappen",
        rank: "Diamond",
        category: "A",
        specialty: "Driver",
        department: "Racing",
        status: Status.employed,
      ),
      Employee(
        fullName: "Sergio Perez",
        rank: "Gold",
        category: "A",
        specialty: "Driver",
        department: "Racing",
        status: Status.employed,
      ),
      Employee(
        fullName: "Christian Horner",
        rank: "Diamond",
        category: "Management",
        specialty: "Team Principal",
        department: "Administration",
        status: Status.employed,
      ),
    ],
  ),

  Body(
    id: "#MER03",
    nameEn: "Mercedes Body",
    nameAr: "هيئة مرسيدس",
    totalMembers: 3,
    employees: [
      Employee(
        fullName: "Lewis Hamilton",
        rank: "Diamond",
        category: "A",
        specialty: "Driver",
        department: "Racing",
        status: Status.employed,
      ),
      Employee(
        fullName: "George Russell",
        rank: "Gold",
        category: "A",
        specialty: "Driver",
        department: "Racing",
        status: Status.employed,
      ),
      Employee(
        fullName: "Toto Wolff",
        rank: "Diamond",
        category: "Management",
        specialty: "Team Principal",
        department: "Administration",
        status: Status.employed,
      ),
    ],
  ),

  Body(
    id: "#MCL04",
    nameEn: "McLaren Body",
    nameAr: "هيئة مكلارين",
    totalMembers: 3,
    employees: [
      Employee(
        fullName: "Lando Norris",
        rank: "Gold",
        category: "A",
        specialty: "Driver",
        department: "Racing",
        status: Status.employed,
      ),
      Employee(
        fullName: "Oscar Piastri",
        rank: "Silver",
        category: "A",
        specialty: "Driver",
        department: "Racing",
        status: Status.employed,
      ),
      Employee(
        fullName: "Andrea Stella",
        rank: "Diamond",
        category: "Management",
        specialty: "Team Principal",
        department: "Administration",
        status: Status.employed,
      ),
    ],
  ),
];
