// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MemoContent extends StatefulWidget {
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
  // ignore: library_private_types_in_public_api
  _MemoContentState createState() => _MemoContentState();
}

class _MemoContentState extends State<MemoContent> {
  GoogleMapController? _controller;
  Set<Polyline> _polylines = {};
  LatLng? _startLatLng;
  LatLng? _endLatLng;

  @override
  void initState() {
    super.initState();
    //_getDirections();
  }

  /*
  Future<void> _getDirections() async {
    // Convert start and end locations to LatLng
    final startCoordinates = widget.startLocation.split(',');
    final endCoordinates = widget.endLocation.split(',');

    _startLatLng = LatLng(
      double.parse(startCoordinates[0]),
      double.parse(startCoordinates[1]),
    );
    _endLatLng = LatLng(
      double.parse(endCoordinates[0]),
      double.parse(endCoordinates[1]),
    );

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.startLocation}&destination=${widget.endLocation}&key=YOUR_GOOGLE_API_KEY';

    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    if (json['status'] == 'OK') {
      final points = json['routes'][0]['overview_polyline']['points'];
      final decodedPoints = _decodePolyline(points);

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: decodedPoints,
            color: Colors.blue,
            width: 6,
          ),
        };
      });
    } else {
      // Handle error
      print('Error fetching directions: ${json['status']}');
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    var list = polyline.codeUnits;
    var lList = List.empty(growable: true);
    int index = 0;
    int len = polyline.length;
    int c = 0;

    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negative then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    print(lList.toString());

    List<LatLng> polyList = [];
    for (var i = 0; i < lList.length; i += 2) {
      if (lList[i] != 0 && lList[i + 1] != 0) {
        polyList.add(LatLng(lList[i], lList[i + 1]));
      }
    }
    return polyList;
  }
  */

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MM월 dd일').format(widget.date);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            const Text(
              '지도',
              style: TextStyle(fontSize: 24),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  _controller = controller;
                  if (_startLatLng != null && _endLatLng != null) {
                    _controller!.animateCamera(
                      CameraUpdate.newLatLngBounds(
                        LatLngBounds(
                          southwest: _startLatLng!,
                          northeast: _endLatLng!,
                        ),
                        50,
                      ),
                    );
                  }
                },
                initialCameraPosition: CameraPosition(
                  target: _startLatLng ?? const LatLng(37.77483, -122.41942),
                  zoom: 12,
                ),
                markers: {
                  if (_startLatLng != null)
                    Marker(
                      markerId: const MarkerId('start'),
                      position: _startLatLng!,
                    ),
                  if (_endLatLng != null)
                    Marker(
                      markerId: const MarkerId('end'),
                      position: _endLatLng!,
                    ),
                },
                polylines: _polylines,
              ),
            ),
            */
            Text(
              '출발지: ${widget.startLocation}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '목적지: ${widget.endLocation}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
