import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:workshop_infinite_pagination/model/user_model.dart';
import 'package:http/http.dart' as http;

import 'page_status.dart';

class UserRepository {
  List<User> users = [];
  int perPage = 10;
  int pageKey = 1;
  ValueNotifier<PageStatus> pageStatus = ValueNotifier<PageStatus>(
    PageStatus.idle,
  );

  Future getInitialUsers() async {
    pageStatus.value = PageStatus.firstPageLoading;

    try {
      await fetchUsers(1);
      if (users.isEmpty) {
        pageStatus.value = PageStatus.firstPageNoItemsFound;
      } else {
        pageStatus.value = PageStatus.firstPageLoaded;
      }
    } catch (e) {
      pageStatus.value = PageStatus.firstPageError;
    }
  }

  Future loadMoreUsers() async {
    pageStatus.value = PageStatus.newPageLoading;
    pageKey++;

    try {
      int currentUsersCount = users.length;
      await fetchUsers(pageKey);

      if (currentUsersCount == users.length) {
        pageStatus.value = PageStatus.newPageNoItemsFound;
      } else {
        pageStatus.value = PageStatus.newPageLoaded;
      }
    } catch (e) {
      pageStatus.value = PageStatus.newPageError;
    }
  }

  Future<void> fetchUsers(int pageKey) async {
    String apiUrl = "https://randomuser.me/api/?results=$perPage&page=$pageKey";
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
