import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'edit_contact_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    final String response = await rootBundle.loadString('lib/data/data.json');
    final data = await json.decode(response);
    setState(() {
      contacts = data;
    });
  }

  Future<void> _pullRefresh() async {
    await loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${contacts[index]["firstName"]} ${contacts[index]["lastName"]}'),
              subtitle: Text(contacts[index]["email"] ?? 'No Email'),
              onTap: () async {
                final updatedContact = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditContactPage(
                      contact: contacts[index],
                      onSave: (updatedContact) {
                        setState(() {
                          contacts[index] = updatedContact;
                        });
                      },
                    ),
                  ),
                );

                if (updatedContact != null) {
                  setState(() {
                    contacts[index] = updatedContact;
                  });
                }
              },
            );
          },
        ),
      ),
    );
  }
}
