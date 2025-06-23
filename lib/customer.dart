// lib/customer.dart

// This class represents a single customer in our application.
// It includes properties for all the customer details we want to store.
class Customer {
  final String id; // Unique auto-incremental ID for the customer
  final String firstName;
  final String? middleName; // Optional middle name
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final DateTime birthDate;
  final int age; // Calculated from birthDate

  Customer({
    required this.id,
    required this.firstName,
    this.middleName, // Optional parameter
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.birthDate,
    required this.age,
  });

  // Factory constructor to create a Customer object from a JSON map.
  // This is used when loading data from GetStorage, as GetStorage stores data as maps.
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      gender: json['gender'],
      // Parse the ISO 8601 string back into a DateTime object
      birthDate: DateTime.parse(json['birthDate']),
      age: json['age'],
    );
  }

  // Method to convert a Customer object to a JSON map.
  // This is used when saving data to GetStorage. DateTime objects are converted
  // to ISO 8601 strings for easy storage and retrieval.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'gender': gender,
      'birthDate': birthDate.toIso8601String(), // Store as string
      'age': age,
    };
  }

  // Method to create a copy of the Customer with updated fields.
  // This is useful for the "Edit" functionality, allowing us to create a new
  // Customer object with specific changes without mutating the original.
  Customer copyWith({
    String? id,
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? gender,
    DateTime? birthDate,
    int? age,
  }) {
    return Customer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      age: age ?? this.age,
    );
  }
}
