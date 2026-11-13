import 'package:flutter/material.dart';
import 'package:my_contact_app/core/app_routes.dart';
import 'package:my_contact_app/core/services/firebase_service.dart';
import 'package:my_contact_app/feature/data/model/contact_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF4935D5);
  final Color lightColor = const Color(0xFFF0EDFF);

  final FirebaseService firebaseService = FirebaseService();
  final TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;

  Future<void> addNewContact() async {
    final result = await Navigator.pushNamed(context, AppRoutes.newContact);

    if (!mounted) return;

    if (result != null && result is ContactUser) {
      try {
        await firebaseService.addContact(result);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact added successfully')),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error adding contact: $e')));
      }
    }
  }

  List<ContactUser> getFilteredContacts(List<ContactUser> contacts) {
    return contacts.where((contact) {
      return contact.name.toLowerCase().contains(
        searchController.text.trim().toLowerCase(),
      );
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contacts',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Keep in touch 😊',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none, size: 28),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Search
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: lightColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Quick Actions
              Row(
                children: [
                  _buildAction(
                    Icons.person_add_alt_1,
                    'Add Contact',
                    addNewContact,
                  ),
                  const SizedBox(width: 10),
                  _buildAction(Icons.groups, 'Groups', () {}),
                  const SizedBox(width: 10),
                  _buildAction(Icons.star, 'Favorites', () {}),
                ],
              ),

              const SizedBox(height: 25),

              // Contacts List
              StreamBuilder<List<ContactUser>>(
                stream: firebaseService.getContacts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text('Something went wrong'),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final contacts = snapshot.data ?? [];

                  contacts.sort((a, b) => a.name.compareTo(b.name));

                  final filteredContacts = getFilteredContacts(contacts);

                  if (filteredContacts.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          'No contacts found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: _buildContactSections(filteredContacts),
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: addNewContact,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Groups'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // Quick Action Widget
  Widget _buildAction(IconData icon, String title, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
          decoration: BoxDecoration(
            color: lightColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(icon, color: primaryColor, size: 30),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Contact Sections
  List<Widget> _buildContactSections(List<ContactUser> contacts) {
    final Map<String, List<ContactUser>> grouped = {};

    for (var contact in contacts) {
      if (contact.name.isEmpty) continue;

      final letter = contact.name[0].toUpperCase();

      grouped.putIfAbsent(letter, () => []);
      grouped[letter]!.add(contact);
    }

    List<Widget> widgets = [];

    final letters = grouped.keys.toList()..sort();

    for (var letter in letters) {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: lightColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                letter,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${grouped[letter]!.length} contacts',
                style: TextStyle(color: primaryColor, fontSize: 14),
              ),
            ],
          ),
        ),
      );

      for (var contact in grouped[letter]!) {
        widgets.add(_buildContactItem(contact));
      }
    }

    return widgets;
  }

  // Contact Item
  Widget _buildContactItem(ContactUser contact) {
    final name = contact.name;
    final phone = contact.phone;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: primaryColor,
            child: Text(
              name.isNotEmpty ? name[0] : '?',
              style: const TextStyle(color: Colors.white, fontSize: 23),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  phone,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call, color: primaryColor),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
