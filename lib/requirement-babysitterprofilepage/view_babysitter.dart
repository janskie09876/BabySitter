import 'package:babysitter/home-paymentpage/nannylist.dart'; // Import only nannylist.dart
import 'package:flutter/material.dart';
import 'package:babysitter/login-bookingrequestpage/book_now.dart'; // Keep this import for BookNow

class ViewBabysitter extends StatelessWidget {
  final Nanny? nanny; // Use the Nanny class from nannylist.dart

  const ViewBabysitter({Key? key, required this.nanny}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (nanny == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("No Nanny Selected")),
        body: const Center(child: Text("Nanny data is not available")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${nanny!.name}\'s Profile'),
        backgroundColor: const Color(0xFFE3838E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/liza.jpg'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nanny!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Baloo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < nanny!.rating.toInt()
                                ? Colors.amber
                                : Colors.grey.shade400,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: nanny!.isAvailable
                              ? Colors.green.shade100
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          nanny!.isAvailable ? 'Available' : 'Not Available',
                          style: TextStyle(
                            color:
                                nanny!.isAvailable ? Colors.green : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Baloo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Personal Information
            Text(
              'Personal Information:',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Baloo',
              ),
            ),
            const SizedBox(height: 8),
            Text('Age: ${nanny?.age}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),
            const SizedBox(height: 8),
            Text('Date of Birth: ${nanny?.birthDate}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),
            const SizedBox(height: 8),
            Text('Location: ${nanny?.location}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),
            const SizedBox(height: 8),
            Text('Phone Number: ${nanny?.phoneNumber}',
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),

            const SizedBox(height: 20),

            // Availability Section
            Text(
              'Availability:',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Baloo',
              ),
            ),
            const SizedBox(height: 8),
            Text(nanny!.availability,
                style: const TextStyle(fontFamily: 'Baloo', fontSize: 16)),

            const SizedBox(height: 20),

            // Action Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement the booking or contact functionality here
                    print("Contact ${nanny?.name}");
                  },
                  child: const Text('Contact Nanny'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to BookNow and pass the nanny data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookNow(
                            nanny:
                                nanny), // This will work now because it's the same Nanny class
                      ),
                    );
                  },
                  child: const Text('Book Babysitter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE3838E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
