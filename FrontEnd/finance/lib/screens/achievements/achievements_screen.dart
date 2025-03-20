import 'package:flutter/material.dart';
import '../../models/achievement_model.dart';
import '../../services/achievement_service.dart';
import '../../components/achievement_card.dart';
import '../../components/achievement_popup.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<Achievement> _achievements = [];
  List<Achievement> _allAchievements = [];
  int _totalPoints = 0;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadAchievements();
    _checkNewAchievements();
  }

  Future<void> _loadAchievements() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final data = await AchievementService.getUserAchievements();
      setState(() {
        _achievements = data['achievements'];
        _allAchievements = data['allAchievements'];
        _totalPoints = data['totalPoints'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _checkNewAchievements() async {
    try {
      final newAchievements = await AchievementService.checkNewAchievements();
      if (newAchievements.isNotEmpty) {
        for (final achievement in newAchievements) {
          _showAchievementPopup(achievement);
        }
        _loadAchievements(); // Reload achievements to update the list
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _showAchievementPopup(Achievement achievement) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AchievementPopup(
        achievement: achievement,
        onDismiss: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _shareAchievement(Achievement achievement) async {
    try {
      await AchievementService.shareAchievement(achievement.id, 'general');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Achievement shared successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share achievement: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAchievements,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAchievements,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue.shade50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.stars, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            'Total Points: $_totalPoints',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _allAchievements.length,
                        itemBuilder: (context, index) {
                          final achievement = _allAchievements[index];
                          return AchievementCard(
                            achievement: achievement,
                            onShare: achievement.unlocked
                                ? () => _shareAchievement(achievement)
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
} 