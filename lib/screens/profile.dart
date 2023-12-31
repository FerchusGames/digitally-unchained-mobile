import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitally_unchained/collections/pref_keys.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:digitally_unchained/collections/global_data.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double textFieldVerticalSpace = 40;
  double labelVerticalSpace = 8;

  String? firstName;
  String? lastName;
  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.backgroundMain),
      body: GestureDetector(
        onTap: () {
          MyFunctions.unfocusWidgets(context);
        },
        child: ListView(
          children: [
            SizedBox(
              height: 20,
              width: double.infinity,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(MyColors.darkIconBackground),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        MyFunctions.logout(context);
                      },
                      child: Icon(
                        Icons.logout,
                        color: Color(MyColors.darkIconBackground),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
              width: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: ClipOval(
                  child: Container(
                    height: 160,
                    width: 160,
                    child: FutureBuilder<String>(
                      future: MyFunctions.getProfilePicture(),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Show a loading indicator while waiting for the future to complete
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // Handle any errors that might have occurred
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          // Once the future completes, use the data to display the image
                          return Image.network(snapshot.data!, fit: BoxFit.cover);
                        } else {
                          // Handle the case where snapshot has no data
                          return Center(child: Text('No image available'));
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
              width: double.infinity,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context)
                        .pushNamed('/edit_profile')
                        .then((value) {
                      updateProfileFromPrefs();
                    });
                  },
                  child: Text(
                    'EDIT YOUR PROFILE',
                    style: TextStyles.buttonText,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'First Name',
                style: TextStyles.label,
              ),
            ),
            SizedBox(
              height: labelVerticalSpace,
              width: double.infinity,
            ),
            DarkTextField(
              label: firstName,
              textController: TextEditingController(),
              isEnabled: false,
            ),
            SizedBox(
              height: textFieldVerticalSpace,
              width: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Last Name',
                style: TextStyles.label,
              ),
            ),
            SizedBox(
              height: labelVerticalSpace,
              width: double.infinity,
            ),
            DarkTextField(
              label: lastName,
              textController: TextEditingController(),
              isEnabled: false,
            ),
            SizedBox(
              height: textFieldVerticalSpace,
              width: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Email Address',
                style: TextStyles.label,
              ),
            ),
            SizedBox(
              height: labelVerticalSpace,
              width: double.infinity,
            ),
            DarkTextField(
              label: email,
              textController: TextEditingController(),
              isEnabled: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    updateProfileFromPrefs();
  }

  Future<void> updateProfileFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Updating profile from prefs');

    String? newLastName = prefs.getString(PrefKey.lastName);
    String? newFirstName = prefs.getString(PrefKey.firstName);
    String? newEmail = prefs.getString(PrefKey.email);

    setState(() {
      firstName = newFirstName;
      lastName = newLastName;
      email = newEmail;
    });
  }
}
