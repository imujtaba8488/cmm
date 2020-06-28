class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String password;

  User.fromMap(Map<String, dynamic> userMap) {
    id = userMap['id'];
    firstName = userMap['first name'];
    lastName = userMap['last name'];
    email = userMap['email'];
    password = userMap['password'];
  }

  Map<String, String> asMap() => {
        'id': id,
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'password': password,
      };
}
