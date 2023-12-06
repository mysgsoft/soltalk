import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String id;
  String name;
  int age;
  String sexOrientation = "";
  String profilePhotoPath;
  String bio = "";
  

  AppUser(
      {required this.id,
      required this.name,
      required this.age,
      required this.sexOrientation,
      required this.profilePhotoPath});

  AppUser.fromSnapshot(DocumentSnapshot snapshot) :
    id = snapshot['id'],
    name = snapshot['name'],
    age = snapshot['age'],
    sexOrientation = snapshot['sex_orientation'] ?? 'Opposite sex',
    profilePhotoPath = snapshot['profile_photo_path'],
    bio = snapshot.get('bio') ?? '';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'sex_orientation' : sexOrientation,
      'profile_photo_path': profilePhotoPath,
      'bio': bio
    };
  }
}
