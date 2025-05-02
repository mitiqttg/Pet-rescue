import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTitleTapped;

  const CustomAppBar({super.key, this.onTitleTapped});

  Widget _buildSearchField(BuildContext context) {
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
            onTap: () => controller.openView(),
            onChanged: (_) => controller.openView(),
            leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder: (context, controller) => List.generate(
          5,
          (index) => ListTile(
            title: Text('item $index'),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AppBar(
      title: GestureDetector(
        onTap: onTitleTapped,
        child: const Text(
          'Petlastaa',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      elevation: 10.0,
      centerTitle: true,
      actions: [
        _buildSearchField(context),
        Switch(
          thumbIcon: WidgetStateProperty.all(
            themeProvider.isDarkMode
                ? const Icon(Icons.nightlight_round)
                : const Icon(Icons.wb_sunny),
          ),
          focusColor: const Color.fromARGB(255, 175, 214, 238),
          activeColor: const Color.fromARGB(255, 68, 172, 241),
          value: themeProvider.isDarkMode,
          onChanged: (value) => themeProvider.toggleTheme(),
        ),
        const BackButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}