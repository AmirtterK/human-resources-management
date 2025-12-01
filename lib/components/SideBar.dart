import 'package:flutter/material.dart';
import 'package:hr_management/classes/types.dart';
import 'package:hr_management/data/data.dart';

class SideBar extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final int selectedIndex;
  final Function(int) onTabChanged;

  const SideBar({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool showText = false;

  @override
  void initState() {
    super.initState();
    showText = widget.isExpanded;
  }

  @override
  void didUpdateWidget(SideBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              showText = true;
            });
          }
        });
      } else {
        setState(() {
          showText = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _getMenuItemsForUser(User userType) {
    switch (userType) {
      case User.pm:
        return [
          {'image': 'assets/icon/card.png', 'title': 'Employees', 'index': 0},
          {
            'image': 'assets/icon/departement.png',
            'title': 'Departments',
            'index': 1,
          },
          {
            'image': 'assets/icon/retirement.png',
            'title': 'Retirement',
            'index': 2,
          },
        ];
      case User.agent:
        return [
          {'image': 'assets/icon/card.png', 'title': 'Employees', 'index': 0},
          {'image': 'assets/icon/person.png', 'title': 'Bodies', 'index': 3},
        ];
      case User.archiver:
        return [
          {'image': 'assets/icon/consult.png', 'title': 'Requests', 'index': 4},
          {
            'image': 'assets/icon/retirement.png',
            'title': 'Retirement',
            'index': 2,
          },
          {'image': 'assets/icon/domain.png', 'title': 'Domains', 'index': 5},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = _getMenuItemsForUser(user);

    return AnimatedContainer(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Color(0x2609866F), width: 2)),
        color: Colors.white,
      ),
      duration: const Duration(milliseconds: 200),
      width: widget.isExpanded ? 200 : 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(),
          _buildNavigationLabel(),
          _buildDivider(),
          ...menuItems.expand(
            (item) => [
              _buildMenuItem(
                image: item['image'],
                title: item['title'],
                index: item['index'],
              ),
              _buildDivider(),
            ],
          ),
          const Spacer(),
          _buildSettingsLabel(),
          _buildDivider(),
          _buildMenuItem(
            image: 'assets/icon/logout.png',
            title: 'Logout',
            index: 6,
            isLogout: true,
          ),
          _buildMenuItem(
            image: 'assets/icon/settings.png',
            title: 'General Settings',
            index: 7,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildToggleButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Material(
        child: InkWell(
          onTap: widget.onToggle,
          child: Tooltip(
            message: widget.isExpanded ? 'collapse' : 'expand',
            child: RotatedBox(
              quarterTurns: widget.isExpanded ? 2 : 0,
              child: Image.asset(
                'assets/icon/arrow-right.png',
                width: 30,
                height: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      child: Divider(color: Color(0xff09866F), thickness: 1.5),
    );
  }

  Widget _buildSettingsLabel() {
    if (!showText) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Settings',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationLabel() {
    if (!showText) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Navigation Menu',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String image,
    required String title,
    required int index,
    bool isLogout = false,
  }) {
    final isSelected = widget.selectedIndex == index;
    return Tooltip(
      message: !showText ? title : '',
      child: InkWell(
        onTap: () {
          widget.onTabChanged(index);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: showText ? 12 : 0,
            vertical: 10,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: showText ? 8 : 16,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.teal.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: showText
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Image.asset(image, width: 25, height: 25),
              if (showText) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isLogout
                          ? Colors.red
                          : (isSelected ? Colors.teal : Colors.grey[800]),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
