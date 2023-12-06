import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:soltalk/data/db/entity/app_user.dart';
import 'package:soltalk/data/provider/user_provider.dart';
import 'package:soltalk/ui/screens/start_screen.dart';
import 'package:soltalk/ui/widgets/custom_modal_progress_hud.dart';
import 'package:soltalk/ui/widgets/input_dialog.dart';
import 'package:soltalk/ui/widgets/rounded_icon_button.dart';
import 'package:soltalk/ui/widgets/sex_orientation_dialog.dart';
import 'package:soltalk/util/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var soValue = 'Opposite sex';
  void logoutPressed(UserProvider userProvider, BuildContext context) async {
    userProvider.logoutUser();
    Navigator.pop(context);
    Navigator.pushNamed(context, StartScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 42.0,
          horizontal: 18.0,
        ),
        margin: const EdgeInsets.only(bottom: 40),
        child: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return FutureBuilder<AppUser?>(
              future: userProvider.user,
              builder: (context, userSnapshot) {
                return CustomModalProgressHUD(
                    inAsyncCall: userProvider.isLoading,
                    offset: null,
                    child: userSnapshot.hasData
                        ? Column(children: [
                            getProfileImage(userSnapshot.data!, userProvider),
                            const SizedBox(height: 20),
                            Text(
                                '${userSnapshot.data!.name}, ${userSnapshot.data!.age}',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 40),
                            getBio(userSnapshot.data!, userProvider),
                            Expanded(child: Container()),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                logoutPressed(userProvider, context);
                              },
                              child: const Text('LOGOUT'),
                            )
                          ])
                        : Container());
              });
        }),
      ),
    );
  }

  Widget getBio(AppUser user, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Bio', style: Theme.of(context).textTheme.headlineMedium),
            RoundedIconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => InputDialog(
                    onSavePressed: (value) => userProvider.updateUserBio(value),
                    labelText: 'Bio',
                    startInputText: user.bio,
                  ),
                );
              },
              iconData: Icons.edit,
              iconSize: 18,
              paddingReduce: 4,
              buttonColor: null,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          user.bio.isNotEmpty ? user.bio : "No bio.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sex orientation',
                style: Theme.of(context).textTheme.headlineMedium),
            RoundedIconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) =>  SexOrientationDialog(sexOrientation: user.sexOrientation),
                ).then((result){
                  if(result != null){
                    print('Selected Sex Orientation: $result');
                    if(user.sexOrientation != result){
                      userProvider.updateUserSexOrientation(result);
                    }
                  }
                });
              },
              iconData: Icons.edit,
              iconSize: 18,
              paddingReduce: 4,
              buttonColor: null,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          user.sexOrientation.isNotEmpty ? user.sexOrientation : "Opposite sex",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget getProfileImage(AppUser user, UserProvider firebaseProvider) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kAccentColor, width: 1.0),
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.profilePhotoPath),
            radius: 75,
          ),
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: RoundedIconButton(
            onPressed: () async {
              final pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                firebaseProvider.updateUserProfilePhoto(
                    pickedFile.path, _scaffoldKey);
              }
            },
            iconData: Icons.edit,
            iconSize: 18,
            buttonColor: null,
          ),
        ),
      ],
    );
  }
}
