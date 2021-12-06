import 'package:flutter/material.dart';

class UserProductItemTile extends StatelessWidget {

  final String title;
  final String imageUrl;

  UserProductItemTile({ required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      trailing: SizedBox(
        width: 101,
        child: Row(
          children: <Widget>[
            IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary)),
            IconButton(onPressed: (){}, icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error,))
          ],
        ),
      ),
    );
  }
}
