import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluter_comic/data/models/comic.dart';
import 'package:fluter_comic/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerWidget extends StatefulWidget {
  Comic home;
  BannerWidget({super.key, required this.home});
  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.6); // Adjust as needed
  double _currentPage = 0.0;
  late final List<ItemsComic> items;

  @override
  void initState() {
    super.initState();
    items = widget.home.data.items;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Positioned.fill(
          child: Stack(
            fit: StackFit.expand, // Đảm bảo các lớp con phủ đầy Stack
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25),
                child: CachedNetworkImage(
                  imageUrl: 'https://img.otruyenapi.com/uploads/comics/${items[_currentPage.round()].thumbUrl}',
                  fit: BoxFit.cover,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      // Colors.black.withOpacity(0.8), // Tối ở trên
                      // Colors.transparent, // Trong suốt ở giữa
                      // Colors.black.withOpacity(1), // Tối ở dưới
                      colorScheme.surface.withOpacity(0.8), // Tối ở trên
                      Colors.transparent, // Trong suốt ở giữa
                      colorScheme.surface.withOpacity(1), // Tối ở dưới
                    ],
                    stops: const [0, 0.5, 1],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 90,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 460,
            child: Column(
              children: [
                SizedBox(height: 270, child: _buildPageView()),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    items[_currentPage.round()].name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: items.length,
                    effect: ScrollingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 10.0,
                      activeDotColor: Colors.white,
                      dotColor: Colors.grey.withAlpha(130), // màu các dot còn lại
                    ),
                    onDotClicked: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      children: List.generate(items.length, (index) {
        final double relativePage = index - _currentPage;
        final double scale = 1.0 - (relativePage.abs() * 0.2);
        final double rotationAngle = relativePage * 0.3;
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            return Transform.scale(
              scale: scale.clamp(0.8, 1.0),
              child: Transform.rotate(
                angle: rotationAngle,
                child: GestureDetector(
                  onTap: () {
                    context.push(RoutePaths.info, extra: items[index].slug);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: 'https://img.otruyenapi.com/uploads/comics/${items[index].thumbUrl}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
