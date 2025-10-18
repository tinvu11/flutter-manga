import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/common/mixins/authentication_mixin.dart';
import 'package:fluter_comic/config/theme/app_colors.dart';
import 'package:fluter_comic/ui/comment/bloc/comment_bloc.dart';
import 'package:fluter_comic/ui/comment/commnent_screen.dart';
import 'package:fluter_comic/ui/info/bloc/info_comic_bloc.dart';
import 'package:fluter_comic/ui/login/login_screen.dart';
import 'package:fluter_comic/ui/rate/bloc/rate_bloc.dart';
import 'package:fluter_comic/ui/rate/rate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RateAllWidget extends StatefulWidget {
  final String slug;
  final String title;
  final bool isMarked;
  final int totalChapter;

  const RateAllWidget({
    super.key,

    required this.totalChapter,
    required this.slug,
    required this.title,
    required this.isMarked,
  });

  @override
  State<RateAllWidget> createState() => _RateAllWidgetState();
}

class _RateAllWidgetState extends State<RateAllWidget>
    with AuthenticationMixin {
  bool isMark = false;
  bool hasFavorite = false;
  String? uid;

  @override
  void initState() {
    super.initState();
    context.read<RateBloc>().add(RateEvent.fetch(slug: widget.slug));
    context.read<CommentBloc>().add(
      CommentEvent.loadComments(comicId: widget.slug),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRateWidget();
  }

  Widget _buildRateWidget({var currentRate = 0, int countRate = 0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<RateBloc, RateState>(
            builder: (context, state) {
              return _buildActionButton(
                label: 'Đánh giá',
                color: Colors.amber,
                onTap: () => RateScreen(
                  title: widget.title,
                  slug: widget.slug,
                ).show(context),
                badge: state.maybeMap(
                  loaded: (data) =>
                      data.getRate.rate != 0 ? '${data.getRate.rate}' : null,
                  orElse: () => null,
                ),
                badgeColor: Colors.deepOrange,
                isActive: currentRate != 0,
              );
            },
          ),
          const SizedBox(width: 12),
          BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              return _buildActionButton(
                label: 'Bình luận',
                color: Colors.blue,
                onTap: () => CommnentScreen.show(context, widget.slug),
                badge: state.maybeMap(
                  orElse: () => null,
                  loaded: (data) {
                    return data.comments.isNotEmpty
                        ? '${data.comments.length}'
                        : null;
                  },
                ),
                badgeColor: Colors.blue,
              );
            },
          ),
          const SizedBox(width: 12),
          BlocBuilder<InfoComicBloc, InfoComicState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (value, isMarked) {
                  return _buildActionButton(
                    icon: isMarked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    label: 'Lưu',
                    color: isMarked ? Colors.red : Colors.grey,
                    onTap: () {
                      _handleFavoriteToggle(isMarked: isMarked);
                    },
                    isActive: isMarked,
                    hasRipple: true,
                  );
                },

                orElse: () {
                  return _buildActionButton(
                    icon: Icons.favorite_border_rounded,
                    label: 'Lưu',
                    color: Colors.grey,
                    onTap: () {
                      _handleFavoriteToggle(isMarked: false);
                    },
                    isActive: isMark,
                    hasRipple: true,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
    IconData? icon,
    String? badge,
    Color? badgeColor,
    bool isActive = false,
    bool hasRipple = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.secondary,

          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            badge != null
                ? Text(
                    '$badge | ',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox.shrink(),

            // Icon(icon, color: Colors.white, size: 22),
            // const SizedBox(width: 8),
            icon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: isActive
                        ? Icon(Icons.bookmark, size: 18)
                        : Icon(Icons.bookmark_outline, size: 18),
                  )
                : const SizedBox.shrink(),
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFavoriteToggle({required bool isMarked}) {
    if (isMarked) {
      context.read<InfoComicBloc>().add(InfoComicEvent.deleteMark(widget.slug));
    } else {
      context.read<InfoComicBloc>().add(InfoComicEvent.addMark(widget.slug));
    }
  }
}
