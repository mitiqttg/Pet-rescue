import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:async'; // Import for Future

class ManuallyControlledSlider extends StatefulWidget {
  final List<String> imgList;
  final String? videoUrl;
  final bool selected; // Keep track if the parent PetCard is selected

  const ManuallyControlledSlider({
    Key? key,
    required this.imgList,
    this.videoUrl,
    required this.selected,
  }) : super(key: key);

  @override
  State<ManuallyControlledSlider> createState() => _ManuallyControlledSliderState();
}

class _ManuallyControlledSliderState extends State<ManuallyControlledSlider> {
  final CarouselSliderController _carouselController = CarouselSliderController(); // Updated to match expected type
  int _current = 0;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  Future<void>? _initializeVideoPlayerFuture; // To track initialization
  bool _isVideoInitialized = false; // Track initialization state

  // Keep track of the video slide index if a video exists
  int? _videoSlideIndex;

  @override
  void initState() {
    super.initState();
    // Determine the video slide index *before* initializing
    if (widget.videoUrl != null) {
      // Video will be added *after* images
      _videoSlideIndex = widget.imgList.length;
    }

    if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

      // Store the future and handle initialization completion/error
      _initializeVideoPlayerFuture = _videoController!.initialize().then((_) {
        // Video initialized successfully
        if (!mounted) return; // Check if widget is still in the tree

        // Create ChewieController *after* initialization
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: false, // Don't autoplay initially
          looping: true,
          // Let Chewie determine aspect ratio, or set based on controller
          // aspectRatio: _videoController!.value.aspectRatio,
          // You might want to customize controls further
           allowFullScreen: true,
           allowMuting: true,
           // Add error builder for Chewie
           errorBuilder: (context, errorMessage) {
              return Center(
                 child: Text(
                   'Error playing video: $errorMessage',
                   style: const TextStyle(color: Colors.white),
                   textAlign: TextAlign.center,
                 ),
              );
           },
        );
        setState(() {
          _isVideoInitialized = true; // Update state to trigger rebuild with Chewie
        });
      }).catchError((error) {
        // Handle initialization error
        print("Error initializing video player: $error");
        if (!mounted) return;
        setState(() {
           _isVideoInitialized = false; // Ensure it's marked as not initialized
           // Optionally show an error message in the UI
        });
      });
    }
  }

  @override
  void dispose() {
    // Important: Dispose controllers to free up resources
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  // --- Helper to build slides ---
  List<Widget> _buildSlides() {
    // Build image slides first
    final List<Widget> imageWidgets = widget.imgList.map((item) {
      return Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          child: Image.network(
            item,
            fit: BoxFit.contain, // Use contain to see the whole image
            width: double.infinity,
            height: double.infinity,
            // Add loading and error builders for images
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              print("Error loading image: $error");
              return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
            },
          ),
        ),
      );
    }).toList();

    // Combine image slides and potentially the video slide
    final List<Widget> allSlides = [...imageWidgets];

    // Add video slide if URL exists
    if (widget.videoUrl != null) {
      Widget videoPlaceholderOrPlayer;
      if (_isVideoInitialized && _chewieController != null) {
        // If initialized and Chewie controller exists, show player
        videoPlaceholderOrPlayer = Chewie(controller: _chewieController!);
      } else {
        // Otherwise, show loading indicator or error
        videoPlaceholderOrPlayer = Container(
          color: Colors.black, // Placeholder background
          child: Center(
            child: _initializeVideoPlayerFuture != null
                ? const CircularProgressIndicator() // Show loading if init is in progress
                : const Icon(Icons.error_outline, color: Colors.red, size: 40), // Show error if init failed early
          ),
        );
      }

      // Add the video placeholder/player wrapped in styling container
      allSlides.add(
        Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            child: videoPlaceholderOrPlayer,
          ),
        ),
      );
    }

    // DO NOT SHUFFLE: return allSlides..shuffle();
    return allSlides;
  }


  // --- Function to handle page changes ---
  void _onPageChanged(int index, CarouselPageChangedReason reason) {
     setState(() {
       _current = index;
     });

     // Pause video if sliding away from it, play if sliding to it (optional)
     if (_videoController != null && _isVideoInitialized) {
        if (index == _videoSlideIndex) {
           // Optionally play when video slide becomes active
           // _chewieController?.play();
        } else {
           // Pause when leaving the video slide
           _chewieController?.pause();
        }
     }
  }

  @override
  Widget build(BuildContext context) {
    // Build the slides list *once* per build
    final List<Widget> slides = _buildSlides();

    // If there are no slides (e.g., empty imgList and no video), show a placeholder
     if (slides.isEmpty) {
        return Container(
           height: 180, // Match height given in PetCard
           alignment: Alignment.center,
           child: const Text("No media available", style: TextStyle(color: Colors.grey)),
           decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.grey.shade300)
           ),
           margin: const EdgeInsets.all(5.0),
        );
     }

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider(
                items: slides,
                options: CarouselOptions(
                  // Control height directly instead of aspect ratio for consistency
                  // height: 200.0, // Or let Expanded handle height
                  enlargeCenterPage: false, // Keep slides same size
                  // AutoPlay only if multiple slides and card is NOT expanded (selected)?
                  autoPlay: slides.length > 1 && !widget.selected,
                  autoPlayInterval: const Duration(seconds: 5), // Adjust interval
                  enableInfiniteScroll: slides.length > 1, // Allow looping if multiple slides
                  viewportFraction: 1.0, // Each slide takes full width
                  onPageChanged: _onPageChanged, // Use the handler function
                ),
                carouselController: _carouselController, // Updated to use the correct controller type
              ),
              // Show arrows only if card is selected and more than one slide
              if (widget.selected && slides.length > 1) ...[
                Positioned(
                  left: 0, // Adjust positioning as needed
                  child: Container( // Add background for better visibility
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24), // Adjusted icon/size
                      onPressed: () => _carouselController.previousPage(),
                      tooltip: 'Previous',
                    ),
                  ),
                ),
                Positioned(
                  right: 0, // Adjust positioning as needed
                  child: Container( // Add background for better visibility
                     decoration: BoxDecoration(
                       color: Colors.black.withOpacity(0.3),
                       shape: BoxShape.circle,
                     ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 24), // Adjusted icon/size
                      onPressed: () => _carouselController.nextPage(),
                      tooltip: 'Next',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Indicator dots (only show if more than one slide)
        if (slides.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: slides.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  // Make dots slightly larger and easier to tap
                  width: 8.0, // Increased size
                  height: 8.0, // Increased size
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Adjusted margin
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Use theme colors for dots
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4), // Opacity indicates selection
                  ),
                ),
              );
            }).toList(),
          )
        else
          const SizedBox(height: 20.0), // Maintain space even if no dots
      ],
    );
  }
}