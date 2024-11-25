import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;

  const MainButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(64.0)),
          gradient: new LinearGradient(
            end: const Alignment(-1, -1),
            begin: const Alignment(1, 1),
            colors: <Color>[
              Colors.pink,
              Colors.blue,
            ],
          ),
        ),
        constraints: const BoxConstraints(
          minHeight: 36.0,
        ), // min sizes for Material buttons
        alignment: Alignment.center,
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
