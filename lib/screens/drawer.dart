import 'package:flutter/material.dart';

class Drawer_navbar extends StatelessWidget {
  const Drawer_navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Tin Tran'),
            accountEmail: Text('tintt2@newit.co.jp'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1545184180-25d471fe75eb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGd1eXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Tin Tran'),
            subtitle: const Text('Developer'),
            trailing: const Icon(Icons.edit),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: const Text('tintt2@newit.co.jp'),
            trailing: const Icon(Icons.edit),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}
