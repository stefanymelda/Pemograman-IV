import 'package:flutter/material.dart';
import 'package:p5_1_1214026/model/tourism_place.dart';

var iniFontCustom = const TextStyle(fontFamily: 'Staatliches');

class DetailScreen extends StatelessWidget {
  final TourismPlace place;
  const DetailScreen({Key? key, required this.place}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Image.asset(place.imageAsset),
        Stack(
          children: <Widget>[
            Image.asset(place.imageAsset),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 16),
          child: Text(
            place.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Icon(Icons.calendar_today,
                      color: Color.fromARGB(255, 0, 156, 5)),
                  const SizedBox(height: 8),
                  Text(
                    place.openDays,
                    style: const TextStyle(fontFamily: 'Staatliches'),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  const Icon(Icons.access_time,
                      color: Color.fromARGB(255, 0, 156, 5)),
                  const SizedBox(height: 8),
                  Text(place.openTime),
                ],
              ),
              Column(
                children: <Widget>[
                  const Icon(Icons.monetization_on,
                      color: Color.fromARGB(255, 0, 156, 5)),
                  const SizedBox(height: 8),
                  Text(place.ticketPrice),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            place.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        // Image.network('images/ranca-upas4.jpg'),
        SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: place.imageUrls.map((url) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(url),
                  ),
                );
              }).toList(),
            ))
      ])),
    );
  }
}
