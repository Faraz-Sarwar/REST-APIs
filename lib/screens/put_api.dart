import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_api/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/screens/get_api.dart';

class PutApi extends StatefulWidget {
  final int id;
  const PutApi({super.key, required this.id});

  @override
  State<PutApi> createState() => _PutApiState();
}

class _PutApiState extends State<PutApi> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  bool isLoading = false;
  Future<void> updatePost() async {
    setState(() {
      isLoading = true;
    });
    try {
      final url = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts/${widget.id}',
      );
      final response = await http.put(
        url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          'id': widget.id,
          'title': titleController.text,
          'body': bodyController.text,
        }),
      );
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GetApi()),
        );
        final data = ApiModel.fromJson(jsonDecode(response.body));
        print('Post updated with id: ${data.id}');
        print('Post updated title: ${data.title}');
        print('Post updated body: ${data.body}');
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception("Error occured: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Something went wrong: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Put API'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(),
                labelText: "Title",
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: bodyController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(),
                labelText: "Body",
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: isLoading ? null : updatePost,
              child: const Text('Update post'),
            ),
          ],
        ),
      ),
    );
  }
}
