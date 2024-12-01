import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:flutter/material.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  TimeOfDay startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 17, minute: 0);
  bool isDaily = true;
  List<bool> selectedDays = [true, true, true, true, true, false, false];

  Future<void> selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: AppStyles.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppStyles.textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Availability",
                  style: AppStyles.headingStyle.copyWith(
                    color: AppStyles.secondaryColor,
                  ),
                  textAlign: TextAlign.center, // Centering the text
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: AppStyles.defaultPadding,
              decoration: AppStyles
                  .cardDecoration, // Using card decoration from AppStyles
              child: Column(
                children: [
                  Text(
                    "Set your time",
                    style: AppStyles
                        .subheadingStyle, // Using subheading style from AppStyles
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Pick a time of the day, when you would like to be babysitting.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => selectTime(context, true),
                        child: Text(
                          startTime.format(context),
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text("  →  ", style: TextStyle(fontSize: 24)),
                      GestureDetector(
                        onTap: () => selectTime(context, false),
                        child: Text(
                          endTime.format(context),
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text("Set Time", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 24),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(7, (index) {
                      String day = ["M", "T", "W", "T", "F", "S", "S"][index];
                      bool isSelected = selectedDays[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDays[index] = !selectedDays[index];
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppStyles.secondaryColor
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            day,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Daily schedule", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: AppStyles.primaryButtonStyle.copyWith(
                minimumSize: WidgetStateProperty.all(Size(double.infinity, 50)),
              ),
              child: Text("Save", style: AppStyles.buttonTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
