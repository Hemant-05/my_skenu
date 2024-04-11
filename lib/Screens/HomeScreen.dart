import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_skenu/Auth/firebaseAuth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skenu'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final _auth = FirebaseAuthMethods(FirebaseAuth.instance);
              _auth.logOut(context);
            },
            icon: const Icon(
              Icons.output_rounded,
            ),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'HomeScreen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
