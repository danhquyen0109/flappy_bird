import 'package:galaxy_bird/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyWidget extends StatelessWidget {
  const PrivacyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: ListView(
        shrinkWrap: true,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "This app is aimed at people over 12 years old.\n",
                  style: TextStyle(
                    fontSize: 16,
                    color: DSColors.woodSmoke,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                WidgetSpan(
                  child: TextButton(
                    onPressed: () => _launchUrl(
                        'https://sites.google.com/view/flappybirdprivacypolicy'),
                    child: Text(
                      'View all our privacy policy',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                TextSpan(
                  text: "\nWe do not collect any information from you.",
                  style: TextStyle(
                    fontSize: 16,
                    color: DSColors.woodSmoke,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text:
                      "\nWe are committed to the content and functionality of the application is completely suitable for everyone.",
                  style: TextStyle(
                    fontSize: 16,
                    color: DSColors.woodSmoke,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                WidgetSpan(
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    children: [
                      Text(
                        '\nIn matters related to this notice, you can reach us by email:',
                        style: TextStyle(
                          fontSize: 15,
                          color: DSColors.woodSmoke,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'nht.studio.vn@gmail.com.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          // fontFamily: 'DiloWorld',
                        ),
                      )
                    ],
                  ),
                ),
                WidgetSpan(
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    children: [
                      Text(
                        '\nThis app includes adverts.',
                        style: TextStyle(
                          fontSize: 16,
                          color: DSColors.woodSmoke,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\nWe provide our partners with some information about the way you use our app so they can advertise products and services that are more likely to be relevant to you.'
                        '\nAd networks are companies that manage the advertising process on this and many other apps. For that reason, they may know information about you based on the way you use all the apps where they provide advertising services. They compile this information to paint a picture of which types of adverts you are likely to be interested in.'
                        '\nYou can find out more about how they use your personal information here:',
                        style: TextStyle(
                          fontSize: 15,
                          color: DSColors.woodSmoke,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                WidgetSpan(
                  child: TextButton(
                    onPressed: () => _launchUrl(
                        'https://policies.google.com/privacy?hl=en&gl=uk'),
                    child: Text(
                      '\nAdMob',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        // fontFamily: 'DiloWorld',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }
}
