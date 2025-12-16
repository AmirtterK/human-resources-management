import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_management/components/SideBar.dart';
import 'package:hr_management/tabs/BodiesTab.dart';
import 'package:hr_management/tabs/DomainsTab.dart';
import 'package:hr_management/tabs/EmployeesTab.dart';
import 'package:hr_management/tabs/DepartmentsTab.dart';
import 'package:hr_management/tabs/RequestsTab.dart';
import 'package:hr_management/tabs/RetirementTab.dart';
import 'package:hr_management/tabs/GradesTab.dart';
import 'package:hr_management/data/data.dart';
import 'package:hr_management/classes/types.dart';

/// Main dashboard widget for the application.
/// Manages the sidebar and the display of different tabs based on selection.
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isExpanded = true;
  late int selectedTabIndex;

  @override
  void initState() {
    super.initState();
    // Set default tab based on user role
    switch (user) {
      case User.pm:
        selectedTabIndex = 0; // Employees
        break;
      case User.agent:
        selectedTabIndex = 0; // Employees
        break;
      case User.archiver:
        selectedTabIndex = 4; // Requests
        break;
    }
  }

  String _getUserRoleTitle() {
    switch (user) {
      case User.pm:
        return 'Personnel Manager';
      case User.agent:
        return 'Agent';
      case User.archiver:
        return 'Archive Manager';
    }
  }

  void _toggleSidebar() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  void _handleLogout() {
    // Navigate to login page
    context.go('/login');
  }

  Widget _getCurrentTab() {
    switch (selectedTabIndex) {
      case 0:
        return const EmployeesTab();
      case 1:
        return const DepartmentsTab();
      case 2:
        return const RetirementTab();
      case 3:
        return const BodiesTab();
      case 4:
        return const RequestsTab();
      case 5:
        return const DomainsTab();
      case 6:
        return const GradesTab();
      case 7:
        return const Center(child: Text('Settings'));
      default:
        return Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: Color(0x2609866F), height: 2.0),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Image.asset('assets/logo.png'),
        ),
        titleSpacing: 15,
        title: const Text(
          'Human Resource Management',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.teal,
          ),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 20, right: 20),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                _getUserRoleTitle(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff017B64),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          SideBar(
            isExpanded: isExpanded,
            onToggle: _toggleSidebar,
            selectedIndex: selectedTabIndex,
            onTabChanged: _onTabChanged,
            onLogout: _handleLogout,
          ),
          Expanded(child: _getCurrentTab()),
        ],
      ),
    );
  }
}
