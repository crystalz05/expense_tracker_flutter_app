
import 'package:flutter/material.dart';

class AddExpenseCategoriesWidget extends StatefulWidget {

  final ValueChanged<String> onCategorySelected;

  const AddExpenseCategoriesWidget({super.key, required this.onCategorySelected});

  @override
  State<StatefulWidget> createState() => _AddExpenseCategoriesWidget();

}

class _AddExpenseCategoriesWidget extends State<AddExpenseCategoriesWidget>{

  String selected = "Food & Dining";

  final List<Map<String, dynamic>> categoriesItem = [
    {'icon': Icons.fastfood_outlined, 'description': 'Food & Dining'},
    {'icon': Icons.emoji_transportation, 'description': 'Transportation'},
    {'icon': Icons.shopping_bag_outlined, 'description': 'Shopping'},
    {'icon': Icons.videogame_asset_outlined, 'description': 'Entertainment'},
    {'icon': Icons.money, 'description': 'Bills & Utilities'},
    {'icon': Icons.health_and_safety, 'description': 'Health'},
    {'icon': Icons.horizontal_distribute_rounded, 'description': 'Others'},
  ];

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
        itemCount: categoriesItem.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            // maxCrossAxisExtent: 200,
            mainAxisExtent: 70,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6, crossAxisCount: 2,
        ),
        itemBuilder: (context, index){
          final item = categoriesItem[index];
          return GestureDetector(
              onTap: () {
                setState(() {
                  selected = item['description'];
                });
                widget.onCategorySelected(selected);
              },
              child: Card(
                  color: selected == item['description'] ? Theme.of(context).colorScheme.surfaceContainerHighest .withValues(alpha: 1) : Theme.of(context).colorScheme.surface,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(width: 1,
                          color: selected == item['description']
                          ? Theme.of(context).colorScheme.outline.withValues(alpha: 1) : // default color
                          Theme.of(context).colorScheme.outline.withValues(alpha: 0.4)),
                  ),
                  child: Padding(padding: EdgeInsetsGeometry.only(left: 8),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(item['icon'], size: 20,),
                        ),
                        SizedBox(width: 8),
                        Text(item['description'], style: Theme.of(context).textTheme.titleMedium)
                      ],
                    ),
                  )
              )
          );
        });
  }
}
