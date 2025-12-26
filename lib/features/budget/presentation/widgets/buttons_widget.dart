
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/add_budget.dart';

class ButtonsWidget extends StatefulWidget {

  final Color? textColor;
  final Color? color;
  final String buttonName;
  final VoidCallback onPressed;

  const ButtonsWidget({super.key, this.textColor, this.color, required this.buttonName, required this.onPressed});

  @override
  State<StatefulWidget> createState() => _ButtonsWidgetState();

}

class _ButtonsWidgetState extends State<ButtonsWidget> {
  @override
  Widget build(BuildContext context) {
    return
      ElevatedButton(onPressed: (){
        widget.onPressed();
        },
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll( widget.color ??
                  Theme
                      .of(context)
                      .colorScheme
                      .primary),
              padding: WidgetStatePropertyAll(EdgeInsetsGeometry.symmetric(vertical: 18)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            )),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.add, color: Theme
              //     .of(context)
              //     .colorScheme
              //     .onPrimary),
              SizedBox(width: 8,),
              Text(widget.buttonName,
                style: TextStyle(color: widget.textColor ?? Theme
                    .of(context)
                    .colorScheme
                    .onPrimary),
              ),
            ],
          )
      );
  }

}