import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
class ComicThemeExtension extends ThemeExtension<ComicThemeExtension> {
  final Color likeColor;
  final Color dislikeColor;
  final Color bookmarkColor;
  final Color ratingColor;
  final List<Color> primaryGradient;
  final List<Color> secondaryGradient;
  final Color commentBackgroundColor;
  final Color chapterItemColor;
  final Color readButtonColor;
  final Color actionButtonColor;

  const ComicThemeExtension({
    required this.likeColor,
    required this.dislikeColor,
    required this.bookmarkColor,
    required this.ratingColor,
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.commentBackgroundColor,
    required this.chapterItemColor,
    required this.readButtonColor,
    required this.actionButtonColor,
  });

  @override
  ComicThemeExtension copyWith({
    Color? likeColor,
    Color? dislikeColor,
    Color? bookmarkColor,
    Color? ratingColor,
    List<Color>? primaryGradient,
    List<Color>? secondaryGradient,
    Color? commentBackgroundColor,
    Color? chapterItemColor,
    Color? readButtonColor,
    Color? actionButtonColor,
  }) {
    return ComicThemeExtension(
      likeColor: likeColor ?? this.likeColor,
      dislikeColor: dislikeColor ?? this.dislikeColor,
      bookmarkColor: bookmarkColor ?? this.bookmarkColor,
      ratingColor: ratingColor ?? this.ratingColor,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      commentBackgroundColor:
          commentBackgroundColor ?? this.commentBackgroundColor,
      chapterItemColor: chapterItemColor ?? this.chapterItemColor,
      readButtonColor: readButtonColor ?? this.readButtonColor,
      actionButtonColor: actionButtonColor ?? this.actionButtonColor,
    );
  }

  @override
  ComicThemeExtension lerp(ComicThemeExtension? other, double t) {
    if (other is! ComicThemeExtension) {
      return this;
    }
    return ComicThemeExtension(
      likeColor: Color.lerp(likeColor, other.likeColor, t)!,
      dislikeColor: Color.lerp(dislikeColor, other.dislikeColor, t)!,
      bookmarkColor: Color.lerp(bookmarkColor, other.bookmarkColor, t)!,
      ratingColor: Color.lerp(ratingColor, other.ratingColor, t)!,
      primaryGradient: [
        for (int i = 0; i < primaryGradient.length; i++)
          Color.lerp(primaryGradient[i], other.primaryGradient[i], t)!,
      ],
      secondaryGradient: [
        for (int i = 0; i < secondaryGradient.length; i++)
          Color.lerp(secondaryGradient[i], other.secondaryGradient[i], t)!,
      ],
      commentBackgroundColor: Color.lerp(
        commentBackgroundColor,
        other.commentBackgroundColor,
        t,
      )!,
      chapterItemColor: Color.lerp(
        chapterItemColor,
        other.chapterItemColor,
        t,
      )!,
      readButtonColor: Color.lerp(readButtonColor, other.readButtonColor, t)!,
      actionButtonColor: Color.lerp(
        actionButtonColor,
        other.actionButtonColor,
        t,
      )!,
    );
  }

  // Light theme extension
  static const ComicThemeExtension light = ComicThemeExtension(
    likeColor: AppColors.likeBlue,
    dislikeColor: AppColors.dislikeRed,
    bookmarkColor: AppColors.bookmarkOrange,
    ratingColor: AppColors.ratingYellow,
    primaryGradient: AppColors.primaryGradient,
    secondaryGradient: AppColors.secondaryGradient,
    commentBackgroundColor: AppColors.gray50,
    chapterItemColor: AppColors.gray100,
    readButtonColor: AppColors.success,
    actionButtonColor: AppColors.lightPrimary,
  );

  // Dark theme extension
  static const ComicThemeExtension dark = ComicThemeExtension(
    likeColor: AppColors.likeBlue,
    dislikeColor: AppColors.dislikeRed,
    bookmarkColor: AppColors.bookmarkOrange,
    ratingColor: AppColors.ratingYellow,
    primaryGradient: AppColors.primaryGradient,
    secondaryGradient: AppColors.secondaryGradient,
    commentBackgroundColor: AppColors.gray900,
    chapterItemColor: AppColors.gray800,
    readButtonColor: AppColors.success,
    actionButtonColor: AppColors.darkPrimary,
  );
}

// Extension for easy access
extension ComicThemeHelper on ThemeData {
  ComicThemeExtension get comicTheme =>
      extension<ComicThemeExtension>() ?? ComicThemeExtension.light;
}
