import 'package:flutter/material.dart';

import '../models/card_view_model.dart' show demoCards;
import '../widgets/bottom_bar.dart';
import '../widgets/card_flipper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double scrollPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Room for status bar,
          Container(
            width: double.infinity,
            height: 20.0,
          ),

          // Cards
          Expanded(
            child: CardFlipper(
                cards: demoCards,
                onScroll: (double scrollPercent) {
                  setState(() {
                    this.scrollPercent = scrollPercent;
                  });
                }),
          ),

          // Bottom Bar
          BottomBar(
            scrollPercent: scrollPercent,
            cardCount: demoCards.length,
          )
        ],
      ),
    );
  }
}
