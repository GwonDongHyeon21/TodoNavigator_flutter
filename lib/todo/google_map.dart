import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final LatLng _initialPosition = const LatLng(37.5665, 126.9780);
  LatLng? _selectedPosition;
  final places =
      GoogleMapsPlaces(apiKey: '//google map api');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('위치 선택'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, _selectedPosition);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 16,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onTap: (LatLng position) {
              setState(() {
                _selectedPosition = position;
              });
            },
            markers: _selectedPosition == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedPosition!,
                    ),
                  },
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: GooglePlaceAutoCompleteTextField(
                    textEditingController: TextEditingController(),
                    googleAPIKey: '//google map api',
                    inputDecoration: InputDecoration(
                      hintText: '검색할 위치를 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                    debounceTime: 800,
                    countries: const ['KR'],
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (prediction) async {
                      PlacesDetailsResponse detail =
                          await places.getDetailsByPlaceId(prediction.placeId!);
                      final lat = detail.result.geometry!.location.lat;
                      final lng = detail.result.geometry!.location.lng;

                      mapController?.animateCamera(
                          CameraUpdate.newLatLng(LatLng(lat, lng)));
                      setState(() {
                        _selectedPosition = LatLng(lat, lng);
                      });
                    },
                    itemClick: (prediction) async {
                      PlacesDetailsResponse detail =
                          await places.getDetailsByPlaceId(prediction.placeId!);
                      final lat = detail.result.geometry!.location.lat;
                      final lng = detail.result.geometry!.location.lng;

                      mapController?.animateCamera(
                          CameraUpdate.newLatLng(LatLng(lat, lng)));
                      setState(() {
                        _selectedPosition = LatLng(lat, lng);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
