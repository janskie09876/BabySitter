import 'package:babysitter/notifications-stylepage/styles.dart';
import 'package:flutter/material.dart';

class StyleTestPage extends StatelessWidget {
  const StyleTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Style Test Page'),
        // Apply the custom AppBar theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Heading Style', style: AppStyles.headingStyle),
            const SizedBox(height: 16),
            const Text('Subheading Style', style: AppStyles.subheadingStyle),
            const SizedBox(height: 16),
            const Text('Body Style', style: AppStyles.bodyStyle),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  style: AppStyles.primaryButtonStyle,
                  child: const Text('Primary Button'),
                  onPressed: () {},
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: AppStyles.secondaryButtonStyle,
                  child: const Text('Secondary Button'),
                  onPressed: () {},
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: AppStyles.tertiaryButtonStyle,
                  child: const Text('Tertiary Button'),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),
            TextField(
              decoration: AppStyles.textFieldDecoration.copyWith(
                hintText: 'Input field',
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: AppStyles.cardDecoration,
              padding: const EdgeInsets.all(16),
              child: const Text('This is a card', style: AppStyles.bodyStyle),
            ),
            const SizedBox(height: 24),
            const Text('Color Palette', style: AppStyles.subheadingStyle),
            const SizedBox(height: 8),
            Row(
              children: [
                ColorBox(color: AppStyles.primaryColor, label: 'Primary'),
                SizedBox(width: 8),
                ColorBox(color: AppStyles.secondaryColor, label: 'Secondary'),
                SizedBox(width: 8),
                ColorBox(color: AppStyles.backgroundColor, label: 'Background'),
                SizedBox(width: 8),
                ColorBox(color: AppStyles.textColor, label: 'Text Color'),
                SizedBox(width: 8),
                ColorBox(color: AppStyles.whiteColor, label: 'White'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ColorBox extends StatelessWidget {
  final Color color;
  final String label;

  const ColorBox({Key? key, required this.color, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(label, style: AppStyles.bodyStyle.copyWith(fontSize: 12)),
      ],
    );
  }
}
