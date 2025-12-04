# Human Resources Management System

A comprehensive Flutter-based HR Management application for managing employees, departments, organizational bodies, and retirement processes. This application currently uses mock data and is ready to be integrated with your backend API.

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Project Structure](#-project-structure)
- [Data Models](#-data-models)
- [Configuration \& Customization](#-configuration--customization)
- [Backend Integration Guide](#-backend-integration-guide)
- [Setup Instructions](#-setup-instructions)
- [UI Customization](#-ui-customization)

---

## 🎯 Overview

This HR Management system provides a complete interface for:
- **Employee Management**: Track employees with custom ranks, categories, specialties, and departments
- **Department Management**: Organize teams with department heads and staff counts
- **Bodies/Organizations**: Manage organizational bodies (e.g., Ferrari, Red Bull Racing, Mercedes, McLaren) with bilingual support (English/Arabic)
- **Retirement Tracking**: Monitor retirees and retirement requests
- **Domains**: Manage different operational domains
- **Requests Management**: Handle various HR requests

**Current State**: The application uses **mock/static data** defined in `lib/data/data.dart`. You need to replace this with API calls to your backend.

---

## ✨ Features

### 🖥️ User Interface
- **Responsive Sidebar Navigation** with 7 main sections:
  1. Employees
  2. Departments
  3. Retirement
  4. Bodies
  5. Requests
  6. Domains
  7. Settings

- **Custom Theming**:
  - Primary color: Teal (`#09866F`)
  - Custom font family: **Trap** (with Alfont fallback for Arabic)
  - Professional input fields with rounded corners
  - Notification system with badge indicator

### 📊 Data Management
- **Employee Status Tracking**: Employed, To Retire, Retired
- **User Roles**: PM (Project Manager), Agent, Archiver
- **Bilingual Support**: English and Arabic labels for bodies
- **CRUD Operations**: Add, modify, and view employees and departments via dialog modals

---

## 📁 Project Structure

```
lib/
├── classes/              # Data Models
│   ├── Employee.dart     # Employee data model
│   ├── Department.dart   # Department data model
│   ├── Body.dart         # Organizational body model
│   └── types.dart        # Enums (Status, User roles)
│
├── components/           # Reusable UI Components (17 components)
│   ├── AddEmployeeDialog.dart
│   ├── ModifyEmployeeDialog.dart
│   ├── AddBodieDialog.dart
│   ├── EmployeesTable.dart
│   ├── DepartmentCard.dart
│   ├── BodieCard.dart
│   ├── SideBar.dart
│   └── ... (and more)
│
├── data/                 # Mock Data Layer
│   └── data.dart         # ⚠️ REPLACE WITH API CALLS
│
├── pages/                # Main Pages
│   ├── HomePage.dart     # Main dashboard with tabs
│   └── Loginpage.dart    # Login page
│
├── tabs/                 # Tab Content Screens (8 tabs)
│   ├── EmployeesTab.dart
│   ├── DepartmentsTab.dart
│   ├── RetirementTab.dart
│   ├── BodiesTab.dart
│   ├── RequestsTab.dart
│   ├── DomainsTab.dart
│   ├── ExtendedBodiesTab.dart
│   └── ExtendedDepartmentsTab.dart
│
└── main.dart             # App entry point with routing

assets/
├── fonts/                # Custom Trap and Alfont fonts
├── icon/                 # App icons
└── logo.png              # Company logo
```

---

## 🗂️ Data Models

### Employee Model
Located: `lib/classes/Employee.dart`

```dart
class Employee {
  final String fullName;        // Employee full name
  final String rank;            // Rank: "Gold", "Platinum", "Diamond", "Silver"
  final String category;        // Category: "A", "B", "C", "Management"
  final String specialty;       // Job specialty (e.g., "Driver", "Race Strategy")
  final String department;      // Department name
  final Status status;          // employed | toRetire | retired
  final DateTime? requestDate;  // Optional: for retirement requests
  final String? gradeEn;        // Optional: English grade
  final String? gradeAr;        // Optional: Arabic grade
}
```

### Department Model
Located: `lib/classes/Department.dart`

```dart
class Department {
  final String id;                      // Unique department ID
  final String name;                    // Department name
  final String headName;                // Department head name
  final int totalStaffMembers;          // Total staff count
  final List<Employee> emloyees;        // List of employees (note: typo in original)
}
```

### Body Model (Organizational Body)
Located: `lib/classes/Body.dart`

```dart
class Body {
  final String id;                  // Unique ID (e.g., "#FERR01")
  final String nameEn;              // English name
  final String nameAr;              // Arabic name
  final int totalMembers;           // Total members
  final List<Employee> employees;   // List of employees
}
```

### Enums (Types)
Located: `lib/classes/types.dart`

```dart
enum User { pm, agent, archiver }
enum Status { employed, toRetire, retired }
```

---

## ⚙️ Configuration & Customization

### 🎨 1. Theme & Colors
**File**: `lib/main.dart` (lines 22-52)

**Manipulable Parameters**:

| Parameter | Current Value | Description |
|-----------|--------------|-------------|
| `primarySwatch` | `Colors.teal` | Main app color scheme |
| Primary color | `#09866F` | Teal color used throughout |
| Background color | `#F5F5F5` | Light gray background |
| Input fill color | `#F5F5F5` | Input field background |
| Border radius | `12` | Input field corner radius |
| Font family | `'Trap'` | Primary font |
| Font fallback | `['Alfont']` | Arabic font support |

**How to Change**:
```dart
theme: ThemeData(
  primarySwatch: Colors.blue,  // Change to blue
  // Modify other properties...
)
```

### 🚦 2. Routing & Navigation
**File**: `lib/main.dart` (lines 56-62)

**Current Routes**:
- `/home` → `Homepage()`
- `/login` → `Loginpage()`

**Initial Route**: `/home` (line 57)

**How to Add Routes**:
```dart
GoRoute(path: '/new-page', builder: (context, state) => NewPage()),
```

### 👤 3. User Role Configuration
**File**: `lib/data/data.dart` (line 6)

```dart
User user = User.agent;  // Current user role
```

**Available Roles**: `User.pm`, `User.agent`, `User.archiver`

This controls UI permissions and access levels throughout the app.

### 📊 4. Mock Data Configuration
**File**: `lib/data/data.dart`

**⚠️ CRITICAL**: This file contains ALL your mock data and must be replaced with backend API calls.

**Data Collections**:

| Variable | Type | Lines | Description |
|----------|------|-------|-------------|
| `employees` | `List<Employee>` | 8-73 | Active employees (8 items) |
| `retiredEmployees` | `List<Employee>` | 74-93 | Retired employees (2 items) |
| `departments` | `List<Department>` | 95-159 | Departments (9 items, some duplicates) |
| `domains` | `List<String>` | 161 | Domain names |
| `bodies` | `List<Body>` | 163-295 | Organizational bodies (4 items) |

**Example Employee Ranks**: Gold, Platinum, Diamond, Silver
**Example Categories**: A, B, C, Management
**Example Departments**: Racing, Administration, Engineering, R&D, etc.

### 🏢 5. App Branding
**File**: `lib/main.dart` & `lib/pages/HomePage.dart`

| Element | Location | Current Value |
|---------|----------|---------------|
| App title | `main.dart:16` | `'HR MANAGEMENT'` |
| Header title | `HomePage.dart:79` | `'Human Resource Management'` |
| Logo | `HomePage.dart:73` | `assets/logo.png` |
| Notification badge | `HomePage.dart:91-107` | Red dot indicator |

### 🗂️ 6. Tab Configuration
**File**: `lib/pages/HomePage.dart` (lines 33-55)

**Tab Order** (7 tabs available):

```dart
0 → EmployeesTab()
1 → DepartmentsTab()
2 → RetirementTab()
3 → BodiesTab()
4 → RequestsTab()
5 → DomainsTab()
6 → Settings (placeholder)
7 → Logout (placeholder)
```

**To Reorder/Add Tabs**: Modify the `_getCurrentTab()` method and update the sidebar accordingly.

---

## 🔌 Backend Integration Guide

### 📡 Step 1: Add HTTP Package

Add the HTTP client to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  go_router: ^17.0.0
  popover: ^0.3.1
  intl: ^0.20.2
  http: ^1.2.0        # ← ADD THIS
  # or use dio for more features:
  # dio: ^5.4.0
```

Run: `flutter pub get`

### 📂 Step 2: Create API Service Layer

Create `lib/services/api_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/classes/Body.dart';

class ApiService {
  // ⚠️ REPLACE WITH YOUR ACTUAL BACKEND URL
  static const String baseUrl = 'https://your-backend-api.com/api';
  
  // Optional: Add authentication headers
  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer YOUR_TOKEN_HERE',
    };
  }

  // ==================== EMPLOYEES ====================
  
  /// GET /employees - Fetch all employees
  static Future<List<Employee>> getEmployees() async {
    final response = await http.get(
      Uri.parse('$baseUrl/employees'),
      headers: _headers(),
    );
    
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  /// POST /employees - Create new employee
  static Future<Employee> createEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$baseUrl/employees'),
      headers: _headers(),
      body: json.encode(employee.toJson()),
    );
    
    if (response.statusCode == 201) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create employee');
    }
  }

  /// PUT /employees/{id} - Update employee
  static Future<Employee> updateEmployee(String id, Employee employee) async {
    final response = await http.put(
      Uri.parse('$baseUrl/employees/$id'),
      headers: _headers(),
      body: json.encode(employee.toJson()),
    );
    
    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update employee');
    }
  }

  /// DELETE /employees/{id} - Delete employee
  static Future<void> deleteEmployee(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/employees/$id'),
      headers: _headers(),
    );
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete employee');
    }
  }

  /// GET /employees/retired - Fetch retired employees
  static Future<List<Employee>> getRetiredEmployees() async {
    final response = await http.get(
      Uri.parse('$baseUrl/employees/retired'),
      headers: _headers(),
    );
    
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load retired employees');
    }
  }

  // ==================== DEPARTMENTS ====================
  
  /// GET /departments - Fetch all departments
  static Future<List<Department>> getDepartments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/departments'),
      headers: _headers(),
    );
    
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Department.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  // Add similar methods for departments: create, update, delete

  // ==================== BODIES ====================
  
  /// GET /bodies - Fetch all bodies
  static Future<List<Body>> getBodies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bodies'),
      headers: _headers(),
    );
    
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Body.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bodies');
    }
  }

  // Add similar methods for bodies: create, update, delete

  // ==================== DOMAINS ====================
  
  /// GET /domains - Fetch all domains
  static Future<List<String>> getDomains() async {
    final response = await http.get(
      Uri.parse('$baseUrl/domains'),
      headers: _headers(),
    );
    
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<String>();
    } else {
      throw Exception('Failed to load domains');
    }
  }

  // ==================== AUTHENTICATION ====================
  
  /// POST /auth/login - User login
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }
}
```

### 🔄 Step 3: Add JSON Serialization to Models

Update each model to support JSON conversion.

**Example: `lib/classes/Employee.dart`**

```dart
import 'package:hr_management/classes/types.dart';

