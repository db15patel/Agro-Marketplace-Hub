import 'package:agrocart/utils/agrocart.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: AgrocartUniversal.customBoxShadow,
        color: AgrocartUniversal.contrastColor,
      ),
      height: 80,
      width: 80,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
