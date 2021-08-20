import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flitter/screens/profile/user_list.dart';
import 'package:flitter/services/user_services.dart';
import 'package:flitter/models/user.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  UserService _userService = UserService();
  String search = '';
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserModel>?>.value(
      initialData: [],
      value: _userService.queryByName(search),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (text) {
                setState(
                  () {
                    search = text;
                  },
                );
              },
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
            ),
          ),
          UsersList()
        ],
      ),
    );
  }
}
