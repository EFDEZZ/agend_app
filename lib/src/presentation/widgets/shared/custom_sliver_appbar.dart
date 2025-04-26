import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatelessWidget {
  final String title;
  const CustomSliverAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    
    return SliverAppBar(
            centerTitle: true,
            pinned: true,
            floating: false,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 0, bottom: 14,),
              centerTitle: true,
              title: Text(
                title,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}