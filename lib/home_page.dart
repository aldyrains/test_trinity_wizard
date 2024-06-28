import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'edit_contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
        leading: IconButton(
          icon: const Icon(Icons.search,color: Colors.orange,),
          onPressed: () {},
        ),
        title: const Text(
          'Contacts',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add,color: Colors.orange,),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: contacts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 30,
                        child: Text(contacts[index]["firstName"][0]),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${contacts[index]["firstName"]} ${contacts[index]["lastName"]}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
