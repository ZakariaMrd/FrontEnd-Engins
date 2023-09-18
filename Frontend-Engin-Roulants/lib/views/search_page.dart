import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'users.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _users = [];
  List<DocumentSnapshot> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot querySnapshot) {
      setState(() {
        _users = querySnapshot.docs;
        _filteredUsers = _users;
      });
    });
  }

  void filterUsers(String query) {
    setState(() {
      _filteredUsers = _users.where((user) {
        var userData = user.data() as Map<String, dynamic>;
        var userName = userData['userName'] ?? '';
        return userName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by username...',
            border: InputBorder.none,
          ),
          onChanged: filterUsers,
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredUsers.length,
        itemBuilder: (context, index) {
          var userData = _filteredUsers[index].data() as Map<String, dynamic>;
          var userName = userData['userName'] ?? '';
          var role = userData['role'] ?? ''; // Ajout du rôle

          return Card(
            elevation: 4, // Élévation du Card
            margin: EdgeInsets.all(8), // Marge autour du Card
            child: ListTile(
              leading: Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/user.png',
                  width: 40,
                  height: 40,
                ),
              ),
              title: Text(
                userName ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Role: $role', // Affichage du rôle
                style: TextStyle(
                  fontSize: 14, // Style du texte du rôle
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
