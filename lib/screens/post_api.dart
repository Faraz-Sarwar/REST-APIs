import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_api/model/user_model.dart';
import 'package:http/http.dart' as http;

class PostApi extends StatefulWidget {
  const PostApi({super.key});

  @override
  State<PostApi> createState() => _PostApiState();
}

class _PostApiState extends State<PostApi> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool isLoading = false;
  Future<ApiModel> uploadPost() async {
    setState(() {
      isLoading = true;
    });
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'id': 1,
          'title': titleController.text,
          'body': bodyController.text,
        }),
      );
      if (response.statusCode == 201) {
        setState(() {
          isLoading = false;
          titleController.clear();
          bodyController.clear();
        });
        final data = ApiModel.fromJson(jsonDecode(response.body));
        print('Post uploaded: id: ${data.id}');
        print('Post uploaded: Title: ${data.title}');
        print('Post uploaded: body: ${data.body}');
        return data;
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;

        titleController.clear();
        bodyController.clear();
      });
      throw Exception('Error: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload post'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              onPressed: isLoading ? null : uploadPost,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
