import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MapNavigator extends StatelessWidget {
  final String title;
  final DateTime date;
  final String startLocation;
  final String endLocation;

  const MapNavigator({
    Key? key,
    required this.title,
    required this.date,
    required this.startLocation,
    required this.endLocation,
  }) : super(key: key);

  Future<void> _launchGoogleMaps(String start, String end) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$start&destination=$end&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MM월 dd일').format(date);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '지도',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () => _launchGoogleMaps(startLocation, endLocation),
              child: const Text('Google Maps로 길찾기'),
            ),
            const SizedBox(height: 10),
            Text(
              '출발지: $startLocation',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '목적지: $endLocation',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
