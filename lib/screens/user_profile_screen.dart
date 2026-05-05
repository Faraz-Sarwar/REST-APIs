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
