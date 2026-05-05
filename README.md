# 📱 Flutter REST API App

A simple Flutter application that fetches user data from an API and displays it in a list with a detailed user profile screen.

---

## 🚀 Features

- Fetch users from REST API  
- Display users in ListView  
- User profile detail screen  
- Clean UI with reusable widgets  
- Loading indicator during API call  
- Error handling for failed requests  

---

## 📱 App Flow

- Home screen loads users from API  
- Tap on a user to open profile screen  
- Profile screen shows:
  - Name  
  - Email  
  - Phone (formatted)  
  - Company  
  - Location  

---

## 🛠 Tech Stack

- Flutter  
- Dart  
- HTTP package  
- FutureBuilder  

---

# 💻 SOURCE CODE

---

## 📄 main.dart

```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

```

## 📄 home_screen.dart

```dart
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
```

## 📄 user_profile_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:rest_api/components/info_tile.dart';
import 'package:rest_api/model/user_model.dart';

class UserProfileScreen extends StatefulWidget {
  final UserModel user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

// Jsonplaceholder API phone number follows a diffrent pattern ("1-770-736-8031 x56442"), so this functions clean the phone number format by removing (x56442) part.
String cleanPhoneNumber(String? phone) {
  if (phone == null) return '';
  String cleanPhone = phone!.split(' x').first;
  return cleanPhone;
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final person = widget.user;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(title: const Text('User details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person_2, color: Colors.white, size: 60),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              person.name.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            //InfoTile is a resuable component to display information for the diffrent users (see components/info_tile.dart)
            InfoTile(
              infoType: 'Email:',
              info: person.email.toString(),
              icon: Icons.email,
            ),
            const SizedBox(height: 16),
            InfoTile(
              infoType: 'Phone number:',
              info: cleanPhoneNumber(person.phone),
              icon: Icons.phone,
            ),
            const SizedBox(height: 16),
            InfoTile(
              infoType: 'Company:',
              info: person.company!.name.toString(),
              icon: Icons.business_center_outlined,
            ),
            const SizedBox(height: 16),
            InfoTile(
              infoType: 'Location:',
              info: '${person.address!.street.toString()} street',
              icon: Icons.location_on_sharp,
            ),
          ],
        ),
      ),
    );
  }
}
```

## 📄 user_model.dart

```dart
// this is the model of API JSON data for type safety.

class UserModel {
  int? id;
  String? name;
  String? username;
  String? email;
  Address? address;
  String? phone;
  String? website;
  Company? company;

  UserModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    address = json['address'] != null
        ? new Address.fromJson(json['address'])
        : null;
    phone = json['phone'];
    website = json['website'];
    company = json['company'] != null
        ? new Company.fromJson(json['company'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['phone'] = this.phone;
    data['website'] = this.website;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    return data;
  }
}

class Address {
  String? street;
  String? suite;
  String? city;
  String? zipcode;
  Geo? geo;

  Address({this.street, this.suite, this.city, this.zipcode, this.geo});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    suite = json['suite'];
    city = json['city'];
    zipcode = json['zipcode'];
    geo = json['geo'] != null ? new Geo.fromJson(json['geo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['suite'] = this.suite;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    if (this.geo != null) {
      data['geo'] = this.geo!.toJson();
    }
    return data;
  }
}

class Geo {
  String? lat;
  String? lng;

  Geo({this.lat, this.lng});

  Geo.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Company {
  String? name;
  String? catchPhrase;
  String? bs;

  Company({this.name, this.catchPhrase, this.bs});

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    catchPhrase = json['catchPhrase'];
    bs = json['bs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['catchPhrase'] = this.catchPhrase;
    data['bs'] = this.bs;
    return data;
  }
}
```

## 📄 info_tile.dart

```dart
import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String infoType;
  final String info;
  final IconData icon;
  const InfoTile({
    super.key,
    required this.infoType,
    required this.info,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ListTile(
        leading: Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(infoType, style: TextStyle(fontSize: 18)),
        subtitle: Text(
          info.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
```