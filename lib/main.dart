import 'package:flutter/material.dart';
import 'ui/welcome_page.dart';
import 'ui/signup_page.dart';
import 'ui/signin_page.dart';
import 'ui/dashboard_page.dart';
import 'ui/to_campus_page.dart';
import 'ui/from_campus_page.dart';
import 'ui/schedule_team_ride_page.dart';
import 'ui/onboard_scheduled_ride_page.dart';
import 'ui/shared_ride_code_page.dart';
import 'ui/shared_ride_dashboard_page.dart';
import 'ui/payment_page.dart';

void main() {
  runApp(TunyukeApp());
}

class TunyukeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tunyuke',
      theme: ThemeData(
        primaryColor: Color(0xFF8E2BBC),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        // (You can add additional theme settings as needed)
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => WelcomePage());
          case '/signup':
            return MaterialPageRoute(builder: (context) => SignUpPage());
          case '/signin':
            return MaterialPageRoute(builder: (context) => SignInPage());
          case '/dashboard':
            return MaterialPageRoute(builder: (context) => DashboardPage());
          case '/to_campus':
            return MaterialPageRoute(builder: (context) => ToCampusPage());
          case '/from_campus':
            return MaterialPageRoute(builder: (context) => FromCampusPage());
          case '/schedule_team_ride':
            return MaterialPageRoute(
                builder: (context) => ScheduleTeamRidePage());
          case '/onboard_scheduled_ride':
            return MaterialPageRoute(
                builder: (context) => OnboardScheduledRidePage());
          case '/shared_ride_code':
            return MaterialPageRoute(
                builder: (context) => SharedRideCodePage());
          case '/shared_ride_dashboard':
            return MaterialPageRoute(
                builder: (context) => SharedRideDashboardPage());
          case '/payment':
            return MaterialPageRoute(builder: (context) => PaymentPage());
          default:
            return MaterialPageRoute(builder: (context) => WelcomePage());
        }
      },
    );
  }
}
