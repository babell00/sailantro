class AppUser {
  final String uid;
  final String? email;
  final String? displayName;

  AppUser({
    required this.uid,
    this.email,          // ← nullable
    this.displayName,
  });

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'email': email,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(uid: jsonUser['uid'], email: jsonUser['email']);
  }
}