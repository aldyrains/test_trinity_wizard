import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditContactPage extends StatefulWidget {
  final Map<String, dynamic> contact;
  final Function(Map<String, dynamic>) onSave;

  const EditContactPage(
      {super.key, required this.contact, required this.onSave});

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String email;
  late DateTime dob;

  @override
  void initState() {
    super.initState();
    firstName = widget.contact['firstName'];
    lastName = widget.contact['lastName'];
    email = widget.contact['email'] ?? '';
    dob = _parseDate(widget.contact['dob']);
  }

  DateTime _parseDate(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      List<String> parts = dateString.split('/');
      if (parts.length == 3) {
        int day = int.tryParse(parts[0]) ?? 1;
        int month = int.tryParse(parts[1]) ?? 1;
        int year = int.tryParse(parts[2]) ?? DateTime.now().year;
        return DateTime(year, month, day);
      }
    }
    return DateTime.now(); // Default to current date if parsing fails
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: TextButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: Text('cancel'),
          // ),
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
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.orange, fontSize: 15),
              ),
            ),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 60,
                    child: Text([firstName][0]),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Main Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                buildTextFieldRow(
                  label: 'First Name',
                  placeholder: 'First Name',
                  controller: TextEditingController(text: firstName),
                  onChanged: (value) {
                    firstName = value;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                buildTextFieldRow(
                  label: 'Last Name',
                  placeholder: 'Last Name',
                  controller: TextEditingController(text: lastName),
                  onChanged: (value) {
                    lastName = value;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sub Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                buildTextFieldRow(
                  label: 'Email',
                  controller: TextEditingController(text: email),
                  placeholder: 'Email',
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked =
                        await showCupertinoModalPopup<DateTime>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 300.0,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: dob,
                            onDateTimeChanged: (DateTime newDateTime) {
                              setState(() {
                                dob = newDateTime;
                              });
                            },
                          ),
                        );
                      },
                    );

                    if (picked != null && picked != dob) {
                      setState(() {
                        dob = picked;
                      });
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date of Birth',
                        style: TextStyle(
                            fontSize: 16.0, color: CupertinoColors.systemGrey),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${dob.day}/${dob.month}/${dob.year}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldRow({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required Function(String) onChanged,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16.0, color: CupertinoColors.systemGrey),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CupertinoTextField(
            placeholder: placeholder,
            controller: controller,
            onChanged: onChanged,
            textInputAction: textInputAction,
          ),
        ),
      ],
    );
  }
}
