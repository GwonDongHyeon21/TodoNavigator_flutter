import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/provider/todo_provider.dart';
import 'package:todo_flutter/todo/map_webview.dart';

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
      body: SingleChildScrollView(
        child: Padding(
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
                    child: TextFormField(
                      controller: _startLocationController,
                      maxLength: 20,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: '출발지',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_location_alt),
                    onPressed: () {
                      _openMap((address) {
                        setState(() {
                          _startLocationController.text = address;
                        });
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startLocationController,
                      maxLength: 20,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: '목적지',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_location_alt),
                    onPressed: () {
                      _openMap((address) {
                        setState(() {
                          _startLocationController.text = address;
                        });
                      });
                    },
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: AspectRatio(
                  aspectRatio: 15 / 16,
                  child: MapWebview(),
                ),
              ),
              const SizedBox(height: 10),
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
      ),
    );
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return '제목을 입력해주세요';
    }
    return null;
  }

  void _openMap(Function(String) onLocationSelected) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const MapWebview()),
    );
  }
}
