import 'package:flutter/material.dart';
import 'package:projectmovie/states/authen.dart';
import 'package:projectmovie/states/create_new_account.dart';
import 'package:projectmovie/states/introduction.dart';
import 'package:projectmovie/states/show_food.dart';
import 'package:projectmovie/states/show_today_cases.dart';
import 'package:projectmovie/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/showTodayCases': (BuildContext context) => ShowTodayCases(),
  '/introduction': (BuildContext context) => Introduction(),
  '/authen': (BuildContext context) => Authen(),
  '/createNewAccount': (BuildContext context) => CreateNewAccount(),
  '/showFood': (BuildContext context) => ShowFood(),
};

String? firstState;

Future<Null> main() async {
  // firstState = MyConstant.routeAuthen;
  // runApp(MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<String>? strings = preferences.getStringList('user');
  print('string ==> $strings');
  if (strings == null) {
    firstState = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    firstState = MyConstant.routeShowFood;
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: firstState,
      title: 'Covid Todays',
    );
  }
}