class Employee {
  final String fullName;
  final String rank;
  final String category;
  final String specialty;
  final String department;
  final Status status;
  final DateTime? requestDate;
  final String? gradeEn;
  final String? gradeAr;
  
  Employee({
    required this.fullName,
    required this.rank,
    required this.category,
    required this.specialty,
    required this.department,
    required this.status,
    this.requestDate, 
    this.gradeEn,
    this.gradeAr,
  });

  // ADD THIS: JSON deserialization
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      rank: json['rank'] ?? '',
      category: json['category'] ?? '',
      specialty: json['specialty'] ?? '',
      department: json['department'] ?? '',
      status: _statusFromString(json['status']),
      requestDate: json['requestDate'] != null 
          ? DateTime.parse(json['requestDate']) 
          : null,
      gradeEn: json['gradeEn'],
      gradeAr: json['gradeAr'],
    );
  }

  // ADD THIS: JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'rank': rank,
      'category': category,
      'specialty': specialty,
      'department': department,
      'status': status.name,
      'requestDate': requestDate?.toIso8601String(),
      'gradeEn': gradeEn,
      'gradeAr': gradeAr,
    };
  }

  // Helper method to convert string to Status enum
  static Status _statusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'employed':
        return Status.employed;
      case 'toretire':
      case 'to_retire':
        return Status.toRetire;
      case 'retired':
        return Status.retired;
      default:
        return Status.employed;
    }
  }
}
```

**Apply similar changes to**:
- `lib/classes/Department.dart`
- `lib/classes/Body.dart`

### 🔄 Step 4: Replace Mock Data with API Calls

**Option A: Replace `lib/data/data.dart` entirely**

```dart
import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/types.dart';
import 'package:hr_management/services/api_service.dart';

