import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_student_1318434/models/contact.dart';
import '../data/sql_helper.dart';
import 'add_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  SqlHelper sqlHelper = SqlHelper();
  final TextEditingController _searchController = TextEditingController();
  List<Contact> filteredList = [];

  @override
  void initState() {
    super.initState();
    _getLists();
  }

  Future<void> _getLists() async {
    List<Contact> listAll = await sqlHelper.getList();
    setState(() {
      filteredList = listAll;
    });
  }

  void _filters(String keyword) async {
    List<Contact> listSearch = await sqlHelper.filters(keyword);
    setState(() {
      filteredList = listSearch;
    });
  }

  void clearSearch() {
    _searchController.clear();
    _filters('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _filters(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search',
                    ),
                  ),
                ),
                const Icon(Icons.search),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final contact = filteredList[index];
                return Dismissible(
                  key: Key(contact.id.toString()),
                  onDismissed: (direction) async {
                    await sqlHelper.delete(contact);
                  },
                  child: Card(
                    key: ValueKey(contact.phoneNumber),
                    child: ListTile(
                      title: Text(contact.name),
                      subtitle: Text(contact.phoneNumber),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPage(contact, false),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(Contact('', '', ''), true),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
