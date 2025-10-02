import 'package:flutter/material.dart';
import 'appwrite_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppwriteService appwrite = AppwriteService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Appwrite Form Example",
      home: UserForm(appwrite: appwrite),
    );
  }
}

class UserForm extends StatefulWidget {
  final AppwriteService appwrite;
  const UserForm({Key? key, required this.appwrite}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  bool _loading = false;
  String _status = "";

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _status = "Saving...";
      });

      try {
        await widget.appwrite.insertUser(
          _nameController.text.trim(),
          int.parse(_ageController.text.trim()),
        );
        setState(() {
          _status = "✅ User saved successfully!";
        });
        _nameController.clear();
        _ageController.clear();
      } catch (e) {
        setState(() {
          _status = "❌ Error: $e";
        });
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Insert User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter a name" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter age";
                  if (int.tryParse(value) == null) return "Age must be a number";
                  return null;
                },
              ),
              SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text("Submit"),
                    ),
              SizedBox(height: 20),
              Text(
                _status,
                style: TextStyle(fontSize: 16, color: Colors.blue),
              )
            ],
          ),
        ),
      ),
    );
  }
}
