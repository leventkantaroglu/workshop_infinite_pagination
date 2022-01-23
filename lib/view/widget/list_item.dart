import 'package:flutter/material.dart';
import 'package:workshop_infinite_pagination/model/user_model.dart';

class ListItem extends StatelessWidget {
  final User user;
  final int index;

  const ListItem(this.user, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: NetworkImage(user.imageUrl),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Text(index.toString()),
    );
  }
}