// User role (can be fetched from auth service)
User user = User.agent;

// Replace static lists with API futures
Future<List<Employee>> getEmployees() => ApiService.getEmployees();
Future<List<Employee>> getRetiredEmployees() => ApiService.getRetiredEmployees();
Future<List<Department>> getDepartments() => ApiService.getDepartments();
Future<List<Body>> getBodies() => ApiService.getBodies();
Future<List<String>> getDomains() => ApiService.getDomains();
```

**Option B: Use State Management (Recommended for larger apps)**

Consider using:
- **Provider** (simple state management)
- **Riverpod** (modern Provider alternative)
- **Bloc** (for complex state management)
- **GetX** (all-in-one solution)

### 🔄 Step 5: Update UI to Use API Data

**Example: Update `EmployeesTab.dart`**

**Before** (using mock data):
```dart
import 'package:hr_management/data/data.dart';

// In build method
EmployeesTable(employees: employees)
```

**After** (using API):
```dart
import 'package:hr_management/services/api_service.dart';

class _EmployeesTabState extends State<EmployeesTab> {
  late Future<List<Employee>> _employeesFuture;
  
  @override
  void initState() {
    super.initState();
    _employeesFuture = ApiService.getEmployees();
  }
  
  void _refreshData() {
    setState(() {
      _employeesFuture = ApiService.getEmployees();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Employee>>(
      future: _employeesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No employees found'));
        }
        
        return EmployeesTable(employees: snapshot.data!);
      },
    );
  }
}
```

### 🔐 Step 6: Implement Authentication

Update `lib/pages/Loginpage.dart` to call your backend:

```dart
import 'package:hr_management/services/api_service.dart';

