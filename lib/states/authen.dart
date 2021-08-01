import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmovie/models/user_model.dart';
import 'package:projectmovie/utility/my_constant.dart';
import 'package:projectmovie/utility/my_dialog.dart';
import 'package:projectmovie/widgets/show_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .requestFocus(FocusNode()); ////กดตรงไหนก็ได้ keyboard หาย
          },
          behavior: HitTestBehavior.opaque, ////กดตรงไหนก็ได้ keyboard หาย
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildImage(constraints),
                    buildUser(constraints),
                    buildPassword(constraints),
                    buildLogin(constraints),
                    buildCreateAccount(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('No Account ?'),
        TextButton(
          onPressed: () =>
              Navigator.pushNamed(context, MyConstant.routeCreateNewAccount),
          child: Text(' Create New Account'),
        ),
      ],
    );
  }

  Container buildLogin(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            checkAuthen();
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    String urlAPI =
        '${MyConstant.domain}/foodapp/getUserWhereUser.php?isAdd=true&user=${userController.text}';
    await Dio().get(urlAPI).then(
      (value) async {
        print('value ==> $value');
        if (value.toString() == 'null') {
          MyDialog().normalDialog(
              context, 'User False ?', 'No This User in My Database');
        } else {
          for (var item in jsonDecode(value.data)) {
            UserModel model = UserModel.fromMap(item);
            if (passwordController.text == model.password) {
              List<String> strings = [];
              strings.add(model.id);
              strings.add(model.name);
              strings.add(model.user);

              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.setStringList('user', strings).then((value) => {
                    Navigator.pushNamedAndRemoveUntil(
                        context, MyConstant.routeShowFood, (route) => false)
                  });
            } else {
              MyDialog().normalDialog(
                  context, 'PasswordFalse', 'Please Try Again Password False');
            }
          }
        }
      },
    );
  }

  Container buildUser(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill User';
          } else {
            return null;
          }
        },
        controller: userController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_identity),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPassword(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: constraints.maxWidth * 0.75,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Password';
          } else {
            return null;
          }
        },
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildImage(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.6,
      child: ShowImage(),
    );
  }
}
