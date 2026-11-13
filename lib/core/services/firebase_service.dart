import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_contact_app/feature/data/model/contact_user.dart';

class FirebaseService {
  final CollectionReference<Map<String, dynamic>> contactsCollection =
      FirebaseFirestore.instance.collection('contacts');

  Future<void> addContact(ContactUser contact) async {
    await contactsCollection.add({
      ...contact.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<ContactUser>> getContacts() {
    return contactsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ContactUser.fromJson(
          doc.data(),
          id: doc.id,
        );
      }).toList();
    });
  }

  Future<void> updateContact(
    String contactId,
    ContactUser contact,
  ) async {
    await contactsCollection.doc(contactId).update(contact.toJson());
  }

  Future<void> deleteContact(String contactId) async {
    await contactsCollection.doc(contactId).delete();
  }

  Future<List<ContactUser>> searchContacts(String name) async {
    final snapshot = await contactsCollection
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: '$name\uf8ff')
        .get();

    return snapshot.docs.map((doc) {
      return ContactUser.fromJson(doc.data(), id: doc.id);
    }).toList();
  }

  Future<void> addToFavorites(String contactId) async {
    await contactsCollection.doc(contactId).update({
      'isFavorite': true,
    });
  }

  Future<void> removeFromFavorites(String contactId) async {
    await contactsCollection.doc(contactId).update({
      'isFavorite': false,
    });
  }
}
