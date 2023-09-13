import 'package:calendar_test/calendar_client.dart';
import 'package:calendar_test/dateFormat.dart';
import 'package:calendar_test/dateTimePicker.dart';
import 'package:calendar_test/logging.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  var log = logger(FormPage);

  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  DateTime? start;
  DateTime? end;

  var startDate = TextEditingController();
  var endDate = TextEditingController();
  var title = TextEditingController();
  var description = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDate.text = "start date";
    endDate.text = "end date";
    title.text = "title....";
    description.text = "description....";

    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  void onSubmit() async {
    log.d(
        "on submit pressed \n ${title.text} ${description.text} ${startDate.text} ${endDate.text}");

    //conf data entry point uri me link

    List<String> choices = ["Once", "Daily", "Workdays", "Weekend"];
    String selectedChoice = choices[0];
    List<String> recurrenceList = [];

    //once
    if (selectedChoice == choices[0]) {
      recurrenceList = [];
    }
    //daily
    else if (selectedChoice == choices[1]) {
      recurrenceList = ['RRULE:FREQ=DAILY'];
    }
    //workdays
    else if (selectedChoice == choices[2]) {
      recurrenceList = ['RRULE:FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR'];
    }
    //weekends
    else {
      recurrenceList = ['RRULE:FREQ=WEEKLY;BYDAY=SA,SU'];
    }

    final uid = Uuid();

    Event event = Event(
      summary: title.text,
      description: description.text,
      start: EventDateTime(dateTime: start, timeZone: start!.timeZoneName),
      end: EventDateTime(dateTime: end, timeZone: end!.timeZoneName),
      conferenceData: ConferenceData(
        createRequest: CreateConferenceRequest(
          requestId: uid.v4(),
        ),
      ),
      recurrence: recurrenceList,
    );

    CalendarClient().insert(event);
  }

  @override
  @override
  Widget build(BuildContext context) {
    log.i(
        "package details ${packageInfo.appName} \n ${packageInfo.packageName}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar Expt"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextButton(
              child: Text(startDate.text),
              onPressed: () async {
                start =
                    await DateTimePicker(context).getDateTime(DateTime.now());
                setState(() {
                  startDate.text = dateFormat.toLocalString(start.toString());
                });
              },
            ),
            TextButton(
              child: Text(endDate.text),
              onPressed: () async {
                end = await DateTimePicker(context).getDateTime(DateTime.now());
                setState(() {
                  endDate.text = dateFormat.toLocalString(end.toString());
                });
              },
            ),
            TextField(
              controller: title,
            ),
            TextField(
              controller: description,
            ),
            TextButton(
              onPressed: onSubmit,
              child: const Text("submit"),
            ),
            TextButton(
              onPressed: () {
                CalendarClient().get("skatl7ojujo3up6mqqsnjik3e8");
              },
              child: const Text("Get"),
            ),
          ],
        ),
      ),
    );
  }
}
