import 'package:flutter/material.dart';
import 'package:moneytrans/backgroundImage.dart';
import 'package:moneytrans/mydb.dart';
import 'package:intl/intl.dart';

class Userpage extends StatefulWidget {
  const Userpage({super.key});

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _moneyGivenController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Mydb mydb = Mydb();
  List<Map> transactions = [];
  double totalSum = 0.0;
  int? userId;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    userId = args?['userId'];
    readData();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  Future<void> readData() async {
    try {
      List<Map> response = await mydb.readData(
          "SELECT * FROM transactions WHERE user_id = ? ORDER BY transaction_date DESC",
          [userId]);
      setState(() {
        transactions = List<Map>.from(response);
        totalSum = transactions.fold(0.0, (sum, transaction) {
          final amount =
              double.tryParse(transaction['moneygiven'].toString()) ?? 0.0;
          return sum + amount;
        });
      });
    } catch (e) {
      print('Error reading data: $e');
    }
  }

  Future<void> _saveMoneyGiven() async {
    if (_formState.currentState!.validate()) {
      String moneyGiven = _moneyGivenController.text;
      String description = _descriptionController.text;
      String transactionDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      try {
        int response = await mydb.insertData(
            'INSERT INTO transactions(moneygiven, description, transaction_date, user_id) VALUES (?, ?, ?, ?)',
            [moneyGiven, description, transactionDate, userId]);

        if (response > 0) {
          _moneyGivenController.clear();
          _descriptionController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction Saved Successfully')),
          );
          readData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to Save Transaction')),
          );
        }
      } catch (e) {
        print('Error saving transaction: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF9D9),
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Total Amount: ${totalSum.toStringAsFixed(2)} DA",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: BackgroundImage(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formState,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _moneyGivenController,
                    decoration: const InputDecoration(
                      labelText: "Money Given",
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Colors.blueGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Colors.blueGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Colors.blueGrey),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a valid amount";
                      }
                      final number = num.tryParse(value);
                      if (number == null || number <= 0) {
                        return "Enter a positive amount";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    maxLines: 5,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Colors.blueGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Colors.blueGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveMoneyGiven,
                    child: const Text("Save Transaction"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8EACCD),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              "DescriptionPage",
                              arguments: {
                                'description': transactions[index]
                                        ['description'] ??
                                    "No Description",
                                'transactionDate': transactions[index]
                                        ['transaction_date'] ??
                                    "No Date",
                              },
                            );
                          },
                          child: ListTile(
                            title: Text(
                              "Money Given: ${transactions[index]['moneygiven']} DA",
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              "Date: ${transactions[index]['transaction_date']}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                try {
                                  int response = await mydb.deleteData(
                                      "DELETE FROM transactions WHERE id = ?",
                                      [transactions[index]['id']]);
                                  if (response > 0) {
                                    setState(() {
                                      final removedTransactionAmount =
                                          double.tryParse(transactions[index]
                                                      ['moneygiven']
                                                  .toString()) ??
                                              0.0;
                                      transactions.removeAt(index);
                                      totalSum -= removedTransactionAmount;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Transaction Deleted Successfully')),
                                    );
                                  }
                                } catch (e) {
                                  print('Error deleting transaction: $e');
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
