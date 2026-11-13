class ContactUser {
  String? id;
  String name;
  String phone;
  String email;
  String address;
  bool isFavorite;

  ContactUser({
    this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.address = '',
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'isFavorite': isFavorite,
    };
  }

  factory ContactUser.fromJson(Map<String, dynamic> json, {String? id}) {
    return ContactUser(
      id: id,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
