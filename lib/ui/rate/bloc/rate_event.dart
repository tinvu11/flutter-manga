part of 'rate_bloc.dart';

@freezed
abstract class RateEvent with _$RateEvent {
  const factory RateEvent.fetch({required String slug}) = _Fetch;
  const factory RateEvent.submit({
    required int rating,
    required String slug,
    required double currentRate,
  }) = _Submit;
  const factory RateEvent.checkUserRate({
    required String uid,
    required String slug,
  }) = _CheckUserRate;
}
