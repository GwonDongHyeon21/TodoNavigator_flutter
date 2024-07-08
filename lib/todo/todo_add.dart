import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/provider/todo_provider.dart';
import 'package:todo_flutter/todo/google_map.dart';
import 'package:geocoding/geocoding.dart';

class TodoAdd extends StatefulWidget {
  final DateTime selectedDay;

  const TodoAdd({Key? key, required this.selectedDay}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TodoAddState createState() => _TodoAddState();
}

class _TodoAddState extends State<TodoAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('todo 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              maxLength: 20,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: '제목',
              ),
              validator: _validateTitle,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startLocationController,
                    decoration: const InputDecoration(
                      labelText: '출발지',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_location_alt),
                  onPressed: () async {
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
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _endLocationController,
                    decoration: const InputDecoration(
                      labelText: '목적지',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_location_alt),
                  onPressed: () async {
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
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  Provider.of<TodoProvider>(context, listen: false).addTodo(
                    widget.selectedDay,
                    _titleController.text,
                    _startLocationController.text,
                    _endLocationController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('추가'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return '제목을 입력해주세요';
    }
    return null;
  }
}
