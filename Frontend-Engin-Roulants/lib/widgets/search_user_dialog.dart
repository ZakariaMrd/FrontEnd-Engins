import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchUserDialog extends StatefulWidget {
  const SearchUserDialog({Key? key}) : super(key: key);

  @override
  State<SearchUserDialog> createState() => _SearchUserDialogState();
}

class _SearchUserDialogState extends State<SearchUserDialog> {
  final TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> users = [];
  List<QueryDocumentSnapshot> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search by username...',
              border: OutlineInputBorder(),
            ),
            onChanged: filterUsers,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              // Build your list items using filteredUsers
              var userData = filteredUsers[index].data() as Map<String, dynamic>;
              var userName = userData['userName'] ?? '';

              return ListTile(
                title: Text(userName),
                // Add other user information here
              );
            },
          ),
        ),
      ],
    );
  }

  void _fetchUsers() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      users = querySnapshot.docs;
      filteredUsers = users;
    });
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users.where((user) {
        var userData = user.data() as Map<String, dynamic>;
        var userName = userData['userName'] ?? '';
        return userName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }
}
