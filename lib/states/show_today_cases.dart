import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmovie/models/covid_model.dart';
import 'package:projectmovie/utility/my_constant.dart';
import 'package:projectmovie/widgets/show_progress.dart';
import 'package:projectmovie/widgets/show_title.dart';

class ShowTodayCases extends StatefulWidget {
  ShowTodayCases({Key? key}) : super(key: key);

  @override
  _ShowTodayCasesState createState() => _ShowTodayCasesState();
}

class _ShowTodayCasesState extends State<ShowTodayCases> {
  bool load = true;
  CovidModel? model;
  String? day, month, year;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readTodayCasesAPI();
  }

  Future<Null> readTodayCasesAPI() async {
    await Dio().get(MyConstant.apiTodayCases).then((value) {
      print('value = $value');
      setState(() {
        load = false;
        model = CovidModel.fromMap(value.data);
        createDayMonthYear();
      });
    });
  }

  void createDayMonthYear() {
    List<String> strings = model!.UpdateDate.split(' ');
    print('String[0] ==> ${strings[0]}');
    List<String> results = strings[0].split('/');
    day = results[0];

    switch (results[1]) {
      case '01':
        month = 'ม.ค.';
        break;
      case '02':
        month = 'ก.พ.';
        break;
      case '03':
        month = 'มี.ค.';
        break;
      case '04':
        month = 'เม.ษ.';
        break;
      case '05':
        month = 'พ.ค.';
        break;
      case '06':
        month = 'มิ.ย.';
        break;
      case '07':
        month = 'ก.ค.';
        break;
      case '08':
        month = 'ส.ค.';
        break;
      case '09':
        month = 'ก.ย.';
        break;
      case '10':
        month = 'ต.ค.';
        break;
      case '11':
        month = 'พ.ย.';
        break;
      case '12':
        month = 'ธ.ค.';
        break;

      default:
    }

    print('month = $month');

    int yearInt = int.parse(results[2]) + 543;
    year = yearInt.toString();
    year = year!.substring(2, year!.length);
    print('year = $year');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Show Today cases'),
      // ),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(color: MyConstant.bg),
          child: load ? ShowProgress() : buildContent(constraints),
        ),
      ),
    );
  }

  Column buildContent(BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        rowHead(),
        buildMiddle(constraints),
        buildRow2(constraints),
        buildRow3(constraints),
      ],
    );
  }

  Container buildRow2(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          rowMidLeft(constraints),
          rowMidRight(constraints),
        ],
      ),
    );
  }

  Container buildRow3(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          rowMidLeft2(constraints),
          rowMidRight2(constraints),
        ],
      ),
    );
  }

  Container rowMidLeft(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MyConstant.red, MyConstant.bg],
        ),
      ),
      child: Column(
        children: [
          ShowTitle(
            title: 'ผู้ป่วยสะสม',
            textStyle: MyConstant().h3Style(),
          ),
          ShowTitle(
            title: 'ตั้งแต่ 1 เมษายน 2564',
            textStyle: MyConstant().h4Style(),
          ),
          ShowTitle(
            title: model!.cases.toString(),
            textStyle: MyConstant().h2Style(),
          ),
        ],
      ),
    );
  }

  Container rowMidLeft2(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, MyConstant.bg],
        ),
      ),
      child: Column(
        children: [
          ShowTitle(
            title: 'เสียชีวิต',
            textStyle: MyConstant().h3Style(),
          ),
          ShowTitle(
            title: model!.todayDeaths.toString(),
            textStyle: MyConstant().h2Style(),
          ),
        ],
      ),
    );
  }

  Container rowMidRight2(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MyConstant.greenDark, MyConstant.bg],
        ),
      ),
      child: Column(
        children: [
          ShowTitle(
            title: 'หายป่วยกลับบ้าน',
            textStyle: MyConstant().h3Style(),
          ),
          ShowTitle(
            title: '+${model!.todayRecovered.toString()}',
            textStyle: MyConstant().h2Style(),
          ),
        ],
      ),
    );
  }

  Container rowMidRight(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MyConstant.greenLight, MyConstant.bg],
        ),
      ),
      child: Column(
        children: [
          ShowTitle(
            title: 'หายป่วยสะสม',
            textStyle: MyConstant().h3Style(),
          ),
          ShowTitle(
            title: 'ตั้งแต่ 1 เมษายน 2564',
            textStyle: MyConstant().h4Style(),
          ),
          ShowTitle(
            title: model!.recovered.toString(),
            textStyle: MyConstant().h2Style(),
          ),
        ],
      ),
    );
  }

  Container buildMiddle(BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      width: constraints.maxWidth * 0.8, //หน้าจอ 80%
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyConstant.bg,
            MyConstant.red,
            MyConstant.red,
            MyConstant.red,
            MyConstant.red,
            MyConstant.red,
            MyConstant.bg,
          ],
        ),
      ),
      child: Column(
        children: [
          ShowTitle(
            title: 'ผู้ติดเชื้อวันนี้',
            textStyle: MyConstant().h3Style(),
          ),
          ShowTitle(
            title: '+${model!.todayCases}',
            textStyle: MyConstant().h1Style(),
          ),
          // buildRowMiddle(),
        ],
      ),
    );
  }

  Row buildRowMiddle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            ShowTitle(
              title: 'ผู้ติดเชื้อใหม่',
              textStyle: MyConstant().h4Style(),
            ),
            ShowTitle(
              title: '+14,000',
              textStyle: MyConstant().h2Style(),
            ),
          ],
        ),
        Column(
          children: [
            ShowTitle(
              title: 'จากเรือนจำ/ผู้ต้องขัง',
              textStyle: MyConstant().h4Style(),
            ),
            ShowTitle(
              title: '+500',
              textStyle: MyConstant().h2Style(),
            ),
          ],
        ),
      ],
    );
  }

  Row rowHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildHeadLeft(),
        SizedBox(
          width: 6,
        ),
        buildHeadRight(),
      ],
    );
  }

  Column buildHeadLeft() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShowTitle(
          title: day!,
          textStyle: MyConstant().h1Style(),
        ),
        ShowTitle(
          title: '$month$year',
          textStyle: MyConstant().h2Style(),
        ),
      ],
    );
  }

  Column buildHeadRight() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShowTitle(
          title: 'สถานการณ์ COVID-19',
          textStyle: MyConstant().h3Style(),
        ),
        ShowTitle(
          title: 'ในประเทศไทย',
          textStyle: MyConstant().h2Style(),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 4,
          ),
          decoration: BoxDecoration(color: MyConstant.red),
          child: ShowTitle(
            title: 'ตั้งแต่ 1 เมษายน 2564',
            textStyle: MyConstant().h4Style(),
          ),
        ),
      ],
    );
  }
}
