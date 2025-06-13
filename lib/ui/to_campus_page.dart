import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class ToCampusPage extends StatefulWidget {
  @override
  _ToCampusPageState createState() => _ToCampusPageState();
}

class _ToCampusPageState extends State<ToCampusPage> {
  String? _selectedPickupStation;
  String? _selectedRideTime;

  @override
  void initState() {
    super.initState();
    // (Optionally, you can set a default pickup station and ride time.)
    _selectedPickupStation = DummyData.pickupStations.first;
    _selectedRideTime = DummyData.rideTimes.first;
  }

  void _confirm() {
    if (_selectedPickupStation == null || _selectedRideTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please select a pickup station and ride time.")));
      return;
    }
    // Compute the fare (in USh) using DummyData.prices.
    int fare = DummyData.prices[_selectedPickupStation] ?? 0;
    // (In a prototype, you can pass the computed fare (and other ride info) as arguments to PaymentPage.)
    Navigator.pushNamed(context, '/payment', arguments: {
      "fare": fare,
      "pickup": _selectedPickupStation,
      "rideTime": _selectedRideTime
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
                            "To Kihumuro Campus",
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
                  // Form fields with enhanced styling
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
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Pickup station dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedPickupStation,
                          decoration: InputDecoration(
                            labelText: "Select Pickup Station",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                          items: DummyData.pickupStations.map((station) {
                            return DropdownMenuItem(
                              value: station,
                              child: Text(
                                station,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[800],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPickupStation = value;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        // Ride time dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedRideTime,
                          decoration: InputDecoration(
                            labelText: "What time are you leaving?",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            prefixIcon: Icon(Icons.access_time_outlined),
                          ),
                          items: DummyData.rideTimes.map((time) {
                            return DropdownMenuItem(
                              value: time,
                              child: Text(
                                time,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[800],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRideTime = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.0),
                  // Info banner with enhanced styling
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.amber[200]!,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.amber[700],
                          size: 24.0,
                        ),
                        SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            _selectedRideTime?.startsWith("Morning") ?? false
                                ? "Be ready by ${DummyData.morningReadyTimes[_selectedPickupStation ?? ""] ?? "7:00 am"}"
                                : "Be ready by 6:00 pm",
                            style: TextStyle(
                              color: Colors.amber[900],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                  // Confirm button with gradient and shadow
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
                    child: ElevatedButton(
                      onPressed: _confirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                      ),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
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
