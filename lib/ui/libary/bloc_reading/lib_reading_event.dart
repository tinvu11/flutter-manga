part of 'lib_reading_bloc.dart';

@freezed
abstract class LibReadingEvent with _$LibReadingEvent {
  const factory LibReadingEvent.loadReadings() = _LoadReadings;
  const factory LibReadingEvent.deleteReading({required String slug}) =
      _DeleteReading;
}
