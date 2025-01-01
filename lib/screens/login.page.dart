import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _psswdCont = TextEditingController();
  bool _passwdvisibile = false;

  Future<void> SignIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailCont.text.trim(),
        password: _psswdCont.text.trim(),
      );
      if (userCredential.user != null) {
        print("yay: ${userCredential.user?.email}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("yaaay")),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = "bro in the club you're not fam";
          break;
        case 'wrong-password':
          message = "what in the amnesia is this";
          break;
        case 'invalid-email':
          message = "stop it please get some help";
          break;
        case 'user-disabled':
          message = "tbh i even dont know whats this";
          break;
        case 'too-many-requests':
          message = "daddy chill";
          break;
        default:
          message = "heheh no.try again";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      print("bro what FirebaseAuthException: $message");
    } on SocketException catch (e) {
      const String message =
          "Network error HAHA: the connection is not connecting buddy";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      print("SocketException: $e");
    } catch (e) {
      const String message = "very expected error hh";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      print("bro honestly just die: $e");
    }
  }

  String? _valmail(String? value) {
    if (value == null || value.isEmpty) {
      return "dude are u fr?";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "you're either blind or stupid";
    }
    return null;
  }

  String? _valpsswd(String? value) {
    if (value == null || value.isEmpty) {
      return "u really think u gonna enter without a password";
    }
    if (value.length < 6) {
      return "6 damn characters u dumb";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'the LOGIN page :)',
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "images/avatar.jpeg",
                height: 120,
                width: 120,
              ),
              const Text(
                'heyy welcome back again',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailCont,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _valmail,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _psswdCont,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwdvisibile = !_passwdvisibile;
                      });
                    },
                    icon: Icon(
                      _passwdvisibile
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_passwdvisibile,
                validator: _valpsswd,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    SignIn();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blueGrey,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/register");
                },
                child: const Text(
                  'that one click to register if you dont have an account',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
