import 'package:flutter/material.dart';
import '../widgets/drawer.dart' as prefix;
import '../widgets/footer.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/appbar.dart';

class Breakpoints {
  static const sm = 640;
  static const md = 768;
  static const lg = 1024;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
  }

  //--------------------------------Search box------------
  Container _searchField() {
    double appBarHeight = AppBar().preferredSize.height;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: appBarHeight / 2,
      width: appBarHeight * 4,
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
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {},
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    //--------------------------Body of Home----------------------------------

    final List<String> petImages = [
      'lib/assets/stray-dog-1.jpg',
      'lib/assets/stray-dog-2.jpg',
      'lib/assets/stray-cat-1.jpg',
      'lib/assets/stray-cat-2.jpg',
      // Add more image paths as needed
    ];

    Widget _bodyView(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                // Full-screen image
                Image.asset(
                  'lib/assets/mainpage-hug.jpg',
                  width: double.infinity,
                  height: screenHeight,
                  fit: BoxFit.cover,
                ),
                // Left-side description and button
                Positioned(
                  left: 16.0,
                  top: screenHeight * 0.6 / 2 - 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Let's take part in helping our friends",
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 84, 196, 230)
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          print("About us button pressed");
                        },
                        child: const Text(
                        "About us",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 152, 222, 243),
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  Text(
                    "Providing abandoned pets with the opportunity for a new life and securing homes are our mission. We also shelter pets that owners have giving. This has brought us significant joy, love, and a sense of purpose through our commitment to caring for homeless animals.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                  ),
                  const SizedBox(height: 24.0),
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                    ),
                    items: petImages.map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      );
    }

    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: CustomAppBar(),
        drawer: const prefix.NavigationDrawer(location: 'Home'),
        body: _bodyView(context),
      ),
    );
  }
}