import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/provider/todo_provider.dart';
import 'package:todo_flutter/screen/map_webview.dart';

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

  void _showMapWebView(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: MapWebview(
            onLocationSelected: (address) {
              setState(() {
                _startLocationController.text = address;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('todo 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              maxLength: 20,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: '제목',
              ),
            ),
            GestureDetector(
              onTap: () {
                _showMapWebView(context);
              },
              child: TextField(
                controller: _startLocationController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: '출발지',
                  suffixIcon: Icon(Icons.location_on),
                ),
              ),
            ),
            TextField(
              controller: _endLocationController,
              decoration: const InputDecoration(
                labelText: '목적지',
              ),
            ),
            const SizedBox(height: 20),
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
                //todo 리스트에 추가하기
              },
              child: const Text('추가'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showMapWebView(context);
              },
              child: const Text('지도 열기'),
            ),
          ],
        ),
      ),
    );
  }
}
