class Contact {
  int? id;
  late String name;
  late String phoneNumber;
  late String email;

  Contact(this.name, this.phoneNumber, this.email);

  Contact.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    phoneNumber = map['phoneNumber'];
    email = map['email'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phoneNumber': phoneNumber, 'email': email};
  }
}
