import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/model/user_model.dart';
import 'package:rest_api/screens/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<UserModel>> getUsers() async {
    try {
      final url = "https://jsonplaceholder.typicode.com/users";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((user) => UserModel.fromJson(user)).toList();
      } else {
        throw Exception(
          "Failed to load users. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("An exception occurred: ${e.toString()}");
    }
  }

  late Future<List<UserModel>> usersList;
  @override
  void initState() {
    super.initState();
    usersList = getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REST APIs')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: usersList,
              builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users in the database'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final UserModel user = snapshot.data![index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileScreen(user: user),
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            // I am displaying these profile icons because jsonplaceholder (users) API does not have a profile picture attribute.
                            child: Icon(Icons.person_2, color: Colors.white),
                          ),
                          title: Text(
                            user.name.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text('Email: ${user.email.toString()}'),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
