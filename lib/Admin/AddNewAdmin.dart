import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Controller/AdminAuth.dart';
import '../Styles/AppBar.dart';
import '../Styles/Buttons.dart';
import '../Styles/EditTexts.dart';

class AddNewAdmin extends StatefulWidget {
  const AddNewAdmin({Key? key}) : super(key: key);

  @override
  State<AddNewAdmin> createState() => _AddNewAdminState();
}

class _AddNewAdminState extends State<AddNewAdmin> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  AdminAuth adminAuth = AdminAuth();
  bool isLoading = false;
  final _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar2("Add new Admin Account"),
      body: isLoading? Center(child: CircularProgressIndicator()):Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (v){
                    if(v!.isEmpty){
                      return "Enter Email";
                    }
                  },
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: txtDec("Email","Email"),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (v){
                    if(v!.isEmpty){
                      return "Enter Password";
                    }
                  },
                  controller: passC,
                  obscureText: true,
                  decoration: txtDec("","Password"),
                ),
                SizedBox(height: 20,),
                Buttons().b1(()async{
                  if(_keyForm.currentState!.validate()){
                    setState(() {
                      isLoading = true;
                    });
                    var r = await adminAuth.addAdmin(emailC.text, passC.text);
                    if(r==false){
                      setState(() {
                        isLoading = false;
                      });
                      Fluttertoast.showToast(msg: "Something is Wrong");
                    }
                  }
                }, "Create"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
