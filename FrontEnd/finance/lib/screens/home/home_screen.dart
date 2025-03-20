import 'package:finance/components/profile_avatar.dart';
import 'package:finance/screens/profile/profile_screen.dart';
import 'package:finance/utils/colors.dart';
import 'package:finance/utils/icons.dart';
import 'package:finance/utils/style.dart';
import 'package:flutter/material.dart';

import '../../components/navigator.dart';
import '../../service/greeting.dart';
import '../../service/auth_service.dart';
import '../notification/notification_screen.dart';
import '../login/login_screen.dart';
import 'add_expences.dart';
import '../achievements/achievements_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userEmail = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }

    final email = await AuthService.getEmail();
    if (email != null) {
      setState(() {
        _userEmail = email;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 16, right: 16),
          decoration: const BoxDecoration(
            color: AppColors.lightPurpleColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(GreetingMessage().getGreeting(),
                          style: AppStyles.body),
                      const SizedBox(height: 4),
                      Text(_userEmail,
                          style: AppStyles.headr),
                      const Text('Welcome to Dashboard',
                          style: AppStyles.body),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                          );
                        },
                        icon: const Icon(Icons.emoji_events, color: Colors.amber),
                        label: const Text('View Achievements'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(AppIcons.notification),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotificationScreen()),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        },
                        child: ProfileAvatar(
                          displayName: _userEmail,
                          radius: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('Total Balance',
                          style: AppStyles.headr),
                      SizedBox(height: 8),
                      const Text('\$50,943',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      const Text('Last 30 Days +12%',
                          style: TextStyle(color: AppColors.statusGreen, fontSize: 16)),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExpenseScreen()),
                      );
                    },
                    child: Icon(AppIcons.addButton),
                    mini: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Column(
              children: [
                _buildInfoTile('Buying Power', '\$580.00'),
                _buildInfoTile('Interest accrued this month', '\$23.20'),
                _buildInfoTile('Lifetime interest paid', '\$86.52'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0, onTap: (index) {}),
    );
  }

  Widget _buildInfoTile(String title, String amount) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightPurpleColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black54)),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}