import 'package:flutter/material.dart';
import 'package:moneytrans/backgroundImage.dart';

class Descriptionpage extends StatelessWidget {
  final String description;
  final String transactionDate;

  const Descriptionpage({
    Key? key,
    required this.description,
    required this.transactionDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Description"),
      ),
      body: BackgroundImage(
        child: Container(
          width: double.infinity,
          // height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description: $description',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Date: $transactionDate',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
