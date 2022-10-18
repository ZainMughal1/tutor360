import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/AdminAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/EditTexts.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  Buttons b = Buttons();
  AdminAuth adminAuth = AdminAuth();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar1("Admin Login", () {
        Get.toNamed('/AskRoll');
      }),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Form(
                    key: _keyForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: emailC,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Enter Email";
                            }
                          },
                          decoration: txtDec("email@gmail.com", "Email"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passC,
                          obscureText: true,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Enter Password";
                            }
                          },
                          decoration: txtDec("", "Password"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        b.b1(() async{
                          if (_keyForm.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            bool r = await adminAuth.login(emailC.text, passC.text);
                            if(r){
                              setState(() {
                                isLoading = false;
                              });
                              Get.offAllNamed('/AdminDashboard');
                            }
                            else{
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        }, "Login")
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
