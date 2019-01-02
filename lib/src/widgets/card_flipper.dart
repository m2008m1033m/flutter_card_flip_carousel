import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import './card.dart' as myWidget;
import '../models/card_view_model.dart';

class CardFlipper extends StatefulWidget {
  final List<CardViewModel> cards;
  final Function(double scrollPercent) onScroll;

  CardFlipper({
    this.cards,
    this.onScroll,
  });

  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper>
    with TickerProviderStateMixin {
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  Matrix4 _buildCardProjection(double scrollPercent) {
    final perspective = Matrix4.identity()
      ..setEntry(3, 2, -0.001); // perspective

    print(scrollPercent);

    final angle = (60.0 * scrollPercent * pi) / 180.0;
    final rotating = Matrix4.identity()
      ..setEntry(0, 0, cos(angle))
      ..setEntry(0, 2, sin(angle))
      ..setEntry(2, 0, -sin(angle))
      ..setEntry(2, 2, cos(angle));

//    final scale = 0.75 * scrollPercent;
//    final resizing = Matrix4.identity()
//      ..setEntry(0, 0, scale)
//      ..setEntry(1, 1, scale)
//      ..setEntry(2, 2, scale);
////
//    final distance = 5000.0;
//    final translating = Matrix4.identity()
//      ..setEntry(0, 3, 0.0)
//      ..setEntry(1, 3, 0.0)
//      ..setEntry(2, 3, distance);
//
    return perspective * rotating;

// Pre-multiplied matrix of a projection matrix and a view matrix.

//     Projection matrix is a simplified perspective matrix
//     http://web.iitd.ac.in/~hegde/cad/lecture/L9_persproj.pdf
//     in the form of
//     [[1.0, 0.0, 0.0, 0.0],
//      [0.0, 1.0, 0.0, 0.0],
//      [0.0, 0.0, 1.0, 0.0],
//      [0.0, 0.0, -perspective, 1.0]]

//     View matrix is a simplified camera view matrix.
//     Basically re-scales to keep object at original size at angle = 0 at
//     any radius in the form of
//     [[1.0, 0.0, 0.0, 0.0],
//      [0.0, 1.0, 0.0, 0.0],
//      [0.0, 0.0, 1.0, -radius],
//      [0.0, 0.0, 0.0, 1.0]]
//    final perspective = 0.002;
//    final radius = 1.0;
//    final angle = scrollPercent * pi / 8;
//    final horizontalTranslation = 0.0;
//    Matrix4 projection = new Matrix4.identity()
//      ..setEntry(0, 0, 1 / radius)
//      ..setEntry(1, 1, 1 / radius)
//      ..setEntry(3, 2, -perspective)
//      ..setEntry(2, 3, -radius)
//      ..setEntry(3, 3, perspective * radius + 1.0);
//
//    // Model matrix by first translating the object from the origin of the world
//    // by radius in the z axis and then rotating against the world.
//    final rotationPointMultiplier = angle > 0.0 ? angle / angle.abs() : 1.0;
//    projection *= new Matrix4.translationValues(
//            horizontalTranslation + (rotationPointMultiplier * 300.0),
//            0.0,
//            0.0) *
//        new Matrix4.rotationY(angle) *
//        new Matrix4.translationValues(0.0, 0.0, radius) *
//        new Matrix4.translationValues(
//            -rotationPointMultiplier * 300.0, 0.0, 0.0);
//
//    return projection;
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;

    final numCards = widget.cards.length;

    setState(() {
      scrollPercent =
          (startDragPercentScroll + (-singleCardDragPercent / numCards))
              .clamp(0.0, 1.0 - (1 / numCards));

      if (widget.onScroll != null) {
        widget.onScroll(scrollPercent);
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final numCards = widget.cards.length;

    finishScrollStart = scrollPercent;
    finishScrollEnd = (scrollPercent * numCards).round() / numCards;

    finishScrollController.forward(from: 0.0);

    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }

  List<Widget> _buildCards() {
    final numCards = widget.cards.length;

    int index = -1;
    return widget.cards
        .map((c) => _buildCard(c, ++index, numCards, scrollPercent))
        .toList();
  }

  Widget _buildCard(CardViewModel viewModel, int cardIndex, int cardCount,
      double scrollPercent) {
    final cardScrollPercent = scrollPercent / (1 / cardCount);
    final parallax = scrollPercent - (cardIndex / cardCount);

    return FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Transform(
          alignment: Alignment.center,
          transform: _buildCardProjection(cardScrollPercent - cardIndex),
          child: myWidget.Card(
            viewModel: viewModel,
            parallaxPercent: parallax,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    finishScrollController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this)
      ..addListener(() {
        setState(() {
          scrollPercent = lerpDouble(
              finishScrollStart, finishScrollEnd, finishScrollController.value);

          if (widget.onScroll != null) {
            widget.onScroll(scrollPercent);
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }

  @override
  void dispose() {
    finishScrollController.dispose();
    super.dispose();
  }
}