// In login button onPressed:
try {
  final result = await ApiService.login(username, password);
  // Store token (use SharedPreferences or secure_storage)
  // Navigate to home page
  context.go('/home');
} catch (e) {
  // Show error dialog
}
```

**Add token storage**:

Add to `pubspec.yaml`:
```yaml
flutter_secure_storage: ^9.0.0
```

Store token:
```dart
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
```

---

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation

1. **Clone the repository** (if applicable):
   ```bash
   git clone <repository-url>
   cd human-resources-management
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure your backend URL**:
   - Create `lib/services/api_service.dart` (see Backend Integration Guide)
   - Update `baseUrl` with your actual backend API URL

4. **Run the app**:
   ```bash
   flutter run
   ```

   For specific platforms:
   ```bash
   flutter run -d chrome          # Web
   flutter run -d windows         # Windows desktop
   flutter run -d android         # Android
   flutter run -d ios             # iOS (macOS only)
   ```

5. **Build for production**:
   ```bash
   flutter build apk              # Android APK
   flutter build appbundle        # Android App Bundle
   flutter build ios              # iOS
   flutter build web              # Web
   flutter build windows          # Windows
   ```

---

## 🎨 UI Customization

### Change Color Scheme

**File**: `lib/main.dart`

```dart
// Teal theme (current)
primarySwatch: Colors.teal,
focusedBorder: BorderSide(color: Color(0xFF09866F)),

// Blue theme
primarySwatch: Colors.blue,
focusedBorder: BorderSide(color: Color(0xFF1976D2)),

// Purple theme
primarySwatch: Colors.deepPurple,
focusedBorder: BorderSide(color: Color(0xFF673AB7)),
```

