import 'package:finance/utils/icons.dart';
import 'package:flutter/material.dart';
import '../../components/navigator.dart';
import '../../components/profile_avatar.dart';
import '../../service/greeting.dart';
import '../../utils/colors.dart';
import '../../utils/style.dart';
import '../profile/profile_screen.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: Container(
          padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
          decoration: BoxDecoration(
            color: AppColors.lightPurpleColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text('Notifications', style: AppStyles.title),
                  CircleAvatar(
                    backgroundImage: AssetImage('images/avatar.png'),
                    radius: 20,
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search notifications...',
                  prefixIcon: Icon(AppIcons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationItem(
              "Warning: You've exceeded your monthly food budget by 15%! Adjust your spending up by 30%.",
              "Approve",
              "Decline",
              "Last Wednesday at 9:42 AM",
            ),
            _buildNotificationItem(
              "Reminder: Your Netflix subscription (\$15.99) will be charged tomorrow.",
              null,
              null,
              "Last Wednesday at 9:42 AM",
            ),
            _buildNotificationItem(
              "Great job! You've saved 10% more this month compared to last month. Keep it up!",
              null,
              null,
              "Last Wednesday at 9:42 AM",
            ),
            _buildNotificationItem(
              "Your entertainment spending is 25% lower this month. Want to allocate the savings elsewhere?",
              "Approve",
              "Decline",
              "Last Wednesday at 9:42 AM",
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation logic
        },
      ),
    );
  }

  Widget _buildNotificationItem(String message, String? approveText, String? declineText, String time) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            if (approveText != null && declineText != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(approveText, style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(declineText, style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            SizedBox(height: 8),
            Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
