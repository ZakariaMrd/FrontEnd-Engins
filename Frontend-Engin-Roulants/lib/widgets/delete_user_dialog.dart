import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteUserDialog extends StatefulWidget {
  final String userId, userName;

  const DeleteUserDialog({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<DeleteUserDialog> createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<DeleteUserDialog> {
  Future<void> _deleteUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).delete();
      Fluttertoast.showToast(
        msg: "User ${widget.userName} deleted successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      Navigator.of(context).pop(); // Close the dialog after successful deletion
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed to delete user: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Delete User',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.brown),
      ),
      content: SizedBox(
        child: Form(
          child: Column(
            children: <Widget>[
              const Text(
                'Are you sure you want to delete this user?',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              Text(
                widget.userName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without deleting
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _deleteUser, // Call the _deleteUser function on delete button press
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
