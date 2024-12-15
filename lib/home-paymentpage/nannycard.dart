import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:babysitter/home-paymentpage/nannylist.dart';

class NannyCard extends StatelessWidget {
  final Nanny nanny;
  final VoidCallback onTap;

  const NannyCard({required this.nanny, required this.onTap});

  int _calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  DateTime _parseBirthDate(String birthDate) {
    try {
      // Parse with the expected format "MMMM dd, yyyy"
      final dateFormat = DateFormat('MMMM dd, yyyy');
      return dateFormat.parse(birthDate);
    } catch (e) {
      print('Error parsing birthDate: $e');
      return DateTime(1900, 1, 1); // Default fallback date
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row with Avatar and Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar can be dynamic, here we use a static image for now
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/liza.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                nanny.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Baloo',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: nanny.isAvailable
                                    ? Colors.green.shade100
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                nanny.isAvailable
                                    ? 'Available'
                                    : 'Not Available',
                                style: TextStyle(
                                  color: nanny.isAvailable
                                      ? Colors.green
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Baloo',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              color: index < nanny.rating.floor()
                                  ? Colors.amber
                                  : Colors.grey.shade400,
                              size: 20,
                            ),
                          ),
                        ),
                        if (nanny.ratingCount > 0)
                          Text(
                            '${nanny.ratingCount} reviews',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontFamily: 'Baloo',
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Details Section (Birth Date, Location, Phone)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Color(0xFFE3838E),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                nanny.birthdate ?? 'Not Available',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Baloo',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Color(0xFFE3838E),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                nanny.address,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Baloo',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: Color(0xFFE3838E),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                nanny.phoneNumber ?? 'Not Available',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Baloo',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Right Column (Age and Gender)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Age: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Baloo',
                            ),
                          ),
                          Text(
                            nanny.birthdate != null &&
                                    nanny.birthdate!.isNotEmpty
                                ? '${_calculateAge(_parseBirthDate(nanny.birthdate!))}' // Parse and calculate age
                                : 'Unknown', // Handle null or empty birthDate
                            style: const TextStyle(fontFamily: 'Baloo'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        nanny.gender, // Static gender value, change as needed
                        style: const TextStyle(fontFamily: 'Baloo'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${nanny.service} per hour', // Added "per hour" text after nanny service
                        style: const TextStyle(fontFamily: 'Baloo'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // More Info Button Section
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onTap,
                    child: const Text(
                      'More Information',
                      style: TextStyle(
                        color: Color(0xFFE3838E),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Baloo',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
