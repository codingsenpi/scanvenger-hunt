import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:url_launcher/url_launcher.dart';

class RulesView extends StatefulWidget {
  const RulesView({Key? key}) : super(key: key);
  @override
  _RulesViewState createState() => _RulesViewState();
}

class _RulesViewState extends State<RulesView> {
  late final LiquidController liquidController;
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    liquidController = LiquidController();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageColors = <Color>[
      const Color(0xFFffc8dd),
      const Color.fromARGB(255, 239, 211, 255),
      const Color(0xFFffafcc),
      const Color(0xFFbde0fe),
      const Color(0xFFa2d2ff),
    ];
    final titleStyle = Get.textTheme.displaySmall
        ?.copyWith(color: Colors.black87, fontWeight: FontWeight.bold);
    final bodyStyle =
        Get.textTheme.titleLarge?.copyWith(color: Colors.black54, height: 1.5);
    final boldBodyStyle =
        bodyStyle?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87);
    final linkStyle = bodyStyle?.copyWith(
        color: Colors.blue.shade800, decoration: TextDecoration.underline);
    final pagesContent = [
      {
        'title': 'Objective',
        'children': <Widget>[
          Text(
              'Win by being the first team to crack every mystery OR by solving the most mysteries before the 3-hour clock runs out.',
              textAlign: TextAlign.center,
              style: bodyStyle),
          SizedBox(height: Get.height * 0.1),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(Icons.swipe_left_outlined, color: Colors.black38),
              SizedBox(width: 8),
              Text('(Swipe to continue)',
                  style: TextStyle(color: Colors.black38, fontSize: 16)),
            ],
          )
        ],
      },
      {
        'title': 'Gameplay',
        'children': <Widget>[
          Text('• The entire game is played through this app.',
              style: bodyStyle),
          Text(
              '• Each challenge is a Mystery - a riddle paired with a distorted image.',
              style: bodyStyle),
          Text(
              '• The riddle leads you to a location. Capture it with a photo and submit.',
              style: bodyStyle),
          Text(
              '• Once correct, the distorted image points to something nearby.',
              style: bodyStyle),
          Text(
              '• Submit that as well to complete the Mystery and move on to the next one.',
              style: bodyStyle),
        ],
      },
      {
        'title': 'Submissions',
        'children': <Widget>[
          Text('• All submissions are made by taking a photo through the app.',
              style: bodyStyle),
          Text(
              '• After submitting, the result (Approved/Rejected) appears on a dedicated screen.',
              style: bodyStyle),
        ],
      },
      {
        'title': 'Get a Bypass!',
        'children': // This is the 'children' list for the 4th page (_buildPage) in your RulesView
            // This is the 'children' list for the 4th page (_buildPage) in your RulesView
            <Widget>[
          Text('SKIP Option:', style: boldBodyStyle),
          Text('• For Riddles: We will reveal the location name.',
              style: bodyStyle),
          Text(
              '• For Distorted Images: The stage will be automatically cleared.',
              style: bodyStyle),
          const SizedBox(height: 24),
          Text('How to Earn a SKIP:', style: boldBodyStyle),
          RichText(
            text: TextSpan(
              style: bodyStyle,
              children: <TextSpan>[
                const TextSpan(text: '1. Gain new followers for the '),
                TextSpan(
                  text: '@tgcc_iiitkota',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        _launchURL('https://www.instagram.com/tgcc_iiitkota/'),
                ),
                const TextSpan(text: ' Instagram account.'),
              ],
            ),
          ),
          Text('2. Verify them via the verification website to get a QR code.',
              style: bodyStyle),
          Text(
              '3. Upload the QR code and screenshots to the Telegram community.',
              style: bodyStyle),
          const SizedBox(height: 24),
          Text('SKIP Requirements:', style: boldBodyStyle),
          Text('• 1st SKIP: 10 new followers.', style: bodyStyle),
          Text('• 2nd SKIP onward: 5 followers per SKIP.', style: bodyStyle),
          Text('• Maximum of 5 SKIPS per team.', style: bodyStyle),
          Text('• No more than 2 consecutive SKIPS can be used.',
              style: bodyStyle),
          const SizedBox(height: 32),

          // --- NEW, CORRECTED THREE-BUTTON LAYOUT ---

          // First row with two buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1306C), // Instagram Pink
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () =>
                      _launchURL('https://www.instagram.com/tgcc_iiitkota/'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.instagram, size: 20),
                      SizedBox(width: 12),
                      Text('TGCC'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _launchURL('https://verify.codingsenpi.me'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner, size: 20),
                      SizedBox(width: 12),
                      Text('VERIFY IDs'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Second row with one big button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2AABEE), // Telegram Blue
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _launchURL('https://t.me/+I8VhkeqOC2FkMmRl'),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.telegram, size: 22),
                SizedBox(width: 12),
                Text('SEND PROOF',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      },
      {
        'title': 'Fair Play',
        'children': <Widget>[
          Text(
              '• The play area is the entire campus, excluding the interiors of Hostel buildings, with the exception of certain common-access areas.',
              style: bodyStyle),
          Text(
              '• The images were captured a while back, so details may not be exact. Focus on the main subject and overall context.',
              style: bodyStyle),
          Text('• All team members must stay together.', style: bodyStyle),
          Text('• Do not interfere with other teams. Play with integrity!',
              style: boldBodyStyle),
        ],
      },
    ];

    // final pagesContent = [
    //   {
    //     'title': 'Objective',
    //     'children': <Widget>[
    //       Text(
    //           'Be the first team to solve all mysteries, or solve the most mysteries within the 3-hour time limit.',
    //           textAlign: TextAlign.center,
    //           style: bodyStyle),
    //       SizedBox(height: Get.height * 0.1),
    //       const Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           FaIcon(Icons.swipe_left_outlined, color: Colors.black38),
    //           SizedBox(width: 8),
    //           Text('(Swipe to continue)',
    //               style: TextStyle(color: Colors.black38, fontSize: 16)),
    //         ],
    //       )
    //     ],
    //   },
    //   {
    //     'title': 'Gameplay',
    //     'children': <Widget>[
    //       Text('• The entire game is played through this app.',
    //           style: bodyStyle),
    //       Text('• Clues are a mix of riddles and "glitched" image challenges.',
    //           style: bodyStyle),
    //       Text(
    //           '• Your team will receive a unique, randomized order of mysteries.',
    //           style: bodyStyle),
    //     ],
    //   },
    //   {
    //     'title': 'Submissions',
    //     'children': <Widget>[
    //       Text('• All submissions are made by taking a photo through the app.',
    //           style: bodyStyle),
    //       Text(
    //           '• After submitting, you will see the result (Approved/Rejected) on a dedicated screen.',
    //           style: bodyStyle),
    //     ],
    //   },
    //   {
    //     'title': 'Get a Bypass!',
    //     'children': <Widget>[
    //       Text('Tier 1: Skip a Step (12 Followers)', style: boldBodyStyle),
    //       Text('• Skips just the current part.', style: bodyStyle),
    //       const SizedBox(height: 16),
    //       Text('Tier 2: Skip an Entire Mystery (20 Followers)',
    //           style: boldBodyStyle),
    //       Text('• Skips both parts of the current mystery.', style: bodyStyle),
    //       const SizedBox(height: 24),
    //       Text('How to Redeem:', style: boldBodyStyle),
    //       Text('1. Get the required new followers.', style: bodyStyle),
    //       Text('2. Use one of the links below to submit proof.',
    //           style: bodyStyle),
    //       const Divider(color: Colors.black26, thickness: 2),
    //       const SizedBox(height: 8),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           Expanded(
    //             child: InkWell(
    //               onTap: () =>
    //                   _launchURL('https://www.instagram.com/tgcc_iiitkota/'),
    //               child: const Column(
    //                 children: [
    //                   FaIcon(FontAwesomeIcons.instagram,
    //                       color: Colors.black54, size: 30),
    //                   SizedBox(height: 8),
    //                   Text('Open Page',
    //                       style: TextStyle(color: Colors.black54)),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //               height: 50,
    //               child: VerticalDivider(color: Colors.black26, thickness: 2)),
    //           Expanded(
    //             child: InkWell(
    //               onTap: () => _launchURL('https://t.me/your_telegram_group'),
    //               child: const Column(
    //                 children: [
    //                   FaIcon(FontAwesomeIcons.telegram,
    //                       color: Colors.black54, size: 30),
    //                   SizedBox(height: 8),
    //                   Text('Send Proof',
    //                       style: TextStyle(color: Colors.black54)),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   },
    //   {
    //     'title': 'Fair Play',
    //     'children': <Widget>[
    //       Text(
    //           '• The play area is the entire campus, EXCLUDING the interior of all Hostel buildings and the Academic Block.',
    //           style: bodyStyle),
    //       Text('• All team members must stay together.', style: bodyStyle),
    //       Text('• Do not interfere with other teams. Play with integrity!',
    //           style: boldBodyStyle),
    //     ],
    //   },
    // ];
    final pages = List.generate(
      pagesContent.length,
      (index) => _buildPage(
        color: pageColors[index],
        title: pagesContent[index]['title'] as String,
        style: titleStyle,
        children: pagesContent[index]['children'] as List<Widget>,
        pageNumber: index + 1,
        totalPages: pagesContent.length,
      ),
    );
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: pages,
            liquidController: liquidController,
            onPageChangeCallback: (page) => setState(() => currentPage = page),
            enableLoop: false,
            fullTransitionValue: 600,
            waveType: WaveType.liquidReveal,
            enableSideReveal: false,
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
                icon: Icon(
                  FeatherIcons.arrowLeft,
                  size: 32,
                ),
                onPressed: () {
                  Get.back();
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required Color color,
    required String title,
    required TextStyle? style,
    required List<Widget> children,
    required int pageNumber,
    required int totalPages,
  }) {
    return Container(
      color: color,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 75),
            Row(
              children: [
                Text(title, style: style),
                const Spacer(),
                Text(
                  '$pageNumber/$totalPages',
                  style:
                      Get.textTheme.titleLarge?.copyWith(color: Colors.black38),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children
                      .map((child) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: child,
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
