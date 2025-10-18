import 'package:fluter_comic/common/bloc/authentication/authentication_bloc.dart';
import 'package:fluter_comic/common/mixins/authentication_mixin.dart';
import 'package:fluter_comic/config/di.dart';
import 'package:fluter_comic/data/data_sources/firestore/firestore_service.dart';
import 'package:fluter_comic/data/repository/firestore_repository.dart';
import 'package:fluter_comic/ui/rate/bloc/rate_bloc.dart';
import 'package:fluter_comic/ui/rate/widgets/button_widget.dart';
import 'package:fluter_comic/ui/rate/widgets/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RateScreen extends StatefulWidget {
  final String title;
  final String slug;

  const RateScreen({super.key, required this.title, required this.slug});

  @override
  State<RateScreen> createState() => _RateScreenState();

  Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => RateBloc(
          firestoreRepository: FirestoreRepositoryImpl(
            firestoreService: DI().sl<FirestoreService>(),
          ),
        ),
        child: RateScreen(title: title, slug: slug),
      ),
    );
  }
}

class _RateScreenState extends State<RateScreen> with AuthenticationMixin {
  final List<Map<String, dynamic>> items = [
    {
      'icon': 'assets/icons/rate-5.webp',
      'text': 'Tuyệt vời',
      'color': Colors.green,
      'point': 10,
    },
    {
      'icon': 'assets/icons/rate-4.webp',
      'text': 'Hay nha',
      'color': Colors.green,
      'point': 8,
    },
    {
      'icon': 'assets/icons/rate-3.webp',
      'text': 'Khá ổn',
      'color': Colors.green,
      'point': 6,
    },
    {
      'icon': 'assets/icons/rate-2.webp',
      'text': 'Chán ngắt',
      'color': Colors.green,
      'point': 4,
    },
    {
      'icon': 'assets/icons/rate-1.webp',
      'text': 'Dở tệ',
      'color': Colors.green,
      'point': 2,
    },
  ];

  int? selectedIndex;
  bool isRate = false;
  double currentRate = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<RateBloc>().add(RateEvent.fetch(slug: widget.slug));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<RateBloc, RateState>(
      builder: (context, state) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authState) {
            final currentUser = authState.maybeMap(
              authenticated: (value) =>
                  (uid: value.user.uid, userName: value.user.name),
              orElse: () => (uid: null, userName: null),
            );

            state.maybeWhen(
              loaded: (getRate) {
                isRate =
                    currentUser.uid != null &&
                    getRate.rateBy.containsKey(currentUser.uid);
                if (isRate) {
                  print('User has rated');
                  selectedIndex = items.indexWhere(
                    (item) => item['point'] == getRate.rateBy[currentUser.uid],
                  );
                }
              },
              orElse: () {
                isRate = false;
              },
            );

            return Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _buildRateText(state),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 18),
                    _buildListRate(
                      currentUser.uid != null ? currentUser.uid! : "",
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _buildRateText(RateState state) {
    return state.maybeWhen(
      loaded: (getRate) {
        return getRate.rateBy.isNotEmpty
            ? 'Đánh giá: ${getRate.rate} /${getRate.count}'
            : 'Chưa có đánh giá';
      },
      error: (message) => 'Lỗi: $message',
      loading: () => 'Đang tải...',
      initial: () => 'Khởi tạo...',
      orElse: () => 'Chưa có đánh giá',
    );
  }

  Widget _buildListRate(String uid) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return IconWidget(
                isSelected:
                    ((selectedIndex == index) ||
                    (isRate && selectedIndex == index)),
                onTap: () {
                  if (!isRate) {
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                },
                imageIcon: item['icon'],
                textIcon: item['text'],
                activeColor: item['color'],
              );
            }),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            ButtonWidget(
              text: 'Gửi đánh giá',
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              flex: 1,
              ontap: () => _handleSubmitRating(uid),
            ),
            const SizedBox(width: 10),
            ButtonWidget(
              text: 'Huỷ',
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              flex: 1,
              ontap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }

  void _handleSubmitRating(String uid) {
    if (isRate) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('Bạn đã đánh giá truyện này rồi'),
          );
        },
      );
      return;
    }

    if (selectedIndex == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: const Text('Vui lòng chọn đánh giá'));
        },
      );
      return;
    }

    executeWithAuth(() {
      context.read<RateBloc>().add(
        RateEvent.submit(
          uid: uid,
          currentRate: currentRate,
          slug: widget.slug,
          rating: items[selectedIndex!]['point'] as int,
        ),
      );
    });
  }
}
