// ignore_for_file: require_trailing_commas

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notifications/model/message.dart';

/// Displays information about a [RemoteMessage].
class BeritaPage extends StatelessWidget {
  const BeritaPage({Key? key}) : super(key: key);

  /// A single data row.
  Widget row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: '),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MessageArguments args = ModalRoute.of(context)!.settings.arguments!  as MessageArguments;
    RemoteMessage message = args.message;
    RemoteNotification? notification = message.notification;

    return Scaffold(
      appBar: AppBar(
        title: Text(message.messageId ?? 'N/A'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Image.network(message.data['image']),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Text(
                message.data['judul'] ?? 'N/A',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Text(
                message.data['isi'] ?? 'N/A',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
