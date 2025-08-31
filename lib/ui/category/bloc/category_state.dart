part of 'category_bloc.dart';

@freezed
abstract class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = _Initial;
  const factory CategoryState.loading() = _Loading;
  const factory CategoryState.loaded({required Comic comic}) = _Loaded;
  const factory CategoryState.error({required String message}) = _Error;
}
