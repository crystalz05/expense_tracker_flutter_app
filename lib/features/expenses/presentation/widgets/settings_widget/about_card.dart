import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.storage,
              title: 'Data Storage',
              subtitle: 'Local + Cloud sync',
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.update,
              title: 'Auto Sync',
              subtitle: 'Every 15 minutes',
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.delete_sweep,
              title: 'Auto Cleanup',
              subtitle: 'Every 30 days',
            ),
            const Divider(height: 24),
            _InfoRow(
              icon: Icons.info_outline,
              title: 'Version',
              subtitle: '1.0.0',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
