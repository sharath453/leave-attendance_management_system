import 'package:flutter/material.dart';
import 'package:leave_management_app/services/api_service.dart';

class AddFinePage extends StatefulWidget {
  const AddFinePage({super.key});

  @override
  _AddFinePageState createState() => _AddFinePageState();
}

class _AddFinePageState extends State<AddFinePage> {
  final ApiService apiService = ApiService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fineAmountController = TextEditingController();

  void _submitFine() {
    final String username = _usernameController.text;
    final double fineAmount = double.tryParse(_fineAmountController.text) ?? 0;

    apiService.addFine(username, fineAmount).then((response) {
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fine added successfully')),
        );
        // Clear the input fields after successful submission
        _usernameController.clear();
        _fineAmountController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add fine: ${response['message']}')),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Fine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _fineAmountController,
              decoration: InputDecoration(labelText: 'Fine Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFine,
              child: Text('Add Fine'),
            ),
          ],
        ),
      ),
    );
  }
}
