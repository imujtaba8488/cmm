class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  String currency;
  double lowBalanceThreshold;

  User.fromMap(Map<String, dynamic> userMap) {
    id = userMap['id'];
    firstName = userMap['first name'];
    lastName = userMap['last name'];
    email = userMap['email'];
    password = userMap['password'];
    currency = userMap['currency'];
    lowBalanceThreshold = userMap['lowBalanceThreshold'];
  }

  Map<String, dynamic> asMap() => {
        'id': id,
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'password': password,
        'currency': currency,
        'lowBalanceThreshold': lowBalanceThreshold,
      };
}
