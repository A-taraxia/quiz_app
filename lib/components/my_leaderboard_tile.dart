import 'package:flutter/material.dart';

class LeaderboardTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String score;

  const LeaderboardTile({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(name),
      trailing: Text(score),
    );
  }
}
