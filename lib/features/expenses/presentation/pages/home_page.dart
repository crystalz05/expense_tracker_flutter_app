
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                ),
              ),
            ],
          )
      ),
    );
  }
}