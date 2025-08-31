import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fluter_comic/config/hive/hive_types.dart';

part 'rate.g.dart';
part 'rate.freezed.dart';

@freezed
@HiveType(typeId: HiveTypes.rate)
abstract class Rate with _$Rate {
  const factory Rate({
    @HiveField(0) required String slug,
    @HiveField(1) required int rating,
  }) = _Rate;

  factory Rate.fromJson(Map<String, dynamic> json) => _$RateFromJson(json);
}
