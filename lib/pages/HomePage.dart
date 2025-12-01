import 'package:flutter/material.dart';
import 'package:hr_management/components/SideBar.dart';
import 'package:hr_management/tabs/BodiesTab.dart';
import 'package:hr_management/tabs/DomainsTab.dart';
import 'package:hr_management/tabs/EmployeesTab.dart';
import 'package:hr_management/tabs/DepartmentsTab.dart';
import 'package:hr_management/tabs/RequestsTab.dart';
import 'package:hr_management/tabs/RetirementTab.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isExpanded = true;
  int selectedTabIndex = 0;

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
        return const Center(child: Text('Settings'));
      case 7:
        return const Center(child: Text('logout'));
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
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 30,
                  color: Color(0xff017B64),
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xffD45F5F),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
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
          ),
          Expanded(child: _getCurrentTab()),
        ],
      ),
    );
  }
}
