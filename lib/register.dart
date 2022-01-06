import 'package:bom_reading_tracker/constants.dart';
import 'package:bom_reading_tracker/services/auth.dart';
import 'package:bom_reading_tracker/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({required this.toggleView, Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final  _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String password = "";
  String error = "";
  @override
  Widget build(BuildContext context) {
    return loading ?const Loading(): Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: const Text('Sign Up'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: (){
                  widget.toggleView();
                },
                icon: const Icon(Icons.person),
                label: const Text("Sign In"))
          ]
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Email"),
                validator: (val) => val == null || val.isEmpty ? "Enter an email" : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              const SizedBox(height: 20 ,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                validator: (val) => val == null || val.length < 6 ? "Enter a password at least 6 chars long" : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              const SizedBox(height: 20,),
              RaisedButton(
                  color: Colors.blue[400],

                  child: const Text("Register",
                    style: TextStyle(color: Colors.white),),
                  onPressed:  () async {
                    if( _formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.register(email, password);
                      if(result == null) {
                        setState(() {
                          print("registration error");
                          error = "Please supply a valid email and password";
                          loading = false;
                        });
                      } else {
                        print("register not null");
                        print(result);
                        setState(() {
                          error = "";
                          loading = false;
                        });
                      }
                    }
                    // print(password);
                  }),
              const SizedBox(height: 12,),
              Text(error,
                style: const TextStyle(
                color: Colors.red,
                fontSize: 14.0,
              ))
            ],
          )
        )

      ),
    );
  }
}
