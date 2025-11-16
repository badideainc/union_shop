import 'package:flutter/material.dart';
import 'package:union_shop/main.dart ';

class PrintAboutPage extends StatelessWidget {
  const PrintAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Container(
        height: 100,
        color: Colors.white,
        child: const Column(children: [
          // Top banner
          TopBanner(),
          // Main header

          NavBar(),
        ]),
      ),
      const Text(
        "The Union Print Shack",
        style: TextStyle(fontSize: 36, color: Colors.black),
      ),
      const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            """Make It Yours at The Union Print Shack
Want to add a personal touch? We’ve got you covered with heat-pressed customisation on all our clothing. Swing by the shop - our team’s always happy to help you pick the right gear and answer any questions.

Uni Gear or Your Gear - We’ll Personalise It
Whether you’re repping your university or putting your own spin on a hoodie you already own, we’ve got you covered. We can personalise official uni-branded clothing and your own items - just bring them in and let’s get creative!

Simple Pricing, No Surprises
Customising your gear won’t break the bank - just £3 for one line of text or a small chest logo, and £5 for two lines or a large back logo. Turnaround time is up to three working days, and we’ll let you know as soon as it’s ready to collect.

Personalisation Terms & Conditions
We will print your clothing exactly as you have provided it to us, whether online or in person. We are not responsible for any spelling errors. Please ensure your chosen text is clearly displayed in either capitals or lowercase. Refunds are not provided for any personalised items.

Ready to Make It Yours?
Pop in or get in touch today - let’s create something uniquely you with our personalisation service - The Union Print Shack!""",
            style: FooterText(16),
          )),
      const Footer(),
    ])));
  }
}
