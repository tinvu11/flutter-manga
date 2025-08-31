import 'package:fluter_comic/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CategoriesWidgetWidget extends StatelessWidget {
  const CategoriesWidgetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const List<String> genres = [
      'Action',
      'Adventure',
      'Anime',
      'Comic',
      'Drama',
      'Mystery',
      'Romance',
      'Trinh Thám',
    ];
    const List<String> icons = [
      'ic_action',
      'ic_adventure',
      'ic_anime',
      'ic_comic',
      'ic_darama',
      'ic_mystery',
      'ic_romance',
      'ic_trinhtham',
    ];
    const Map<String, dynamic> iconColors = {
      'ic_action': Colors.amber,
      'ic_adventure': Colors.blue,
      'ic_anime': Colors.pink,
      'ic_comic': Colors.green,
      'ic_darama': Colors.red,
      'ic_mystery': Colors.purple,
      'ic_romance': Colors.orange,
      'ic_trinhtham': Colors.teal,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8,
            children: List.generate(genres.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(
                          RoutePaths.category,
                          extra: genres[index].toLowerCase(),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: iconColors[icons[index]].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: SvgPicture.asset(
                            'assets/svg/${icons[index]}.svg',
                            color: iconColors[icons[index]],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      genres[index],
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
