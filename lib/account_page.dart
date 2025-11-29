import 'package:flutter/material.dart';

import 'package:union_shop/main.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Page'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('The UNION'),
            const SizedBox(height: 20),
            const Text('Sign in'),
            const Text('Choose how you\'d like to sign in'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: null,
              style: ImportButtonStyle(),
              child: const Text('Sign in with shop'),
            ),
            const SizedBox(height: 10),
            const Text('or'),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
