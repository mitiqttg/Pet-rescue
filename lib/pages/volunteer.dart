import 'package:flutter/material.dart';
import '../widgets/drawer.dart' as prefix;
import '../widgets/footer.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';
import '../pages/home.dart';
import '../widgets/appbar.dart';

class Breakpoints {
  static const sm = 640;
  static const md = 768;
  static const lg = 1024;
}

class VolunteerPage extends StatefulWidget {
  const VolunteerPage({super.key});

  @override
  State<VolunteerPage> createState() => _VolunteerPageState();
}

class _VolunteerPageState extends State<VolunteerPage> {
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
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
  //------------------------------------------------------------App bar
  @override
  Widget build(BuildContext context) {
    
    //--------------------------Body of Home----------------------------------
    Column bodyView() {
      return Column(
        children: [
          // Main content
          Expanded(
            child: 
          Container(
              color: const Color.fromARGB(255, 210, 216, 243),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Text('In developing', style: TextStyle(fontSize: 24),),
                    ],
                  )
                ]
              ),
            ),
          ),
          
          // Footer section
          const Footer(),
        ],
      );
    }

    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface, 
        appBar: CustomAppBar(
          onTitleTapped: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        drawer: const prefix.NavigationDrawer(location: 'Volunteer'),
        body: bodyView(),
      ),
    );
  }
}