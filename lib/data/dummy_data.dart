// lib/data/dummy_data.dart – Dummy in-memory data for Tunyuke Campus Ride Delivery Prototype

import 'dart:collection';

class DummyData {
  // In-memory list of pickup stations (for dropdowns on ToCampus and FromCampus pages)
  static final List<String> pickupStations = ['Town', 'Rwebikona', 'Mile 3', 'Mile 4'];

  // In-memory list of ride times (morning and evening) (for radio/dropdowns on ride pages)
  static final List<String> rideTimes = ['Morning (7–8 am)', 'Evening (6–7 pm)'];

  // In-memory map of one-way prices (in USh) per pickup station (for computing fare on ride pages)
  static final Map<String, int> prices = {
    'Town': 2500,
    'Rwebikona': 2000,
    'Mile 3': 1500,
    'Mile 4': 1000,
  };

  // In-memory "be ready by" times (morning) (for info banners on ride pages)
  static final Map<String, String> morningReadyTimes = {
    'Town': '7:15 am',
    'Rwebikona': '7:20 am',
    'Mile 3': '7:25 am',
    'Mile 4': '7:30 am',
  };

  // In-memory "be ready by" time (evening) (for info banners on ride pages)
  static const String eveningReadyTime = '6:00 pm';

  // In-memory dummy store for scheduled rides (a map from referral code (String) to ride info (a Map<String, dynamic>))
  // (This simulates a backend store for scheduled rides.)
  static final Map<String, Map<String, dynamic>> scheduledRides = HashMap<String, Map<String, dynamic>>();

  // (You can add additional dummy data or helper methods as needed.)
} 