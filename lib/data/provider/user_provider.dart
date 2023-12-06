import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:soltalk/data/db/entity/chat.dart';
import 'package:soltalk/data/db/remote/firebase_auth_source.dart';
import 'package:soltalk/data/db/remote/firebase_database_source.dart';
import 'package:soltalk/data/db/remote/firebase_storage_source.dart';
import 'package:soltalk/data/db/remote/response.dart';
import 'package:soltalk/data/model/chat_with_user.dart';
import 'package:soltalk/data/model/user_registration.dart';
import 'package:soltalk/util/shared_preferences_utils.dart';
import 'package:soltalk/data/db/entity/app_user.dart';
import 'package:soltalk/util/utils.dart';
import 'package:soltalk/data/db/entity/match.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuthSource _authSource = FirebaseAuthSource();
  final FirebaseStorageSource _storageSource = FirebaseStorageSource();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();

  bool isLoading = false;
  AppUser? _user;

  Future<AppUser?> get user => _getUser();

  Future<Response> loginUser(String email, String password,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    Response<dynamic> response = await _authSource.signIn(email, password);
    if (response is Success<UserCredential>) {
      String id = response.value.user!.uid;
      SharedPreferencesUtil.setUserId(id);
    } else if (response is Error) {
      showSnackBar(errorScaffoldKey, response.message);
    }
    return response;
  }

  Future<Response> registerUser(UserRegistration userRegistration,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    Response<dynamic> response = await _authSource.register(
        userRegistration.email, userRegistration.password);
    if (response is Success<UserCredential>) {
      String id = response.value.user!.uid;
      response = await _storageSource.uploadUserProfilePhoto(
          userRegistration.localProfilePhotoPath, id);

      if (response is Success<String>) {
        String profilePhotoUrl = response.value;
        AppUser user = AppUser(
            id: id,
            name: userRegistration.name,
            age: userRegistration.age,
            sexOrientation: userRegistration.sexOrientation,
            profilePhotoPath: profilePhotoUrl);
        _databaseSource.addUser(user);
        SharedPreferencesUtil.setUserId(id);
        _user = _user;
        return Response.success(user);
      }
    }
    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }


  Future<Response> loginUserGoogle(
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    Response<dynamic> response = await _authSource.signInWithGoogle();
    if (response is Success<UserCredential>) {
      String id = response.value.user!.uid;
      SharedPreferencesUtil.setUserId(id);
    } else if (response is Error) {
      showSnackBar(errorScaffoldKey, response.message);
    }

   AppUser? user =   await _getUser();
   if(user == null){
    showSnackBar(errorScaffoldKey, "regist please!");
    return Response.error('regist please!') ;
   }

    return response;
  }

  Future<Response> registerUserGoogle(UserRegistration userRegistration,
      GlobalKey<ScaffoldState> errorScaffoldKey) async {
    Response<dynamic> response = await _authSource.signInWithGoogle()
        ;
    if (response is Success<UserCredential>) {
      String id = response.value.user!.uid;
      response = await _storageSource.uploadUserProfilePhoto(
          userRegistration.localProfilePhotoPath, id);

      if (response is Success<String>) {
        String profilePhotoUrl = response.value;
        AppUser user = AppUser(
            id: id,
            name: userRegistration.name,
            age: userRegistration.age,
            sexOrientation: userRegistration.sexOrientation,
            profilePhotoPath: profilePhotoUrl);
        _databaseSource.addUser(user);
        SharedPreferencesUtil.setUserId(id);
        _user = _user;
        return Response.success(user);
      }
    }
    if (response is Error) showSnackBar(errorScaffoldKey, response.message);
    return response;
  }

  Future<AppUser?> _getUser() async {
    if (_user != null) return _user!;
    String? id = await SharedPreferencesUtil.getUserId();
    DocumentSnapshot documentSnapshot =  await _databaseSource.getUser(id ?? '');
    //print('documentSnapshot.exists===>>> ${documentSnapshot.exists}');
    //print('documentSnapshot.id===>>> ${documentSnapshot.id}');
    if(!documentSnapshot.exists) return null;

    _user = AppUser.fromSnapshot(documentSnapshot);
    return _user;
  }

  void updateUserProfilePhoto(
      String localFilePath, GlobalKey<ScaffoldState> errorScaffoldKey) async {
    isLoading = true;
    notifyListeners();
    Response<dynamic> response =
        await _storageSource.uploadUserProfilePhoto(localFilePath, _user!.id);
    isLoading = false;
    if (response is Success<String>) {
      _user!.profilePhotoPath = response.value;
      _databaseSource.updateUser(_user!);
    } else if (response is Error) {
      showSnackBar(errorScaffoldKey, response.message);
    }
    notifyListeners();
  }

  void updateUserBio(String newBio) {
    _user!.bio = newBio;
    _databaseSource.updateUser(_user!);
    notifyListeners();
  }

    void updateUserSexOrientation(String newSexOrientation) {
    _user!.sexOrientation = newSexOrientation;
    _databaseSource.updateUser(_user!);
    notifyListeners();
  }

  Future<void> logoutUser() async {
    _user = null;
    await SharedPreferencesUtil.removeUserId();
    _authSource.instance.signOut();
     await GoogleSignIn().signOut();
  }

  Future<List<ChatWithUser>> getChatsWithUser(String userId) async {
    var matches = await _databaseSource.getMatches(userId);
    List<ChatWithUser> chatWithUserList = [];

    for (var i = 0; i < matches.size; i++) {
      Match match = Match.fromSnapshot(matches.docs[i]);
      AppUser matchedUser =
          AppUser.fromSnapshot(await _databaseSource.getUser(match.id));

      String chatId = compareAndCombineIds(match.id, userId);

      Chat chat = Chat.fromSnapshot(await _databaseSource.getChat(chatId));
      ChatWithUser chatWithUser = ChatWithUser(chat, matchedUser);
      chatWithUserList.add(chatWithUser);
    }
    return chatWithUserList;
  }
}
