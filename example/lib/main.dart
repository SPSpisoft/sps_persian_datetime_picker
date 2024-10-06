import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sps_persian_datetime_picker/sps_persian_datetime_picker.dart';
import 'dart:convert' as convert;

final ThemeData androidTheme = ThemeData(
  fontFamily: 'Dana',
);

void main() {
  // tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: androidTheme,
      home: const MyHomePage(title: 'دیت تایم پیکر فارسی'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String label = '';

  String selectedDate = Jalali.now().toJalaliDateTime();

  DateTime? dateTime;

  ClsTime? mDT;

  @override
  void initState() {
    // var locations = tz.timeZoneDatabase.locations;
    // print(">>>>  " + locations.length.toString());
    // print(">>  " + tz.local.name);


    super.initState();
    label = 'انتخاب تاریخ زمان';
  }

  @override
  Widget build(BuildContext context) {
    // fetchDateTime().then((value) => )
    return FutureBuilder<ClsTime>(
        future: fetchDateTime(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            mDT = snapshot.data!;

            // final Tehran = tz.getLocation('Asia/Tehran');
            // dateTime = DateTime.parse(mDT!.datetime!);
            // final localizedDt = tz.TZDateTime.from(dateTime!, Tehran);
            // print(">  " + localizedDt.toString());
            // dateTime = localizedDt;

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(
                    widget.title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                body: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [Colors.white, Color(0xffE4F5F9)],
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              imageButton(
                                onTap: () async {
                                  Jalali? picked = await showPersianDatePicker(
                                      context: context,
                                      currentDate: dateTime,
                                      helpText: "تاریخ تست",
                                      initialDate:
                                      Jalali.fromDateTime(dateTime!),
                                      firstDate: Jalali(1385, 8),
                                      lastDate: Jalali(1450, 9),
                                      initialEntryMode:
                                      PDatePickerEntryMode.calendar);
                                  if (picked != null &&
                                      picked != selectedDate) {
                                    setState(() {
                                      label = picked.toJalaliDateTime();
                                    });
                                  }
                                },
                                image: '08',
                              ),
                              imageButton(
                                onTap: () async {
                                  Jalali? pickedDate =
                                  await showModalBottomSheet<Jalali>(
                                    context: context,
                                    builder: (context) {
                                      Jalali? tempPickedDate;
                                      return Container(
                                        height: 250,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    child: const Text(
                                                      'لغو',
                                                      style: TextStyle(
                                                        fontFamily: 'Dana',
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  CupertinoButton(
                                                    child: const Text(
                                                      'تایید',
                                                      style: TextStyle(
                                                        fontFamily: 'Dana',
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(
                                                          tempPickedDate??
                                                              Jalali.now());
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 0,
                                              thickness: 1,
                                            ),
                                            Expanded(
                                              child: CupertinoTheme(
                                                data: const CupertinoThemeData(
                                                  textTheme:
                                                  CupertinoTextThemeData(
                                                    dateTimePickerTextStyle:
                                                    TextStyle(
                                                        fontFamily:
                                                        'Dana'),
                                                  ),
                                                ),
                                                child: PCupertinoDatePicker(
                                                  mode:
                                                  PCupertinoDatePickerMode
                                                      .dateAndTime,
                                                  onDateTimeChanged:
                                                      (Jalali dateTime) {
                                                    tempPickedDate = dateTime;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      label = '${pickedDate.toDateTime()}';
                                    });
                                  }
                                },
                                image: '07',
                              ),
                              imageButton(
                                onTap: () async {
                                  var picked = await showPersianTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(dateTime!),
                                    initialEntryMode:
                                    PTimePickerEntryMode.input,
                                    builder: (context, child) {
                                      return Directionality(textDirection: TextDirection.rtl, child: child!);
                                    },
                                    // builder:
                                    //     (BuildContext context, Widget child) {
                                    //   return Directionality(
                                    //     textDirection: TextDirection.rtl,
                                    //     child: child!,
                                    //   );
                                    // },
                                  );
                                  setState(() {
                                    if (picked != null)
                                      label = picked.persianFormat(context);
                                  });
                                },
                                image: '09',
                              ),
                              imageButton(
                                onTap: () async {
                                  Jalali? pickedDate =
                                  await showModalBottomSheet<Jalali>(
                                    context: context,
                                    builder: (context) {
                                      Jalali? tempPickedDate;
                                      return Container(
                                        height: 250,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    child: const Text(
                                                      'لغو',
                                                      style: TextStyle(
                                                        fontFamily: 'Dana',
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  CupertinoButton(
                                                    child: const Text(
                                                      'تایید',
                                                      style: TextStyle(
                                                        fontFamily: 'Dana',
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      print(tempPickedDate);

                                                      Navigator.of(context)
                                                          .pop(tempPickedDate);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 0,
                                              thickness: 1,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: CupertinoTheme(
                                                  data: const CupertinoThemeData(
                                                    textTheme:
                                                    CupertinoTextThemeData(
                                                      dateTimePickerTextStyle:
                                                      TextStyle(
                                                          fontFamily:
                                                          'Dana'),
                                                    ),
                                                  ),
                                                  child: PCupertinoDatePicker(
                                                    mode:
                                                    PCupertinoDatePickerMode
                                                        .time,
                                                    onDateTimeChanged:
                                                        (Jalali dateTime) {
                                                      tempPickedDate = dateTime;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      label =
                                      '${pickedDate.toJalaliDateTime()}';
                                    });
                                  }
                                },
                                image: '05',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              imageButton(
                                onTap: () async {
                                  var picked = await showPersianDateRangePicker(
                                    context: context,
                                    initialDateRange: JalaliRange(
                                      start: Jalali(1400, 1, 2),
                                      end: Jalali(1400, 1, 10),
                                    ),
                                    firstDate: Jalali(1385, 8),
                                    lastDate: Jalali(1450, 9),
                                  );
                                  setState(() {
                                    label =
                                    "${picked?.start.toJalaliDateTime() ?? ""} ${picked?.end.toJalaliDateTime() ?? ""}";
                                  });
                                },
                                image: '03',
                              ),
                              imageButton(
                                onTap: () async {
                                  var picked = await showPersianTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(dateTime!),
                                    builder: (context, child) {
                                      return Directionality(textDirection: TextDirection.rtl, child: child!);
                                    },
                                    // builder: (BuildContext context, Widget child) {
                                    //   return Directionality(
                                    //     textDirection: TextDirection.rtl,
                                    //     child: child,
                                    //   );
                                    // },
                                  );
                                  setState(() {
                                    if (picked != null)
                                      label = picked.persianFormat(context);
                                  });
                                },
                                image: '04',
                              ),
                              imageButton(
                                onTap: () async {
                                  var picked = await showPersianDateRangePicker(
                                    context: context,
                                    initialEntryMode:
                                    PDatePickerEntryMode.input,
                                    initialDateRange: JalaliRange(
                                      start: Jalali(1400, 1, 2),
                                      end: Jalali(1400, 1, 10),
                                    ),
                                    firstDate: Jalali(1385, 8),
                                    lastDate: Jalali(1450, 9),
                                  );
                                  setState(() {
                                    label =
                                    "${picked?.start.toJalaliDateTime() ?? ""} ${picked?.end.toJalaliDateTime() ?? ""}";
                                  });
                                },
                                image: '06',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 70,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                      color: const Color(0xff000000).withOpacity(0.3),
                    ),
                  ], color: Colors.white),
                  child: Center(
                    child: Text(
                      label,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget imageButton({
    onTap,
    String? image,
  }) {
    return ScaleGesture(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                spreadRadius: 0,
                offset: const Offset(0, 4),
                color: const Color(0xff000000).withOpacity(0.3),
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Image.asset(
          'assets/images/$image.png',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

class ScaleGesture extends StatefulWidget {
  final Widget? child;
  final double scale;
  final VoidCallback? onTap;

  const ScaleGesture({
    this.child,
    this.scale = 1.1,
    this.onTap,
  });

  @override
  _ScaleGestureState createState() => _ScaleGestureState();
}

class _ScaleGestureState extends State<ScaleGesture> {
  double? scale;

  @override
  void initState() {
    scale = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (detail) {
        setState(() {
          scale = widget.scale;
        });
      },
      onTapCancel: () {
        setState(() {
          scale = 1;
        });
      },
      onTapUp: (datail) {
        setState(() {
          scale = 1;
        });
        widget.onTap!();
      },
      child: Transform.scale(
        scale: scale,
        child: widget.child,
      ),
    );
  }
}

Future<ClsTime> fetchDateTime() async {
  ClsTime sRet = ClsTime();
  var url = Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Tehran');

  // try {
  //   final response = await http.get(
  //     url,
  //     headers: <String, String>{
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //       // 'authorization': Globals.basicAuth
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print(convert.jsonDecode(response.body));
  //     sRet = ClsTime.fromJson(convert.jsonDecode(response.body));
  //   } else {
  //     print(response.statusCode);
  //     print(response.body);
  //   }
  // } catch (e) {
  //   print(e);
  //   return Future.error(e.toString());
  // }

  return sRet;
}

// List<ClsTime> clsTimeFromJson(String str) =>
//     List<ClsTime>.from(convert.json.decode(str).map((x) => ClsTime.fromJson(x)));

// String clsTimeToJson(List<ClsTime> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClsTime {
  ClsTime(
      {this.abbreviation,
        this.client_ip,
        this.datetime,
        this.day_of_week,
        this.day_of_year,
        this.dst,
        this.dst_from,
        this.dst_offset,
        this.dst_until,
        this.raw_offset,
        this.timezone,
        this.unixtime,
        this.utc_datetime,
        this.utc_offset,
        this.week_number});

  String? abbreviation;
  String? client_ip;
  String? datetime;
  int? day_of_week;
  int? day_of_year;
  bool? dst;
  String? dst_from;
  int? dst_offset;
  String? dst_until;
  int? raw_offset;
  String? timezone;
  int? unixtime;
  String? utc_datetime;
  String? utc_offset;
  int? week_number;

  factory ClsTime.fromJson(Map<String, dynamic> json) => ClsTime(
    abbreviation: json["abbreviation"],
    week_number: json["week_number"],
    utc_offset: json["utc_offset"],
    utc_datetime: json["utc_datetime"],
    unixtime: json["unixtime"],
    timezone: json["timezone"],
    raw_offset: json["raw_offset"],
    dst_until: json["dst_until"],
    dst_offset: json["dst_offset"],
    dst_from: json["dst_from"],
    dst: json["dst"],
    day_of_year: json["day_of_year"],
    day_of_week: json["day_of_week"],
    datetime: json["datetime"],
    client_ip: json["client_ip"],
  );

// Map<String, dynamic> toJson() =>
//     {
//       "NetRec": netRec,
//
//     };
}
