import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';
import '../pages/adoptform.dart' as adopt;
import '../widgets/imageCarousel.dart';

class Breakpoints {
  static const sm = 640;
  static const md = 768;
  static const lg = 1024;
  static const xl = 1280;
  static const xl2 = 1536;
}

class PetCard extends StatefulWidget {
  final String petName;
  final String? birth;
  final String? favorites;
  final List<String> images;
  final String shortDes;
  final String specie;
  final String longDes;
  final List<String>? videos;
  final int petId;

  const PetCard({
    Key? key,
    required this.petName,
    this.birth,
    this.favorites,
    required this.images,
    required this.shortDes,
    required this.specie,
    required this.longDes,
    this.videos,
    required this.petId,
  }) : super(key: key);

  @override
  State<PetCard> createState() => _PetCard();
}

class _PetCard extends State<PetCard> {
  bool selected = false;
  final CarouselSliderController _infoController = CarouselSliderController();

  List<Widget> _buildInfoSlides(double cardWidth, bool isExpanded) {
    final textColor = Theme.of(context).colorScheme.tertiary;
    final String fullText = isExpanded
        ? 'Breed: ${widget.specie}\nDescription: ${widget.longDes}'
        : 'Breed: ${widget.specie}\n${widget.shortDes}';

    return [
      Container(
        width: cardWidth,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SingleChildScrollView(
          child: Text(
            fullText,
            style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
            softWrap: true,
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width;

    // --- Responsive cardWidth calculation (Kept from previous fix) ---
    final double cardWidth;
    if (screenWidth < Breakpoints.sm) {
      cardWidth = screenWidth * 0.9;
    } else if (screenWidth < Breakpoints.md) {
      cardWidth = screenWidth * 0.75;
    } else if (screenWidth < Breakpoints.lg) {
      cardWidth = screenWidth * 0.6;
    } else if (screenWidth < Breakpoints.xl) {
      cardWidth = screenWidth * 0.45;
    } else {
      cardWidth = min(screenWidth * 0.35, 600);
    }

    // Height adjusts based on selection state (Kept from previous fix)
    final double cardHeight = selected ? 550 : 350;

    return GestureDetector(
      onTap: () => setState(() => selected = !selected),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          width: cardWidth,
          height: cardHeight,
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image/Video Carousel Section
              SizedBox(
                height: 180,
                width: double.infinity,
                child: ManuallyControlledSlider(
                  imgList: widget.images,
                  videoUrl: widget.videos?.firstOrNull,
                  selected: selected,
                ),
              ),
              const SizedBox(height: 12),

              // Pet Name and Birthday Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      widget.petName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.birth != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Birthday: ${widget.birth!}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                ],
              ),

              // Expanded Info Section or Collapsed Short Description
              if (selected)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildInfoSection(cardWidth - 32),
                  ),
                )
              else
                 Padding(
                     padding: const EdgeInsets.symmetric(vertical: 8.0),
                     child: Text(
                      'Description: ${widget.shortDes}',
                       style: TextStyle(
                           color: Theme.of(context).colorScheme.onSurface,
                           fontSize: 14,
                           height: 1.3
                       ),
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                     ),
                 ),

              // Buttons Row
              _buildButtonRow(cardWidth),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the info section
  Widget _buildInfoSection(double availableWidth) {
    final infoSlides = _buildInfoSlides(availableWidth, selected);
    final bool showArrows = infoSlides.length > 1;

    return Column(
       mainAxisSize: MainAxisSize.min,
       children: [
          Expanded(
             child: Stack(
               alignment: Alignment.center,
               children: [
                 CarouselSlider(
                   items: infoSlides,
                   options: CarouselOptions(
                     viewportFraction: 1.0,
                     enableInfiniteScroll: showArrows,
                     autoPlay: false,
                     height: double.infinity,
                   ),
                   carouselController: _infoController,
                 ),
                 if (showArrows)
                   Positioned(
                     left: 0,
                     child: IconButton(
                       icon: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 0, 0, 0), size: 24),
                       onPressed: () => _infoController.previousPage(),
                     ),
                   ),
                 if (showArrows)
                   Positioned(
                     right: 0,
                     child: IconButton(
                       icon: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 0, 0, 0), size: 24),
                       onPressed: () => _infoController.nextPage(),
                     ),
                   ),
               ],
             ),
           ),
       ],
     );
  }

  // Bottom row with buttons
  Widget _buildButtonRow(double cardWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(child: _buildTextButton('Adopt', () {
            showDialog(
              context: context,
              builder: (context) => adopt.AdoptForm(
                petId: widget.petId,
                petName: widget.petName,
              ),
            );
          })),
          Flexible(child: _buildTextButton('Contact', () {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Contact functionality not implemented yet.')),
             );
          })),
          IconButton(
            icon: Icon(selected ? Icons.expand_less : Icons.expand_more),
            color: Theme.of(context).colorScheme.surface,
            tooltip: selected ? 'Show less' : 'Show more',
            onPressed: () => setState(() => selected = !selected),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(String text, VoidCallback onPressed) {
       return TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
    );
  }
}