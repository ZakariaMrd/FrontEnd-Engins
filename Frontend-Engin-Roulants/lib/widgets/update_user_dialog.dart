import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateUserDialog extends StatefulWidget {
  final String userId, userName, firstName, lastName, email, password, role;

  const UpdateUserDialog({
    Key? key,
    required this.userId,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
  }) : super(key: key);

  @override
  State<UpdateUserDialog> createState() => _UpdateUserDialogState();
}

class _UpdateUserDialogState extends State<UpdateUserDialog> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List<String> roleOptions = ['Admin', 'User'];
  String selectedValue = '';

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.userName;
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    emailController.text = widget.email;
    passwordController.text = widget.password;
    selectedValue = widget.role;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Update user',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.brown),
      ),
      content: SizedBox(
        height: height * 0.35,
        width: width,
        child: Form(
          child: Column(
            children: <Widget>[
              // TextFormField widgets for user input go here
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _updateUser, // Call the _updateUser method
          child: const Text('Update'),
        ),
      ],
    );
  }

  void _updateUser() {
    final userName = userNameController.text;
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final role = selectedValue;

    // Call the _updateTasks method with the provided data
    _updateTasks(userName, firstName, lastName, email, password, role);

    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _updateTasks(
    String userName,
    String firstName,
    String lastName,
    String email,
    String password,
    String role,
  ) async {
    var collection = FirebaseFirestore.instance.collection('users');
    collection
        .doc(widget.userId)
        .update({
          'userName': userName,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'role': role,
        })
        .then(
          (_) => Fluttertoast.showToast(
            msg: 'User updated successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          ),
        )
        .catchError(
          (error) => Fluttertoast.showToast(
            msg: 'Failed: $error',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          ),
        );
  }
}
