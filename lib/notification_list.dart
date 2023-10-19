import 'package:flutter/material.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://cdn.icon-icons.com/icons2/2107/PNG/512/file_type_flutter_icon_130599.png'),
                ),
              ),
            ),
            title: Text('E Commerce'),
            subtitle: Text('Thank you for donwloading '),
            onTap: () {},
            enabled: true,
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: 100,
      ),
    );
  }
}
