part of 'rate_bloc.dart';

@freezed
abstract class RateState with _$RateState {
  const factory RateState.initial() = _Initial;
  const factory RateState.loading() = _Loading;
  const factory RateState.loaded({required GetRate getRate}) = _Loaded;
  const factory RateState.error({required String message}) = _Error;
}
