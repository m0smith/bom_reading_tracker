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
  String? ward;
  String group = "";
  String name = "";

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
              const SizedBox(height: 20 ,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Full name"),
                validator: (val) => val == null || val.isEmpty ? "Enter your full name" : null,
                obscureText: false,
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
              const SizedBox(height: 20,),
              DropdownButtonFormField<String>(
                  value: null,
                  decoration: textInputDecoration.copyWith(hintText: "Ward"),
                  validator: (val) => val == null || val.isEmpty ? "Select a ward" : null,
                  items: ["Mount Ensign Ward", "2nd Ward", "3rd Ward", "4th Ward", "5th Ward",
                        "6th Ward", "9th Ward", "10th Ward", "11th Ward"].map((label) => DropdownMenuItem<String>(
                    child: Text(label),
                    value: label,
                  )).toList(),
                  onChanged: (val) {
                    print(val);
                    setState(() {
                      ward = val!;
                    });
                  }),
              const SizedBox(height: 20,),
              DropdownButtonFormField<String>(
                  value: null,
                  decoration: textInputDecoration.copyWith(hintText: "Group"),
                  validator: (val) => val == null || val.isEmpty ? "Select a group" : null,
                  items: ["Youth", "Adult", ].map((label) => DropdownMenuItem<String>(
                    child: Text(label),
                    value: label,
                  )).toList(),
                  onChanged: (value) {
                    setState((){
                      group = value!;
                    });
                  }),
              const SizedBox(height: 20,),
              RaisedButton(
                  color: Colors.blue[400],

                  child: const Text("Register",
                    style: TextStyle(color: Colors.white),),
                  onPressed:  () async {
                    print("Reg button");
                    print(ward);
                    print(group);
                    if( _formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.register(email, password, name, ward!, group);
                      if(result == null) {
                        print("registration error");
                        setState(() {

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
