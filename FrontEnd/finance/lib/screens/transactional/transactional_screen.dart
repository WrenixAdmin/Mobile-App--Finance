import 'package:flutter/material.dart';

import '../../components/navigator.dart';

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(160),
        child: Container(
          padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
          decoration: BoxDecoration(
            color: Color(0xFFD7C3FB),
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
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text('Transaction',
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  CircleAvatar(
                    backgroundImage: AssetImage('images/avatar.png'),
                    radius: 20,
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildFilterBar(),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTransactionSection('October, 2024', [
              _buildTransactionItem('Starbucks-Coffee', 'Oct 19, 05:45 AM', '\$12.50'),
              _buildTransactionItem('Uber-Ride', 'Oct 15, 09:10 PM', '\$54.00'),
              _buildTransactionItem('Uber-Ride', 'Oct 12, 02:13 PM', '\$25.00'),
              _buildTransactionItem('Walmart-Household', 'Oct 07, 09:10 PM', '\$10.50'),
              _buildTransactionItem('Pizzahut-chily fry Pizza', 'Oct 02, 01:19 AM', '\$08.00'),
            ]),
            _buildTransactionSection('September, 2024', [
              _buildTransactionItem('Uber-Ride', 'Sep 28, 09:10 PM', '\$13.00'),
              _buildTransactionItem('Walmart-Table', 'Sep 25, 09:10 PM', '\$20.00'),
              _buildTransactionItem('Uber-Ride', 'Sep 22, 10:24 AM', '\$15.00'),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2, onTap: (index) {}),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilterButton('Today'),
          _buildFilterButton('Week'),
          _buildFilterButton('Month', selected: true),
          _buildFilterButton('Year'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: selected ? Colors.purple : Colors.white,
          foregroundColor: selected ? Colors.white : Colors.black54,
          elevation: 0, // Remove shadow
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildTransactionSection(String title, List<Widget> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...transactions,
      ],
    );
  }

  Widget _buildTransactionItem(String name, String date, String amount) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: _getTransactionIcon(name),
        title: Text(name),
        subtitle: Text(date),
        trailing: Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _getTransactionIcon(String name) {
    if (name.contains('Uber')) {
      return CircleAvatar(backgroundColor: Colors.black, child: Text('U', style: TextStyle(color: Colors.white)));
    } else if (name.contains('Walmart')) {
      return CircleAvatar(backgroundColor: Colors.blue, child: Text('W', style: TextStyle(color: Colors.white)));
    } else if (name.contains('Starbucks')) {
      return CircleAvatar(backgroundColor: Colors.green, child: Text('S', style: TextStyle(color: Colors.white)));
    } else if (name.contains('Pizzahut')) {
      return CircleAvatar(backgroundColor: Colors.red, child: Text('P', style: TextStyle(color: Colors.white)));
    } else {
      return CircleAvatar(backgroundColor: Colors.grey, child: Text('T', style: TextStyle(color: Colors.white)));
    }
  }
}
