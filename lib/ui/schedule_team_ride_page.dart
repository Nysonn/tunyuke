import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/dummy_data.dart';

class ScheduleTeamRidePage extends StatefulWidget {
  @override
  _ScheduleTeamRidePageState createState() => _ScheduleTeamRidePageState();
}

class _ScheduleTeamRidePageState extends State<ScheduleTeamRidePage> {
  final TextEditingController _numberOfTravelersController =
      TextEditingController();
  String? _selectedDestination;
  DateTime? _desiredDateTime;

  @override
  void initState() {
    super.initState();
    // (Optionally, you can set a default destination.)
    _selectedDestination = DummyData.pickupStations.first;
  }

  @override
  void dispose() {
    _numberOfTravelersController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_numberOfTravelersController.text.isEmpty ||
        _selectedDestination == null ||
        _desiredDateTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill in all fields.")));
      return;
    }
    int numberOfTravelers =
        int.tryParse(_numberOfTravelersController.text) ?? 0;
    if (numberOfTravelers <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Number of travelers must be positive.")));
      return;
    }
    // Compute the total fare (in USh) using DummyData.prices.
    int totalFare = DummyData.prices[_selectedDestination] ?? 0;
    // Compute the per-person fare (total fare ÷ number of travelers).
    int perPersonFare = (totalFare / numberOfTravelers).ceil();
    // (In a prototype, you can pass the computed per-person fare (and other ride info) as arguments to SharedRideCodePage.)
    Navigator.pushNamed(context, '/shared_ride_code', arguments: {
      "perPersonFare": perPersonFare,
      "numberOfTravelers": numberOfTravelers,
      "destination": _selectedDestination,
      "desiredDateTime": _desiredDateTime,
    });
  }

  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _desiredDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedule a Team Ride")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field for "Number of travelers"
            TextFormField(
              controller: _numberOfTravelersController,
              decoration: InputDecoration(labelText: "Number of travelers"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the number of travelers.";
                }
                int? number = int.tryParse(value);
                if (number == null || number <= 0) {
                  return "Number of travelers must be positive.";
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            // Dropdown for "Destination" (using DummyData.pickupStations)
            DropdownButtonFormField<String>(
              value: _selectedDestination,
              decoration: InputDecoration(labelText: "Destination"),
              items: DummyData.pickupStations.map((station) {
                return DropdownMenuItem(value: station, child: Text(station));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDestination = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            // DateTime picker button
            ElevatedButton.icon(
              onPressed: _selectDateTime,
              icon: Icon(Icons.calendar_today),
              label: Text(_desiredDateTime != null
                  ? DateFormat('MMM dd, yyyy - HH:mm').format(_desiredDateTime!)
                  : "Select Date & Time"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
              ),
            ),
            SizedBox(height: 24.0),
            // "Confirm" button (calls _confirm)
            ElevatedButton(
              onPressed: _confirm,
              child: Text("Confirm", style: TextStyle(fontSize: 18.0)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
