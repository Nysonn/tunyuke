import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../data/dummy_data.dart';

class SharedRideCodePage extends StatefulWidget {
  @override
  _SharedRideCodePageState createState() => _SharedRideCodePageState();
}

class _SharedRideCodePageState extends State<SharedRideCodePage> {
  // In a prototype, you can generate a dummy referral code (or use a random string) on the fly.
  // (In a real app, you would receive a referral code from a backend.)
  String _referralCode =
      "TUNY" + (math.Random().nextInt(10000)).toString().padLeft(4, "0");
  int? _perPersonFare;
  int? _numberOfTravelers;
  String? _destination;
  DateTime? _desiredDateTime;
  bool _isJoined = false;
  int _joinedCount =
      0; // (In a prototype, you can simulate a "joined" counter.)

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // (You can extract arguments (e.g. perPersonFare, numberOfTravelers, destination, desiredDateTime) passed from ScheduleTeamRidePage.)
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _perPersonFare = args["perPersonFare"] as int?;
      _numberOfTravelers = args["numberOfTravelers"] as int?;
      _destination = args["destination"] as String?;
      _desiredDateTime = args["desiredDateTime"] as DateTime?;
      // (In a prototype, you can "insert" (or update) a dummy ride info in DummyData.scheduledRides (using _referralCode) so that OnboardScheduledRidePage "finds" it.)
      DummyData.scheduledRides[_referralCode] = {
        "joined": 0,
        "total": _numberOfTravelers,
        "destination": _destination,
        "desiredDateTime": _desiredDateTime
      };
    }
  }

  void _shareCode() {
    // In a prototype, simulate a share sheet (e.g. via a Snackbar).
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Share (simulated) – Referral Code: $_referralCode")));
  }

  void _toggleJoin() {
    setState(() {
      _isJoined = !_isJoined;
      if (_isJoined) {
        // (In a prototype, you can "update" the "joined" count (or a dummy counter) in DummyData.scheduledRides.)
        int joined =
            (DummyData.scheduledRides[_referralCode]?["joined"] ?? 0) + 1;
        DummyData.scheduledRides[_referralCode]?["joined"] = joined;
        _joinedCount = joined;
      } else {
        // (If "unjoined", you can decrement (or reset) the "joined" count.)
        int joined =
            (DummyData.scheduledRides[_referralCode]?["joined"] ?? 0) - 1;
        if (joined < 0) joined = 0;
        DummyData.scheduledRides[_referralCode]?["joined"] = joined;
        _joinedCount = joined;
      }
    });
  }

  void _proceedToPayment() {
    // (In a prototype, you can pass the perPersonFare (and other ride info) as arguments to PaymentPage.)
    Navigator.pushNamed(context, '/payment', arguments: {
      "fare": _perPersonFare,
      "referralCode": _referralCode,
      "destination": _destination,
      "desiredDateTime": _desiredDateTime
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.05),
              Colors.white,
              theme.primaryColor.withOpacity(0.02),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with logo and title
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.15),
                              blurRadius: 10.0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              'https://res.cloudinary.com/df3lhzzy7/image/upload/v1749768253/unnamed_p6zzod.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 25.0,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              theme.primaryColor,
                              theme.primaryColor.withOpacity(0.8),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            "Shared Ride Code",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.0),
                  // Code and fare display with enhanced styling
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.1),
                          blurRadius: 12.0,
                          offset: Offset(0, 6),
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Referral code section
                        Text(
                          "Referral Code",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24.0),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: theme.primaryColor.withOpacity(0.2),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            _referralCode,
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.w700,
                              color: theme.primaryColor,
                              letterSpacing: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 32.0),
                        // Fare section
                        Text(
                          "Per-Person Fare",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24.0),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: theme.primaryColor.withOpacity(0.2),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            "USh $_perPersonFare",
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.w700,
                              color: theme.primaryColor,
                              letterSpacing: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                  // Share button with gradient and shadow
                  Container(
                    height: 56.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28.0),
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.3),
                          blurRadius: 15.0,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _shareCode,
                      icon: Icon(Icons.share_rounded, color: Colors.white),
                      label: Text(
                        "Share Code",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  // Join toggle with enhanced styling
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.1),
                          blurRadius: 12.0,
                          offset: Offset(0, 6),
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: SwitchListTile(
                      title: Text(
                        "I Joined",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      value: _isJoined,
                      onChanged: (value) => _toggleJoin(),
                      activeColor: theme.primaryColor,
                      activeTrackColor: theme.primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
