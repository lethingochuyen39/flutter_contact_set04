import 'package:flutter/material.dart';
import '../data/sql_helper.dart';
import '../models/contact.dart';
import 'list_page.dart';

class AddPage extends StatefulWidget {
  final Contact contact;
  final bool isNew;
  const AddPage(this.contact, this.isNew, {super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  SqlHelper sqlHelper = SqlHelper();

  @override
  void initState() {
    if (!widget.isNew) {
      _nameController.text = widget.contact.name;
      _phoneController.text = widget.contact.phoneNumber;
      _emailController.text = widget.contact.email;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.isNew ? const Text('Add new Contact') : const Text('Edit'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name can not be blank';
                    }
                    if (value.length < 2 || value.length > 50) {
                      return ('Name should be between 2 and 50 characters');
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone can not be blank';
                    }
                    // if (!RegExp(r'^[0-9]{9,12}$').hasMatch(value)) {
                    //   return ('Phone should be a number with 9 to 12 digits');
                    // }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email can not be blank';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            widget.contact.name = _nameController.text;
            widget.contact.phoneNumber = _phoneController.text;
            widget.contact.email = _emailController.text;
            if (widget.isNew) {
              await sqlHelper.insert(widget.contact);
            } else {
              await sqlHelper.update(widget.contact);
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ListPage()),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}