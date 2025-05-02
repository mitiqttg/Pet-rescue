import 'models.dart';

final User user_0 = User(
    name: const UserName(first: 'Tom', last: 'Tran'),
    avatarUrl: 'assets/user1.png',
    lastActive: DateTime.now());
final User user_1 = User(
    name: const UserName(first: 'Gracie', last: 'Le'),
    avatarUrl: 'assets/user0.png',
    lastActive: DateTime.now().subtract(const Duration(minutes: 10)));

