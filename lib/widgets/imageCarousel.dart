import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ManuallyControlledSlider extends StatefulWidget {
  final List<String> imgList;
  final String? videoUrl;
  final bool selected;

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
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: true,
        aspectRatio: 16 / 9,
      );
      _videoController!.initialize();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> slides = [
      ...widget.imgList.map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              child: Image.network(
                item,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          )),
      if (widget.videoUrl != null && _chewieController != null)
        Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            child: Chewie(controller: _chewieController!),
          ),
        ),
    ]..shuffle();

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider(
                items: slides,
                options: CarouselOptions(
                  enlargeCenterPage: false, // Full width
                  autoPlay: slides.length > 1,
                  enableInfiniteScroll: slides.length > 1,
                  aspectRatio: 2.0,
                  viewportFraction: 1.0, // Full width of container
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                carouselController: _controller,
              ),
              if (widget.selected && slides.length > 1) ...[
                Positioned(
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                    onPressed: () => _controller.previousPage(),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
                    onPressed: () => _controller.nextPage(),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (slides.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: slides.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromARGB(198, 176, 179, 180)
                            : const Color.fromARGB(197, 8, 8, 8))
                        .withOpacity(_current == entry.key ? 0.9 : 0.4),
                  ),
                ),
              );
            }).toList(),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}