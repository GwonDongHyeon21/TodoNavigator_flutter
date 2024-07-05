import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemoContent extends StatelessWidget {
  final String title;
  final DateTime date;
  final String startLocation;
  final String endLocation;

  const MemoContent({
    Key? key,
    required this.title,
    required this.date,
    required this.startLocation,
    required this.endLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MM월 dd일').format(date);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          formattedDate,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '지도',
              style: TextStyle(fontSize: 60),
            ),
            Text(
              'startLocation: $startLocation',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'endLocation: $endLocation',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