### Modify Fonts

**Current Setup**:
- Primary: **Trap** (custom font, weights 300-900)
- Fallback: **Alfont** (Arabic support)

**To Add New Fonts**:

1. Add font files to `assets/fonts/`
2. Update `pubspec.yaml`:
   ```yaml
   fonts:
     - family: YourFont
       fonts:
         - asset: assets/fonts/YourFont-Regular.ttf
         - asset: assets/fonts/YourFont-Bold.ttf
           weight: 700
   ```
3. Update `lib/main.dart`:
   ```dart
   fontFamily: 'YourFont',
   ```

### Change Logo

Replace `assets/logo.png` with your company logo (recommended size: 100x80px).

### Customize Sidebar

**File**: `lib/components/SideBar.dart`

Modify icons, labels, and tab order in the sidebar component.

---

## 📊 Backend API Requirements

### Expected Endpoints

Your backend should implement these RESTful endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| **Authentication** |
| POST | `/api/auth/login` | User login, returns token |
| POST | `/api/auth/logout` | User logout |
| **Employees** |
| GET | `/api/employees` | Get all active employees |
| GET | `/api/employees/retired` | Get retired employees |
| GET | `/api/employees/{id}` | Get employee by ID |
| POST | `/api/employees` | Create new employee |
| PUT | `/api/employees/{id}` | Update employee |
| DELETE | `/api/employees/{id}` | Delete employee |
| **Departments** |
| GET | `/api/departments` | Get all departments |
| GET | `/api/departments/{id}` | Get department by ID |
| POST | `/api/departments` | Create department |
| PUT | `/api/departments/{id}` | Update department |
| DELETE | `/api/departments/{id}` | Delete department |
| **Bodies** |
| GET | `/api/bodies` | Get all bodies |
| GET | `/api/bodies/{id}` | Get body by ID |
| POST | `/api/bodies` | Create body |
| PUT | `/api/bodies/{id}` | Update body |
| DELETE | `/api/bodies/{id}` | Delete body |
| **Domains** |
| GET | `/api/domains` | Get all domains |
| POST | `/api/domains` | Create domain |
| DELETE | `/api/domains/{id}` | Delete domain |

### Response Format

All responses should return JSON:

**Success Example**:
```json
{
  "success": true,
  "data": {
    "fullName": "John Doe",
    "rank": "Gold",
    "category": "A",
    "specialty": "Driver",
    "department": "Racing",
    "status": "employed"
  }
}
```

**Error Example**:
```json
{
  "success": false,
  "error": {
    "code": "INVALID_INPUT",
    "message": "Employee name is required"
  }
}
```

---

## 🔧 Common Customization Scenarios

### 1. Add a New Employee Field

**Example**: Add `salary` field

1. Update `lib/classes/Employee.dart`:
   ```dart
   final double? salary;
   
   Employee({
     // existing fields...
     this.salary,
   });
   
   // Update fromJson and toJson
   ```

2. Update `lib/data/data.dart` mock data (or API response)
3. Update UI components to display the new field

### 2. Change Employee Ranks

**File**: `lib/data/data.dart` and UI components

Current ranks: `Gold`, `Platinum`, `Diamond`, `Silver`

To add new rank: Simply use the new rank string in your data.

### 3. Modify Department Structure

