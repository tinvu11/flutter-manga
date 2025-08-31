import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/config/di.dart';
import 'package:fluter_comic/data/data_sources/firestore/firestore_service.dart';
import 'package:fluter_comic/data/repository/firestore_repository.dart';
import 'package:fluter_comic/ui/comment/bloc/comment_bloc.dart';
import 'package:fluter_comic/ui/comment/widgets/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommnentScreen extends StatefulWidget {
  final String slug;
  const CommnentScreen({super.key, required this.slug});

  @override
  State<CommnentScreen> createState() => _CommnentScreenState();

  static Future<void> show(BuildContext context, String slug) {
    return showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // builder: (context) => const CommnentScreen(),
      builder: (context) => BlocProvider(
        create: (context) => CommentBloc(
          firestoreRepository: FirestoreRepositoryImpl(
            firestoreService: DI().sl<FirestoreService>(),
          ),
        ),
        child: CommnentScreen(slug: slug),
      ),
    );
  }
}

class _CommnentScreenState extends State<CommnentScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            width: 60,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bình luận',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Divider(thickness: 0.2),
          Expanded(child: CommentWidget(slug: widget.slug)),
        ],
      ),
    );
  }
}
