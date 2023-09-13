import 'package:calendar_test/logging.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserSignIn {
  final log = logger(UserSignIn);

  static const List<String> scopes = [
    'email',
    'https://www.googleapis.com/auth/calendar',
  ];

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes);

  Future<GoogleSignInAccount?> login() async {
    GoogleSignInAccount? currentUser;
    bool authorised = false;

    /*googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      authorised = account != null;
      currentUser = account;

      if (authorised) {
        log.i("signed in with ${currentUser!.email}");
      }
    });*/

    currentUser = await googleSignIn.signIn();

    authorised = (currentUser != null);

    if (authorised) {
      log.i("signed in with ${currentUser.email}");
    }

    //googleSignIn.signInSilently();
    return currentUser;
  }
}
