import 'package:flutter/material.dart';
import '../pages/home.dart';
import '../pages/rescue.dart';
import '../pages/donation.dart';
import '../pages/volunteer.dart';
import '../pages/helphow.dart' as how;

class NavigationDrawer extends StatefulWidget {
  final String location;
  const NavigationDrawer({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  void initState() {
    super.initState();}
  @override
  Widget build(BuildContext context) {
  return Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Center(child: Text(widget.location)),
      ),
      
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text('Home', style: TextStyle(fontSize: 16)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()))
      ),
      
      ListTile(
        leading: const Icon(Icons.pets),
        title: const Text('Rescue', style: TextStyle(fontSize: 16)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RescuePage())),
      ),

      ListTile(
        leading: const Icon(Icons.arrow_circle_right),
        title: const Text('Rehome', style: TextStyle(fontSize: 16)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RescuePage())),
      ),
      
      ListTile(
        leading: const Icon(Icons.handshake, size: 20),
        title: Text('How you can help'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const how.HowToHelpPage()))
      ),

      ListTile(
        leading: const Icon(Icons.handshake, size: 20),
        title: const Text('Donation', style: TextStyle(fontSize: 14)),
        contentPadding: const EdgeInsets.only(left: 40),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DonationPage())),
      ),
      
      ListTile(
        leading: const Icon(Icons.people_alt, size: 20),
        title: const Text('Volunteering', style: TextStyle(fontSize: 14)),
        contentPadding: const EdgeInsets.only(left: 40),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VolunteerPage())),
      ),
      
    ],
  ),
);
  }
}