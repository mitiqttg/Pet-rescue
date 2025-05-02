class Attachment {
  const Attachment({
    required this.url,
  });

  final String url;
}

class Email {
  const Email({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class UserName{
  const UserName({
    required this.first,
    required this.last,
  });

  final String first;
  final String last;
  String get fullName => '$first $last';
}

class PetName{
  const PetName({
    required this.petname,
  });

  final String petname;
}

class User {
  const User({
    required this.name,
    required this.avatarUrl,
    required this.lastActive,
  });

  final UserName name;
  final String avatarUrl;
  final DateTime lastActive;
}

class Pet {
  const Pet({
    required this.animal,
    required this.petname,
    required this.age,
    required this.avatarUrl,
    required this.adoptStart,
    required this.availableStatus,
  });

  final String animal;
  final PetName petname;
  final int age;
  final String avatarUrl;
  final String adoptStart;
  final DateTime availableStatus;
}