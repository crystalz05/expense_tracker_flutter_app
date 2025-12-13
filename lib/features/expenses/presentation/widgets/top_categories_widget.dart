

import 'package:expenses_tracker_app/features/expenses/presentation/misc/formatter.dart';
import 'package:flutter/material.dart';

class TopCategoriesWidget extends StatelessWidget {

  final Map<String, double> category;
  final String title;
  final String subTitle;
  final IconData icon;

  const TopCategoriesWidget({
    super.key,
    required this.category,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4), width: 0.5)
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.directional(start: 8, end: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18,),
              ),
              SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
              Text(formatter.format(category[title] ?? 0.0), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
              ),
            ],
          ),
        ),
    );
  }
}