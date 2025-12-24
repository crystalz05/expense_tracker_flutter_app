import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../expenses/presentation/misc/formatter.dart';

class MiniCardWidget extends StatelessWidget {

  final String title;
  final double? data;
  final int? count;

  const MiniCardWidget({
    super.key,
    required this.title,
    this.data,
    this.count
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        width: 150,
        height: 80,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.transparent,
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
              padding: EdgeInsetsDirectional.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.trending_up, size: 18, color: Colors.grey,),
                      SizedBox(width: 8),
                      Text(title, style: TextStyle(color: Colors.grey),)
                    ],
                  ),
                  SizedBox(height: 8,),
                  if(count != null)
                    Text("$count ${(count! <= 1 ? "txn" : "txns")}", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),)
                  else if(data != null)
                    Text("₦${formatter.format(data)}", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),),
                ],
              )
          ),
        )
    );
  }

}