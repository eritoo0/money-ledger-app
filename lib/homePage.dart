import 'package:flutter/material.dart';
import 'package:moneytrans/backgroundImage.dart';
import 'package:moneytrans/mydb.dart';
import 'package:moneytrans/userPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Mydb mydb = Mydb();
  List<Map> users = [];

  Future<void> readData() async {
    List<Map> response = await mydb.readData("SELECT * FROM users");
    setState(() {
      users = List<Map>.from(response);
    });
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<void> _confirmDelete(int userId, int index) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (confirm ?? false) {
      int response =
          await mydb.deleteData("DELETE FROM users WHERE id = $userId");
      if (response > 0) {
        setState(() {
          users.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User deleted")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF9D9),
      appBar: AppBar(
        title: const Text(
          "Money Manager",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed("Adduser");
          setState(() {
            readData();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: BackgroundImage(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, i) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    "${users[i]['username']}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      /*  onPressed: () async {
                      int response = await mydb.deleteData(
                          "DELETE FROM users WHERE id = ${users[i]['id']}");
                      if (response > 0) {
                        setState(() {
                          users.removeWhere(
                              (user) => user['id'] == users[i]['id']);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User deleted")),
                        );
                      }
                    },
                  ),*/
                      onPressed: () {
                        _confirmDelete(users[i]['id'], i);
                      }),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Userpage(),
                        settings: RouteSettings(
                          arguments: {'userId': users[i]['id']},
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
