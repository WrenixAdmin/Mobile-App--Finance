import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import '../services/achievement_service.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onShare;

  const AchievementCard({
    Key? key,
    required this.achievement,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          gradient: achievement.unlocked
              ? LinearGradient(
                  colors: [Colors.blue.shade100, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    achievement.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${achievement.points} points',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (achievement.unlocked)
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: onShare,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                achievement.description,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              if (achievement.progress != null) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: achievement.progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    achievement.unlocked ? Colors.green : Colors.blue,
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