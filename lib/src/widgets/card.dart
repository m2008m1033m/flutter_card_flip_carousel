import 'package:flutter/material.dart';

import '../models/card_view_model.dart';

class Card extends StatelessWidget {
  final CardViewModel viewModel;
  final double parallaxPercent;

  Card({this.viewModel, this.parallaxPercent = 0.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // background
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: FractionalTranslation(
            translation: Offset(parallaxPercent * 2.0, 0.0),
            child: OverflowBox(
              maxWidth: double.infinity,
              child: Image.asset(
                viewModel.backdropAssetPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // content
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Text(viewModel.address.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
//                    fontFamily: 'petita',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  )),
            ),
            Expanded(child: Container()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${viewModel.minHeightInFeet} - ${viewModel.maxHeightInFeet}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 140.0,
//                    fontFamily: 'petita',
                    letterSpacing: -5.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0),
                  child: Text(
                    'FT',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
//                        fontFamily: 'petita',
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${viewModel.tempInDegrees}',
                    style: TextStyle(
                        color: Colors.white,
//                        fontFamily: 'petita',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${viewModel.weatherType}',
                        style: TextStyle(
                          color: Colors.white,
//                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Icon(
                          Icons.wb_cloudy,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${viewModel.windSpeedInMph}mpg ${viewModel.cardinalDirection}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
//                          fontFamily: 'petita',
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
