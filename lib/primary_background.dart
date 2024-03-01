import 'package:flutter/material.dart';

class PrimaryBackground extends StatelessWidget {
  const PrimaryBackground(
      {super.key, required this.child, required this.nameImage});
  final Widget child;
  final String nameImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/backgrounds/$nameImage.png'),
              fit: BoxFit.fill)),
      child: child,
    );
  }
}
