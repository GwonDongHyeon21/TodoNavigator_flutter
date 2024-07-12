import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/model/todo.dart';
import 'package:todo_flutter/provider/todo_provider.dart';
import 'package:todo_flutter/todo/google_map.dart';
import 'package:url_launcher/url_launcher.dart';

class MapNavigator extends StatefulWidget {
  final int index;
  final String title;
  final DateTime date;
  final String startLocation;
  final String endLocation;

  const MapNavigator({
    Key? key,
    required this.index,
    required this.title,
    required this.date,
    required this.startLocation,
    required this.endLocation,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapNavigatorState createState() => _MapNavigatorState();
}

class _MapNavigatorState extends State<MapNavigator> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _startLocationController.text = widget.startLocation;
    _endLocationController.text = widget.endLocation;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startLocationController.dispose();
    _endLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MM월 dd일').format(widget.date);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                maxLength: 20,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: '제목',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        LatLng? selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapScreen(),
                          ),
                        );
                        if (selectedLocation != null) {
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                            selectedLocation.latitude,
                            selectedLocation.longitude,
                          );
                          setState(() {
                            _startLocationController.text =
                                placemarks.first.street ?? '알 수 없는 위치';
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _startLocationController,
                          decoration: const InputDecoration(
                            labelText: '출발지',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        LatLng? selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapScreen(),
                          ),
                        );
                        if (selectedLocation != null) {
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                            selectedLocation.latitude,
                            selectedLocation.longitude,
                          );
                          setState(() {
                            _endLocationController.text =
                                placemarks.first.street ?? '알 수 없는 위치';
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _endLocationController,
                          decoration: const InputDecoration(
                            labelText: '목적지',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: () => _updateTodo(),
                  child: const Text('수정하기'),
                ),
              ),
              const SizedBox(height: 65),
              ElevatedButton(
                onPressed: () {
                  _updateTodo();
                  _launchGoogleMaps(
                    _startLocationController.text,
                    _endLocationController.text,
                  );
                },
                child: const Text('Google Maps로 길찾기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchGoogleMaps(String start, String end) async {
    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$start&destination=$end');
    if (await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      await canLaunchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _updateTodo() {
    final updatedTodo = Todo(
      title: _titleController.text,
      date: widget.date,
      startLocation: _startLocationController.text,
      endLocation: _endLocationController.text,
    );
    Provider.of<TodoProvider>(context, listen: false)
        .updateTodo(widget.date, widget.index, updatedTodo);
    Navigator.of(context).pop();
  }

  /*
  Future<void> _launchNaverMaps(String start, String end) async {
    try {
      final startLatLng = await _getLatLng(start);
      final endLatLng = await _getLatLng(end);

      await _launchNaverMapsWithAddresses(
        startLatLng['lat'].toString(),
        startLatLng['lng'].toString(),
        endLatLng['lat'].toString(),
        endLatLng['lng'].toString(),
        start,
        end,
      );
    } catch (e) {
      throw 'Could not launch Naver Maps';
    }
  }

  Future<Map<String, double>> _getLatLng(String address) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final location = data['results'][0]['geometry']['location'];
      return {
        'lat': location['lat'],
        'lng': location['lng'],
      };
    } else {
      throw Exception('Failed to load location data');
    }
  }

  Future<void> _launchNaverMapsWithAddresses(String startLat, String startLng,
      String endLat, String endLng, String startName, String endName) async {
    final url = Uri.parse(
        'https://map.naver.com/p/directions/$startLat,$startLng,$startName/$endLat,$endLng,$endName/-/transit?c=16,0,0,0,dh');
    if (await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      await canLaunchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  */
}
