import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finance/models/profile_model.dart';
import 'package:finance/components/profile_avatar.dart';
import 'package:finance/utils/style.dart';
import 'package:finance/service/auth_service.dart';
import 'package:finance/config/api_config.dart';
import '../../components/customContainer.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../login/login_screen.dart';
import '../modal/log_out_screen.dart';
import '../../service/currency_service.dart';
import '../../components/currency_selector.dart';
import '../../models/currency_model.dart';
import '../../components/timezone_selector.dart';
import '../../components/edit_profile_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? _profile;
  bool _isLoading = true;
  String? _error;
  int _selectedTabIndex = 0;
  List<Currency> _currencies = [];
  bool _loadingCurrencies = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadCurrencies();
  }

  Future<void> _loadProfile() async {
    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (!isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }

      final headers = await AuthService.getAuthHeaders();
      
      final response = await http.get(
        Uri.parse(ApiConfig.profileUrl),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _profile = Profile.fromJson(data['data']);
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = data['message'] ?? 'Failed to load profile';
            _isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        await AuthService.logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        setState(() {
          _error = 'Failed to load profile. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCurrencies() async {
    try {
      setState(() {
        _loadingCurrencies = true;
      });
      
      final currencies = await CurrencyService.getAllCurrencies();
      final rates = await CurrencyService.getExchangeRates('USD');  // Using USD as base
      
      // Update currencies with exchange rates
      currencies.forEach((currency) {
        currency = Currency(
          code: currency.code,
          name: currency.name,
          symbol: currency.symbol,
          rate: rates[currency.code] ?? 1.0,
        );
      });

      setState(() {
        _currencies = currencies;
        _loadingCurrencies = false;
      });
    } catch (e) {
      print('Error loading currencies: $e');
      setState(() {
        _loadingCurrencies = false;
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

  Future<void> _showCurrencySelector() async {
    if (_loadingCurrencies) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading currencies...')),
      );
      return;
    }

    if (_currencies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No currencies available')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => CurrencySelector(
        currencies: _currencies,
        selectedCurrency: _profile?.currency ?? 'USD',
        onSelect: (currency) async {
          // Update user's currency preference through your API
          // For now, we'll just update the local state
          setState(() {
            _profile = Profile(
              email: _profile!.email,
              displayName: _profile!.displayName,
              phoneNumber: _profile!.phoneNumber,
              currency: currency.code,
              language: _profile!.language,
              timezone: _profile!.timezone,
              notificationPreferences: _profile!.notificationPreferences,
              createdAt: _profile!.createdAt,
              updatedAt: _profile!.updatedAt,
            );
          });
        },
      ),
    );
  }

  Future<void> _showTimezoneSelector() async {
    final selectedTimezone = await showDialog<String>(
      context: context,
      builder: (context) => TimezoneSelector(
        selectedTimezone: _profile?.timezone ?? 'UTC',
      ),
    );

    if (selectedTimezone != null) {
      setState(() {
        _profile = Profile(
          email: _profile!.email,
          displayName: _profile!.displayName,
          phoneNumber: _profile!.phoneNumber,
          currency: _profile!.currency,
          language: _profile!.language,
          timezone: selectedTimezone,
          notificationPreferences: _profile!.notificationPreferences,
          createdAt: _profile!.createdAt,
          updatedAt: _profile!.updatedAt,
        );
      });
    }
  }

  Future<void> _showEditProfileDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => EditProfileDialog(
        currentName: _profile?.displayName ?? '',
        currentPhoneNumber: _profile?.phoneNumber ?? '',
      ),
    );

    if (result != null) {
      setState(() {
        _profile = Profile(
          email: _profile!.email,
          displayName: result['name']!,
          phoneNumber: result['phone']!,
          currency: _profile!.currency,
          language: _profile!.language,
          timezone: _profile!.timezone,
          notificationPreferences: _profile!.notificationPreferences,
          createdAt: _profile!.createdAt,
          updatedAt: _profile!.updatedAt,
        );
      });
    }
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

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProfile,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

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
                      GestureDetector(
                        onTap: _showEditProfileDialog,
                        child: Stack(
                          children: [
                            ProfileAvatar(
                              displayName: _profile?.displayName ?? _profile?.email ?? '',
                              radius: 50,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _profile?.displayName ?? 'User',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _profile?.email ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: AppColors.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.primaryColor,
                    onTap: (index) {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    tabs: const [
                      Tab(text: 'Account'),
                      Tab(text: 'Privacy & Security'),
                      Tab(text: 'About & Legal'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildTabContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Currency'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_loadingCurrencies)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    _profile?.currency ?? 'USD',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onTap: _showCurrencySelector,
            ),
            const Divider(),
            ListTile(
              title: const Text('Language'),
              trailing: Text(
                _profile?.language ?? 'English',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Phone Number'),
              trailing: Text(
                _profile?.phoneNumber ?? 'Not set',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: _showEditProfileDialog,
            ),
            const Divider(),
            ListTile(
              title: const Text('Time Zone'),
              trailing: Text(
                _profile?.timezone ?? 'UTC',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: _showTimezoneSelector,
            ),
            const SizedBox(height: 24),
            if (_profile?.notificationPreferences != null) ...[
              _buildCard(
                icon: Icons.notifications,
                title: 'Notification Preferences',
                subtitle: 'Email: ${_profile!.notificationPreferences!.email ? 'On' : 'Off'}\n'
                    'Push: ${_profile!.notificationPreferences!.push ? 'On' : 'Off'}\n'
                    'SMS: ${_profile!.notificationPreferences!.sms ? 'On' : 'Off'}',
                onTap: () {},
              ),
              const SizedBox(height: 16),
            ],
            _buildCard(
              icon: AppIcons.calendar,
              title: 'Your Subscriptions',
              subtitle: 'Total Subscriptions: 3 active, 5 canceled',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildCard(
              icon: AppIcons.person,
              title: 'Your Activity',
              subtitle: '01. Adjust your spending up by 30%\n02. Allocate the savings elsewhere',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add content for Privacy & Security tab
            const Text(
              'Privacy & Security Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Two-Factor Authentication'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Privacy Settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About & Legal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Learn More',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Learn More',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LogoutDialog(
          onConfirm: _handleLogout,
        );
      },
    );
  }
}