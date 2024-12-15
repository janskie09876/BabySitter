import 'package:babysitter/home-paymentpage/nannylist.dart';
import 'package:flutter/material.dart';

// Define a custom color palette
class AppColors {
  static const Color primaryColor = Color(0xFFC47F42); // Orange
  static const Color lightBackground = Color(0xFFF5F5F5); // Light background
  static const Color darkBackground = Color(0xFF1E1E1E); // Dark background
  static const Color beige = Color(0xFFE3C3A3); // Beige
  static const Color coffeeBrown = Color(0xFF51331A); // Coffee Brown
  static const Color lightCoffeeBrown = Color(0xFF7B5B42); // Light Coffee Brown
  static const Color blackColor = Color(0xFF000000); // Black
  static const Color grayColor = Color(0xFF7D7D7D); // Gray
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color warningColor = Color(0xFFFBC02D); // Yellow
  static const Color whiteColor = Color(0xFFFFFFFF); // White
  static const Color redColor = Color(0xFFFF0000); // Red
}

class NannyCard extends StatelessWidget {
  final Nanny nanny;
  final VoidCallback onTap;

  const NannyCard({required this.nanny, required this.onTap});

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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.coffeeBrown, // Updated color
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: nanny.isAvailable
                                    ? AppColors.successColor.withOpacity(0.1)
                                    : AppColors.grayColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                nanny.isAvailable
                                    ? 'Available'
                                    : 'Not Available',
                                style: TextStyle(
                                  color: nanny.isAvailable
                                      ? AppColors.successColor
                                      : AppColors.grayColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
                              color: index < nanny.rating.toInt()
                                  ? AppColors.primaryColor
                                  : AppColors.grayColor,
                              size: 20,
                            ),
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
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppColors.coffeeBrown, // Updated color
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                nanny.birthDate ?? 'Not Available',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.coffeeBrown, // Updated color
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.coffeeBrown, // Updated color
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                nanny.location,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.coffeeBrown, // Updated color
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 16,
                              color: AppColors.coffeeBrown, // Updated color
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                nanny.phoneNumber ?? 'Not Available',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.coffeeBrown, // Updated color
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
                          Text(
                            'Age: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.coffeeBrown, // Updated color
                            ),
                          ),
                          Text(
                            '${nanny.age}',
                            style: TextStyle(
                              color: AppColors.coffeeBrown, // Updated color
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gender: Female', // Static gender value, change as needed
                        style: TextStyle(
                          color: AppColors.coffeeBrown, // Updated color
                        ),
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
                        color: AppColors.primaryColor, // Updated color
                        fontWeight: FontWeight.bold,
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
