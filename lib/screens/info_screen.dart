import 'package:flutter/material.dart';
import 'package:tripinsider/utils/colorsScheme.dart';

class InfoScreen extends StatelessWidget {
  final snap;
  const InfoScreen({
    super.key,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15), // Set the circular border radius
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: mobileBackgroundColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      snap['origin'],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mobileBackgroundColor),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_right_alt_sharp,
                    size: 30, color: Color.fromARGB(255, 59, 10, 89)),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: mobileBackgroundColor),
                    const SizedBox(width: 8),
                    Text(
                      snap['destination'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mobileBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Additional trip details
            buildTripDetail(Icons.hotel, snap['homeStay']),
            buildTripDetail(Icons.currency_rupee, snap['expd']),
            buildTripDetail(getIcon(snap['travelMode']), snap['travelMode']),
            buildTripDetail(Icons.rate_review, snap['description']),
          ],
        ),
      ),
    );
  }

  IconData getIcon(String title) {
    if (title == 'Plane') {
      return Icons.airplanemode_active;
    }
    if (title == 'Train') {
      return Icons.train;
    }
    if (title == 'Car') {
      return Icons.directions_car;
    }

    return Icons.directions_bus;
  }

  Widget buildTripDetail(IconData icon, String title) {
    return Card(
      elevation: 5,
      color: const Color.fromARGB(255, 208, 220, 253),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
