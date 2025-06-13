import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/dummy_data.dart';

class SharedRideDashboardPage extends StatefulWidget {
  const SharedRideDashboardPage({super.key});

  @override
  State<SharedRideDashboardPage> createState() => _SharedRideDashboardPageState();
}

class _SharedRideDashboardPageState extends State<SharedRideDashboardPage> {
  String? _referralCode;
  Map<String, dynamic>? _rideDetails;
  bool _hasPaid = false; // In a prototype, simulate payment status

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract referral code from arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _referralCode = args['referralCode'] as String?;
      if (_referralCode != null) {
        _rideDetails = DummyData.scheduledRides[_referralCode];
      }
    }
  }

  void _payNow() {
    // Navigate to payment page with fare and ride details
    if (_rideDetails != null) {
      // In a prototype, you can compute a dummy per-person fare
      const int perPersonFare = 2000; // Example fare
      Navigator.pushNamed(
        context,
        '/payment',
        arguments: {
          'fare': perPersonFare,
          'referralCode': _referralCode,
          'destination': _rideDetails!['destination'],
          'desiredDateTime': _rideDetails!['desiredDateTime'],
        },
      ).then((_) {
        // After returning from payment page, update payment status
        setState(() {
          _hasPaid = true;
        });
      });
    }
  }

  void _leaveRide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Ride'),
        content: const Text('Are you sure you want to leave this ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // In a prototype, simulate leaving the ride
              if (_referralCode != null && _rideDetails != null) {
                int joined = (_rideDetails!['joined'] ?? 1) - 1;
                if (joined < 0) joined = 0;
                DummyData.scheduledRides[_referralCode]?['joined'] = joined;
              }
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous page
            },
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_referralCode == null || _rideDetails == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shared Ride Dashboard')),
        body: const Center(child: Text('Ride details not found')),
      );
    }

    final destination = _rideDetails!['destination'] as String? ?? 'Unknown';
    final desiredDateTime = _rideDetails!['desiredDateTime'] as DateTime?;
    final joined = _rideDetails!['joined'] as int? ?? 0;
    final total = _rideDetails!['total'] as int? ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Ride Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _leaveRide,
            tooltip: 'Leave Ride',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Referral Code Card
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Referral Code',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _referralCode!,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Ride Details Card
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Destination', destination),
                    const SizedBox(height: 12.0),
                    _buildDetailRow(
                      'Date & Time',
                      desiredDateTime != null
                          ? DateFormat('MMM dd, yyyy • hh:mm a').format(desiredDateTime)
                          : 'Not set',
                    ),
                    const SizedBox(height: 12.0),
                    _buildDetailRow('Travelers', '$joined of $total joined'),
                    const SizedBox(height: 12.0),
                    _buildDetailRow(
                      'Payment Status',
                      _hasPaid ? 'Paid' : 'Unpaid',
                      valueColor: _hasPaid ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            // Pay Now button (shown only if not paid)
            if (!_hasPaid)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: _payNow,
                child: const Text('Pay Now', style: TextStyle(fontSize: 18.0)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
} 