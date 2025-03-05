import 'package:finance/utils/style.dart';
import 'package:flutter/material.dart';
import '../../components/customContainer.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../modal/log_out_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CustomContainer(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Profile & Settings',
                        style: AppStyles.headr,
                      ),
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/avatar.png'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Nico Robin',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'nico@gmail.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Change profile',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: AppColors.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.purple,
                    tabs: [
                      Tab(text: 'Account'),
                      Tab(text: 'Privacy & Security'),
                      Tab(text: 'Notification'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Currency'),
                          trailing: Text('\$ USD', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Theme'),
                          trailing: Text('Light', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 24),
                        _buildCard(
                          icon: Icons.calendar_today,
                          title: 'Your Subscriptions',
                          subtitle: 'Total Subscriptions: 3 active, 5 canceled',
                          onTap: () {},
                        ),
                        SizedBox(height: 16),
                        _buildCard(
                          icon: Icons.person,
                          title: 'Your Activity',
                          subtitle: '01. Adjust your spending up by 30%\n02. Allocate the savings elsewhere',
                          onTap: () {},
                        ),
                        SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _showLogoutDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Log Out',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
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
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.purple, size: 28),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Icon(AppIcons.arrowForward, color: AppColors.primaryColor, size: 18),
          ],
        ),
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return LogoutDialog(
        onConfirm: () {
          print("User Logged Out!");
        },
      );
    },
  );
}
