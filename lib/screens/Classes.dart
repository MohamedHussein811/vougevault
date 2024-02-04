class User {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String address;
  final String birthDate;
  final String photoPath;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.address,
    required this.birthDate,
    required this.photoPath,
  });

  static User createGuestUser() {
    return User(
      username: "Guest",
      email: "",
      password: "",
      confirmPassword: "",
      phoneNumber: "",
      address: "",
      birthDate: "",
      photoPath: "assets/images/logo/logo.png",
    );
  }

  static User createAdminAccount() {
    return User(
      username: "Admin",
      email: "1",
      password: "1",
      confirmPassword: "1",
      phoneNumber: "1234567890",
      address: "Admin Address",
      birthDate: "01-01-1990",
      photoPath: "assets/images/admin/admin.png",
    );
  }
}
  List<User> userList = [];


