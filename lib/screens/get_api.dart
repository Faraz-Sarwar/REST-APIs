import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_api/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/screens/put_api.dart';

class GetApi extends StatefulWidget {
  const GetApi({super.key});

  @override
  State<GetApi> createState() => _GetApiState();
}

class _GetApiState extends State<GetApi> {
  late Future<List<ApiModel>> posts;
  Future<List<ApiModel>> getPosts() async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((json) => ApiModel.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception: ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    posts = getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts'), centerTitle: true),
      body: Column(
        children: [
          FutureBuilder(
            future: posts,
            builder: (context, AsyncSnapshot<List<ApiModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No posts to fetch'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      return ListTile(
                        leading: Text(data.id.toString()),
                        title: Text(data.title!),
                        trailing: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PutApi(id: data.id!),
                              ),
                            );
                          },
                          child: const Icon(Icons.edit),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
