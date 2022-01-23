import 'package:flutter/material.dart';
import 'package:workshop_infinite_pagination/repository/user_repo.dart';

import 'widget/list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepository userRepo = UserRepository();

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  fetchUsers() async {
    await userRepo.fetchUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: userRepo.users.length,
          itemBuilder: (context, index) {
            var currentUser = userRepo.users[index];
            return ListItem(currentUser);
          },
        ),
      ),
    );
  }
}
