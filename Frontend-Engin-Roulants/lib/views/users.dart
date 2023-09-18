import 'package:engin_roulants/utils/colors.dart';
import 'package:engin_roulants/widgets/delete_user_dialog.dart';
import 'package:engin_roulants/widgets/update_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key : key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final fireStore=FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('users').snapshots(),
        builder: (context,snapshot) {
          if(!snapshot.hasData){
            return const Text('No users to display');
          }else{
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document){
                Map<String,dynamic> data = document.data()! as Map<String,dynamic>;

                String? userId= data['userId'];
                String? userName= data['userName'];
                String? firstName= data['firstName'];
                String? lastName= data['lastName'];
                String? email= data['email'];
                String? password= data['password'];
                 String? role= data['role'];
                // Color userColor=AppColors.blueShadeColor;
                // if(role=='admin'){
                //   userColor=AppColors.salmonColor;
                // }else if(role=='user'){
                //   userColor=AppColors.greenShadeColor;
                // }
                return Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 5.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/user.png',
                      )
                    ),
                    title: Text(userName ?? '',style: TextStyle(fontSize: 20,height: 2.5),),
                    subtitle: Text(role ?? '',style: TextStyle(fontSize: 16),),
                    isThreeLine: true,
                    trailing: PopupMenuButton(
                      itemBuilder: (context){
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: () {
                              print('Edit tapped');
                              if (userId != null) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => UpdateUserDialog(
                                      userId: userId,
                                      userName: userName ?? '',
                                      firstName: firstName ?? '',
                                      lastName: lastName ?? '',
                                      email: email ?? '',
                                      password: password ?? '',
                                      role: role ?? '',
                                    ),
                                  );
                                });
                              }
                            },
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Text(
                              'Delete',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: (){
                              if(userId != null){
                                Future.delayed(
                                  const Duration(seconds:0),
                                    () => showDialog(
                                      context: context,
                                      builder: (context) => DeleteUserDialog(
                                        userId: userId,
                                        userName: userName ?? '',
                                      ),
                                    )
                                );
                              }
                            },
                          )
                        ];
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
