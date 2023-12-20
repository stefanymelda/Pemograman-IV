import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> user) {
    return User(
      id: user['id'],
      email: user['email'],
      firstName: user['first_name'],
      lastName: user['last_name'],
      avatar: user['avatar'],
    );
  }
}

class UserCreate {
  final String? id;
  final String name;
  final String job;
  final String? createdAt;

  UserCreate({
    this.id,
    required this.name,
    required this.job,
    this.createdAt,
  });

  factory UserCreate.fromJson(Map<String, dynamic> user) {
    tz.initializeTimeZones();
    final jakartaTimeZone = tz.getLocation('Asia/Jakarta');
    final jakartaCurrentTime = tz.TZDateTime.now(jakartaTimeZone);
    final createdAt = DateFormat.yMd().add_jm().format(jakartaCurrentTime);
    return UserCreate(
      id: user['id'],
      name: user['name'],
      job: user['job'],
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'job': job,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'UserCreate{id, name: $name, job: $job, createdAt: $createdAt}';
  }
}

class UserPut {
  final String name;
  final String job;
  final String? updatedAt;

  UserPut({
    required this.name,
    required this.job,
    this.updatedAt,
  });

  factory UserPut.fromJson(Map<String, dynamic> user) {
    tz.initializeTimeZones();
    final jakartaTimeZone = tz.getLocation('Asia/Jakarta');
    final jakartaCurrentTime = tz.TZDateTime.now(jakartaTimeZone);
    final updatedAt = DateFormat.yMd().add_jm().format(jakartaCurrentTime);
    return UserPut(
      name: user['name'],
      job: user['job'],
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'job': job,
    };
  }

  @override
  String toString() {
    return 'UserPut{ name: $name, job: $job, updatedAt: $updatedAt}';
  }
}
