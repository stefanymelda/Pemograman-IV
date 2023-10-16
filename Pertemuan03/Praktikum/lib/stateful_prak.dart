import 'package:flutter/material.dart';

class BiggerText extends StatefulWidget {
  final String teks;

  const BiggerText({Key? key, required this.teks}) : super(key: key);

  @override
  State<BiggerText> createState() => _BiggerTextState();
}

class _BiggerTextState extends State<BiggerText> {
  double _textSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.teks,
          style: TextStyle(fontSize: _textSize),
        ),
        ElevatedButton(
          child: Text(_textSize == 16.0 ? "Perbesar" : "Perkecil"),
          onPressed: () {
            setState(() {
              _textSize = _textSize == 16.0 ? 25.0 : 16.0;
            });
          },
        )
      ],
    );
  }
}
