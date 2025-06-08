import 'package:flutter/material.dart';
import 'package:moneytrans/backgroundImage.dart';
import 'package:moneytrans/mydb.dart';

class Adduser extends StatefulWidget {
  const Adduser({super.key});

  @override
  State<Adduser> createState() => _AdduserState();
}

class _AdduserState extends State<Adduser> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final Mydb mydb = Mydb();
  String usernameAdded = '';

  _saveUsername() async {
    if (_formState.currentState!.validate()) {
      _formState.currentState!.save();
      String username = _usernameController.text;

      int response = await mydb
          .insertData('INSERT INTO users(username) VALUES (?)', [username]);

      if (response > 0) {
        _usernameController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username Saved Successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to Save Username')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
      ),
      body: BackgroundImage(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formState,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                TextFormField(
                  onSaved: (newValue) {
                    usernameAdded = newValue!;
                  },
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a username";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _saveUsername, // No need for an anonymous function
                    child: const Text("Save Username"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
