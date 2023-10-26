import 'package:flutter/material.dart';

class MyCPage extends StatelessWidget {
  const MyCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text("Tugas Pertemuan 4"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            height: 90.0,
            width: 270.0,
            color: Colors.blue,
            child: const Center(
              child: Text(
                'Box 1',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  decorationColor: Colors.yellow,
                  decorationStyle: TextDecorationStyle.solid,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            )),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              height: 200.0,
              width: 90.0,
              color: Colors.red,
              child: const Center(
                child: Text(
                  'Box 2',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    decorationColor: Colors.yellow,
                    decorationStyle: TextDecorationStyle.solid,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              )),
          Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              height: 200.0,
              width: 90.0,
              color: Colors.green,
              child: const Center(
                child: Text(
                  'Box 3',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    decorationColor: Colors.yellow,
                    decorationStyle: TextDecorationStyle.solid,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ))
        ])
      ]),
    );
  }
}
