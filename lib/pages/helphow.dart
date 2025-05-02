import 'package:flutter/material.dart';
import '../widgets/drawer.dart' as prefix;
import '../widgets/footer.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';
import '../pages/home.dart';
import '../widgets/appbar.dart';

// Import your form pages (adjust paths and class names if necessary)
import './donation.dart'; // Assuming DonationFormPage class
import './volunteer.dart';   // Assuming VolunteerPage class

class Breakpoints {
  static const sm = 640;
  static const md = 768;
  static const lg = 1024;
  static const xl = 1280;
  static const xl2 = 1536;
}

class HowToHelpPage extends StatefulWidget {
  const HowToHelpPage({super.key});

  @override
  State<HowToHelpPage> createState() => _HowToHelpPageState();
}

class _HowToHelpPageState extends State<HowToHelpPage> {
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to access ThemeProvider safely in initState if needed
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   isSwitched = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    // });
    // Or get initial theme state differently if required before build
  }

  //------------------------------------------------------------Search box
  Container _searchField() {
    double appBarHeight = AppBar().preferredSize.height;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: appBarHeight / 2,
      width: appBarHeight * 4 ,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 10.0),
            ),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          // Replace with actual search suggestions logic if needed
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                // Handle suggestion tap
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          });
        },
      ),
    );
  }

  //--------------------------Body of Home----------------------------------
  Column bodyView() {
    // Get screen width for responsive design
    final double screenWidth = MediaQuery.of(context).size.width;

    // Determine container sizes based on breakpoints
    double containerWidth = 150;
    double containerHeight = 200;
    bool isRowLayout = screenWidth >= Breakpoints.md;

    if (screenWidth >= Breakpoints.lg) {
      containerWidth = 200;
      containerHeight = 250;
    } else if (screenWidth >= Breakpoints.sm) {
      containerWidth = 180;
      containerHeight = 220;
    }

    // --- MODIFIED: Base container widget now includes onTap ---
    // Added width, height, and onTap parameters
    Widget helpContainer({
      required String title,
      required String imageUrl,
      required VoidCallback onTap, // Action to perform on tap
      required double width,
      required double height,
    }) {
      return InkWell( // Use InkWell for tap feedback
        onTap: onTap, // Assign the navigation action
        borderRadius: BorderRadius.circular(15), // Match container radius for ripple effect
        child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              // Add error handling for network images
              onError: (exception, stackTrace) {
                 // Optionally show a placeholder or log error
                 print('Error loading image: $imageUrl, $exception');
              },
            ),
             boxShadow: [ // Optional: Add subtle shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    // --- REFACTORED: Create widgets once ---
    Widget donationWidget = helpContainer(
      title: 'Donation',
      imageUrl: 'https://images.unsplash.com/photo-1453227588063-f5e0592c7b07', // Consider local assets
      width: containerWidth,
      height: containerHeight,
      onTap: () {
        // Navigate to Donation Form Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DonationPage()),
        );
        print('Navigating to Donation Form...'); // For debugging
      },
    );

    Widget volunteerWidget = helpContainer(
      title: 'Volunteer',
      imageUrl: 'https://images.unsplash.com/photo-1529390079861-0dd7152e5e9e', // Consider local assets
      width: containerWidth,
      height: containerHeight,
      onTap: () {
        // Navigate to Volunteer Form Page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VolunteerPage()),
        );
         print('Navigating to Volunteer Form...'); // For debugging
      },
    );


    return Column(
      children: [
        Expanded(
          child: Container(
            // Consider using Theme.of(context).colorScheme.surfaceVariant or similar
            color: Theme.of(context).brightness == Brightness.light
                   ? const Color.fromARGB(255, 210, 216, 243)
                   : Theme.of(context).colorScheme.surfaceVariant, // Example dark mode color
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // --- REFACTORED: Use pre-built widgets ---
                  // Responsive container layout
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add padding around row/column
                    child: isRowLayout
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              donationWidget, // Use the created widget
                              volunteerWidget, // Use the created widget
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              donationWidget, // Use the created widget
                              volunteerWidget, // Use the created widget
                            ],
                          ),
                   ),
                  const SizedBox(height: 20),
                  // Descriptions
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth >= Breakpoints.lg ? 40 : 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Donation',
                          // Use Theme.of(context).textTheme styles
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your donations help us provide essential resources, medical care, and shelter for pets in need. Every contribution makes a difference in improving their lives.',
                          style: TextStyle(
                            fontSize: screenWidth >= Breakpoints.lg ? 16 : 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Volunteer',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Join our team of dedicated volunteers to assist with pet care, event organization, and community outreach. Your time and skills can create lasting impact.',
                          style: TextStyle(
                            fontSize: screenWidth >= Breakpoints.lg ? 16 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        const Footer(), // Ensure Footer is styled appropriately for themes
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get theme provider state *once* in build method if needed for AppBar logic
    // Note: ThemeProvider access might be better inside CustomAppBar if possible
     final themeProvider = Provider.of<ThemeProvider>(context);
     // Use themeProvider.isDarkMode or similar for conditional logic if needed

    // Removed the local AppBar definition as CustomAppBar is used
    // AppBar appBar() { ... }

    return MaterialApp( // Consider removing MaterialApp if this page is part of a larger app with its own MaterialApp
      // If this is not the root widget, you probably don't need another MaterialApp here.
      // Instead, just return the Scaffold.
      theme: themeProvider.themeData, // Use theme from provider
      debugShowCheckedModeBanner: false, // Optional: hide debug banner
      home: Scaffold(
        // Use theme colors
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar( // Using your custom AppBar
          onTitleTapped: () {
             // Navigate to Home Page (replace if needed)
             // Using pushReplacement might be better if you don't want HowToHelp on the stack
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
           },
           // Pass theme state or toggle function to CustomAppBar if it needs it
           // e.g., isDarkMode: themeProvider.isDarkMode, onThemeToggle: () => themeProvider.toggleTheme()
         ),
        drawer: const prefix.NavigationDrawer(location: 'How to help'),
        body: bodyView(),
      ),
    );
  }
}