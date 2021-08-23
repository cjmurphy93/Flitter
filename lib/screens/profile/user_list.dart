import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flitter/models/user.dart';
import 'package:flitter/screens/profile/profile.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserModel>?>(context) ?? [];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            Profile.id,
            arguments: user.id,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    user.profileImageUrl != ''
                        ? CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              user.profileImageUrl.toString(),
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 40,
                          ),
                    SizedBox(width: 10),
                    Text(user.name.toString()),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              )
            ],
          ),
        );
      },
    );
  }
}
