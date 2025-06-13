import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class OnboardScheduledRidePage extends StatefulWidget {
  @override
  _OnboardScheduledRidePageState createState() => _OnboardScheduledRidePageState();
}

class _OnboardScheduledRidePageState extends State<OnboardScheduledRidePage> {
  final TextEditingController _referralCodeController = TextEditingController();

  @override
  void dispose() {
    _referralCodeController.dispose();
    super.dispose();
  }

  void _join() {
    if (_referralCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a referral code.")));
      return;
    }
    // In a prototype, simulate "joining" a scheduled ride (using DummyData.scheduledRides).
    // (For example, you can "insert" a dummy ride info (or update an existing one) in DummyData.scheduledRides.)
    // (In a real app, you would call a backend API.)
    String referralCode = _referralCodeController.text.trim();
    if (!DummyData.scheduledRides.containsKey(referralCode)) {
      // (For demo purposes, if the referral code is not "found" (i.e. not in DummyData.scheduledRides), you can "insert" a dummy ride info.)
      DummyData.scheduledRides[referralCode] = { "joined": 1, "total": 5, "destination": "Town", "desiredDateTime": DateTime.now().add(Duration(days: 1)) };
    } else {
      // (If the referral code is "found", you can "update" the joined count (or simulate "joining" by incrementing a counter).)
      int joined = (DummyData.scheduledRides[referralCode]?["joined"] ?? 0) + 1;
      DummyData.scheduledRides[referralCode]?["joined"] = joined;
    }
    // (For demo purposes, after "joining" you can navigate to SharedRideDashboardPage (passing the referral code as an argument).)
    Navigator.pushNamed(context, '/shared_ride_dashboard', arguments: { "referralCode": referralCode });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Onboard on a Scheduled Team Ride")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field for "Referral code"
            TextFormField(
              controller: _referralCodeController,
              decoration: InputDecoration(labelText: "Referral code"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a referral code.";
                }
                return null;
              },
            ),
            SizedBox(height: 24.0),
            // "Join" button (calls _join)
            ElevatedButton(
              onPressed: _join,
              child: Text("Join", style: TextStyle(fontSize: 18.0)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 