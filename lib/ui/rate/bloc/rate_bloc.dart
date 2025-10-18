import 'dart:async';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:fluter_comic/data/models/firebase/get_rate.dart';
import 'package:fluter_comic/data/models/firebase/user_rate.dart';
import 'package:fluter_comic/data/repository/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'rate_bloc.freezed.dart';
part 'rate_event.dart';
part 'rate_state.dart';

class RateBloc extends Bloc<RateEvent, RateState> {
  final FirestoreRepository _firestoreRepository;
  StreamSubscription? _rateSubscription;
  RateBloc({required FirestoreRepository firestoreRepository})
    : _firestoreRepository = firestoreRepository,

      super(const RateState.initial()) {
    on<RateEvent>((event, emit) async {
      await event.map(
        fetch: (e) => _onFetch(e, emit),
        submit: (e) => _onSubmit(e, emit),
        checkUserRate: (e) => _onCheckUserRate(e, emit),
      );
    });
  }

  Future<void> _onFetch(_Fetch event, Emitter<RateState> emit) async {
    emit(const RateState.loading());

    await emit.forEach<Either<String, GetRate>>(
      _firestoreRepository.getRateStream(event.slug),
      onData: (result) {
        return result.fold((failure) => RateState.error(message: failure), (
          rate,
        ) {
          print('Fetched rate: ${rate.rate}, count: ${rate.count}');
          return RateState.loaded(
            getRate: GetRate(
              id: rate.id,
              rate: rate.rate,
              count: rate.count,
              rateBy: rate.rateBy,
            ),
          );
        });
      },
      onError: (error, stackTrace) =>
          RateState.error(message: error.toString()),
    );
  }

  // Bạn không cần ghi đè close() để cancel subscription nữa

  Future<void> _onSubmit(_Submit event, Emitter<RateState> emit) async {
    try {
      UserRate rateInfo = UserRate(
        currentRate: event.currentRate,
        slug: event.slug,
        userId: event.uid,
        userRate: event.rating,
      );
      final result = await _firestoreRepository.addRate(rateInfo);
      result.fold(
        (failure) => emit(RateState.error(message: failure)),
        (success) {},
      );
    } catch (e) {
      emit(RateState.error(message: e.toString()));
    }
  }

  Future<void> _onCheckUserRate(
    _CheckUserRate event,
    Emitter<RateState> emit,
  ) async {
    try {
      if (state is _Loaded) {
        final currentState = state as _Loaded;
        final result = currentState.getRate.rateBy;
        final userRate = result[event.uid];
        if (userRate != null) {
          // User has rated
          // You can emit a state or handle accordingly
        } else {
          // User has not rated
          // You can emit a different state or handle accordingly
        }
      }
    } catch (e) {}
  }

  @override
  Future<void> close() {
    _rateSubscription?.cancel();
    return super.close();
  }
}
