import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  BottomButton({required this.text, required this.onPressed});

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFA41B),
      ),
      child: Text(text,
          style: TextStyle(
            color: const Color(0xFFF5F5F5),
            fontSize: 20,
          )),
    );
  }
}