Edit `lib/classes/Department.dart` to add fields like:
- `location`
- `budget`
- `establishedDate`

### 4. Add New Tab

1. Create new tab file: `lib/tabs/YourNewTab.dart`
2. Update `lib/pages/HomePage.dart`:
   ```dart
   case 8:
     return const YourNewTab();
   ```
3. Update sidebar to include the new tab

---

## 📞 Support & Documentation

### Flutter Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Go Router Package](https://pub.dev/packages/go_router)
- [HTTP Package](https://pub.dev/packages/http)
- [Dio Package](https://pub.dev/packages/dio) (alternative HTTP client)

### Key Files to Modify for Backend Integration

| Priority | File | Purpose |
|----------|------|---------|
| 🔴 HIGH | `lib/data/data.dart` | Replace mock data with API calls |
| 🔴 HIGH | `lib/services/api_service.dart` | Create this for API communication |
| 🔴 HIGH | `lib/classes/*.dart` | Add JSON serialization |
| 🟡 MEDIUM | `lib/tabs/*.dart` | Update to use FutureBuilder/StreamBuilder |
| 🟡 MEDIUM | `lib/pages/Loginpage.dart` | Implement real authentication |
| 🟢 LOW | `lib/main.dart` | Update theme/branding |

---

## ⚠️ Important Notes

1. **Security**: Never hardcode API tokens or sensitive data in the code. Use environment variables or secure storage.

2. **Error Handling**: Implement proper error handling for network failures, timeouts, and invalid responses.

3. **Loading States**: Always show loading indicators when fetching data from the backend.

4. **Data Validation**: Validate all user inputs before sending to the backend.

5. **Offline Support**: Consider implementing offline caching using packages like:
   - `hive` or `sqflite` for local database
   - `cached_network_image` for image caching

6. **State Management**: For production apps, use a proper state management solution (Provider, Riverpod, Bloc).

7. **Testing**: Write unit tests for API services and integration tests for critical user flows.

---

## 📝 Next Steps

### Immediate Actions Required:

- [ ] Set up your backend API with the required endpoints
- [ ] Add `http` or `dio` package to `pubspec.yaml`
- [ ] Create `lib/services/api_service.dart`
- [ ] Add JSON serialization to all data models
- [ ] Update `lib/data/data.dart` to use API calls
- [ ] Implement authentication flow
- [ ] Update all tabs to use FutureBuilder/API data
- [ ] Test CRUD operations with your backend
- [ ] Add error handling and loading states
- [ ] Implement token storage and refresh logic

### Optional Enhancements:

- [ ] Add pagination for large employee lists
- [ ] Implement search and filtering
- [ ] Add data export (PDF/Excel)
- [ ] Real-time notifications using WebSockets
- [ ] Multi-language support (i18n)
- [ ] Dark mode theme
- [ ] Analytics and reporting dashboard

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────┐
│              UI Layer (Flutter)              │
│  ┌─────────┐  ┌──────────┐  ┌────────────┐ │
│  │  Pages  │  │   Tabs   │  │ Components │ │
│  └─────────┘  └──────────┘  └────────────┘ │
└───────────────────┬─────────────────────────┘
                    │
          ┌─────────▼──────────┐
          │  State Management  │ ← Add Provider/Riverpod
          │   (if applicable)  │
          └─────────┬──────────┘
                    │
          ┌─────────▼──────────┐
          │   API Service      │ ← CREATE THIS
          │  (api_service.dart)│
          └─────────┬──────────┘
                    │
          ┌─────────▼──────────┐
          │   Data Models      │ ← Add JSON serialization
          │  (Employee, etc.)  │
          └─────────┬──────────┘
                    │
          ┌─────────▼──────────┐
          │  Your Backend API  │ ← IMPLEMENT THIS
          │   (REST/GraphQL)   │
          └────────────────────┘
```

---

**Version**: 1.0.0  
**Last Updated**: December 2025  
**Flutter SDK**: 3.8.1+

For questions or issues, please contact your development team.
