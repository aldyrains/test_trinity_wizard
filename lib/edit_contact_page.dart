import 'package:flutter/material.dart';

class EditContactPage extends StatefulWidget {
  final Map<String, dynamic> contact;
  final Function(Map<String, dynamic>) onSave;

  EditContactPage({required this.contact, required this.onSave});

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String email;
  late String dob;

  @override
  void initState() {
    super.initState();
    firstName = widget.contact['firstName'];
    lastName = widget.contact['lastName'];
    email = widget.contact['email'] ?? '';
    dob = widget.contact['dob'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: TextButton(
            
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('cancel'),
          ),
          title: Text('Edit Contact'),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final updatedContact = {
                    'id': widget.contact['id'],
                    'firstName': firstName,
                    'lastName': lastName,
                    'email': email,
                    'dob': dob,
                  };
                  widget.onSave(updatedContact);
                  Navigator.pop(context, updatedContact);
                }
              },
              child: Text('Save'),
            ),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: firstName,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    firstName = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  initialValue: lastName,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    lastName = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  initialValue: email,
                  decoration: InputDecoration(labelText: 'Email'),
                  onSaved: (value) {
                    email = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  initialValue: dob,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                  onSaved: (value) {
                    dob = value!;
                  },
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
