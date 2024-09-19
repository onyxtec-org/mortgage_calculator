class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String updatedAt;
  final String createdAt;
  final int id;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  // Factory constructor to create a UserModel from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }

  // Method to convert the UserModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
