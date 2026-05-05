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
