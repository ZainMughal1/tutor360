import 'package:flutter/material.dart';

import '../Controller/AdminAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/EditTexts.dart';
class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  AdminAuth _adminAuth = AdminAuth();
  final passwordC = TextEditingController();
  final emailC = TextEditingController();
  final oldPasswordC = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Change Password"),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailC,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Enter Email";
                          }
                        },
                        decoration: txtDec("Enter Email", "Email"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: oldPasswordC,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Enter Old Password";
                          }
                        },
                        decoration:
                            txtDec("Enter Old Password", "Old Password"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordC,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Enter New Password";
                          }
                        },
                        decoration:
                            txtDec("Enter New Password", "New Password"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Buttons().b1(() async {
                        if (_keyForm.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          bool response = await _adminAuth.changePassword(
                              emailC.text, oldPasswordC.text, passwordC.text);
                          if (!response) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      }, "Change"),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
