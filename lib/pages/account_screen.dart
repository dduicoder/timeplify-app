import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  static const routeName = "/account";

  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Hello, Sijin",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
