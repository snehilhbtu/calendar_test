import 'logging.dart';
import 'package:flutter/material.dart';

class DateTimePicker {
  final BuildContext context;
  DateTimePicker(this.context);

  final log = logger(DateTimePicker);

  //date time picker function, gives string of local time
  Future<DateTime> getDateTime(DateTime dateTime) async {
    DateTime selectedDateTime = dateTime;
    DateTime? date = await datePicker(dateTime);
    TimeOfDay? time = await timePicker(dateTime);
    //exception handling in case user cancels time selecting
    try {
      selectedDateTime =
          DateTime(date!.year, date.month, date.day, time!.hour, time.minute);
      log.i('selected DateTime is - ${selectedDateTime.toString()}');
    } catch (e) {
      log.i(
          'caught exception $e ,since Date-Time wasnt selected ,present time selected as default');
    }

    return selectedDateTime;
  }

  //selecting day
  Future<DateTime?> datePicker(DateTime dateTime) async {
    return await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: dateTime,
      lastDate: DateTime(2025),
    );
  }

  //selecting time
  Future<TimeOfDay?> timePicker(DateTime dateTime) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
    );
  }
}
