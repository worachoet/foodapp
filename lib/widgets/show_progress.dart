import 'package:flutter/material.dart';
import 'package:projectmovie/utility/my_constant.dart';

class ShowProgress extends StatelessWidget {
  const ShowProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: MyConstant.greenDark,
      ),
    );
  }
}
