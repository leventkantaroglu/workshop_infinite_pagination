import 'dart:convert';

import 'package:workshop_infinite_pagination/model/user_model.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  List<User> users = [];
  int perPage = 2000;

  Future<void> fetchUsers() async {
    String apiUrl = "https://randomuser.me/api/?results=$perPage";
    final response = await http.get(Uri.parse(apiUrl));

    try {
      for (var map in jsonDecode(response.body)["results"]) {
        users.add(User.fromMap(map));
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
