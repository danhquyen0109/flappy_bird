import 'package:galaxy_bird/themes/colors.dart';
import 'package:flutter/material.dart';

class PrivacyWidget extends StatelessWidget {
  const PrivacyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 300,
      color: Colors.white,
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // const Text(
            //   'Privacy Policy',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: DSColors.woodSmoke,
            //   ),
            // ),
            // const SizedBox(height: 16),
            Text(
              'We value your privacy. This Privacy Policy explains how we collect, use, and protect your personal data when you use our mobile application.',
              style: TextStyle(fontSize: 14, color: DSColors.woodSmoke),
            ),
            const SizedBox(height: 16),
            _buildSection('1. Information We Collect', [
              'We may collect the following types of data:',
              '• Non-personal information such as device type, game progress, and gameplay data.',
              '• We do not collect personally identifiable information such as name, email, or phone number unless explicitly provided by you.',
            ]),
            _buildSection('2. Children\'s Privacy', [
              'This app is not intended for children under the age of 13. We do not knowingly collect data from children under 13.',
            ]),
            _buildSection('3. Data Security', [
              'We take reasonable measures to protect your data from unauthorized access.',
            ]),
            _buildSection('4. Changes to This Policy', [
              'We may update this Privacy Policy from time to time. You are advised to review this page periodically for any changes.',
            ]),
            _buildSection('5. Contact Us', [
              'If you have any questions or suggestions, contact us at:',
              '📧 galaxy.dev99@gmail.com',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> contents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: DSColors.woodSmoke,
          ),
        ),
        const SizedBox(height: 8),
        ...contents.map(
          (content) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, color: DSColors.woodSmoke),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
