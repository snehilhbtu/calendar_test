import 'package:calendar_test/logging.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class CalendarClient {
  final log = logger(CalendarClient);

  final googleSignIn = GoogleSignIn(
    scopes: <String>[CalendarApi.calendarScope],
  );
  //skatl7ojujo3up6mqqsnjik3e8
  void insert(Event event) async {
    GoogleSignInAccount? account = (await googleSignIn.signIn());

    if (account != null) {
      log.i("user logged in ${account.email}");
    }

    AuthClient? authClient = await googleSignIn.authenticatedClient();

    log.i(
        "user state ${authClient!.credentials.accessToken} ${authClient.credentials.idToken} ${authClient.credentials.scopes}");

    final CalendarApi googleCalendarApi = CalendarApi(authClient!);

    try {
      googleCalendarApi.events
          .insert(event, "primary", conferenceDataVersion: 1)
          .then((value) {
        if (value.status == "confirmed") {
          log.i('Event added in google calendar');
          log.i(value.id);
          log.i("conf data ${value.conferenceData!.entryPoints![0].uri} ");
        } else {
          log.i("Unable to add event in google calendar");
        }
        return value.id;
      });
      return null;
    } catch (err) {
      log.i('Error creating event: $err');
    }
  }

  void get(String id) async {
    GoogleSignInAccount? account = (await googleSignIn.signIn());

    if (account != null) {
      log.i("user logged in ${account.email}");
    }

    AuthClient? authClient = await googleSignIn.authenticatedClient();

    final CalendarApi googleCalendarApi = CalendarApi(authClient!);

    try {
      googleCalendarApi.events.get("primary", id).then((value) {
        if (value.status == "confirmed") {
          log.i('Event got in google calendar');
          log.i(value.id);
          log.i("conf data ${value.conferenceData!.conferenceId} ");
        } else {
          log.i("Unable to get event in google calendar");
        }
        return value.id;
      });
      return null;
    } catch (err) {
      log.i('Error getting event: $err');
    }
  }
}
