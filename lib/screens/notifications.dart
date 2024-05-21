import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Theme.of(context).colorScheme.background,
    appBar: AppBar(
      title: const Text("N O T I F I C A T I O N S",
      style: TextStyle(fontWeight: FontWeight.bold),),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),);
  }
}