class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  String currency;
  double lowBalanceThreshold;
  String imageUrl;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.currency,
    this.lowBalanceThreshold,
    this.imageUrl,
  });

  User.fromMap(Map<String, dynamic> userMap) {
    id = userMap['id'];
    firstName = userMap['first name'];
    lastName = userMap['last name'];
    email = userMap['email'];
    password = userMap['password'];
    currency = userMap['currency'];
    lowBalanceThreshold = userMap['lowBalanceThreshold'];
    imageUrl = userMap['imageUrl'];
  }

  Map<String, dynamic> asMap() => {
        'id': id,
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'password': password,
        'currency': currency,
        'lowBalanceThreshold': lowBalanceThreshold,
        'imageUrl': imageUrl,
      };
}
