class HiveTypes {
  const HiveTypes._();

  static const library = 0;
  static const rate = 1;
  static const favorite = 1;
}

/**
 * Annotation @HiveType(typeId: HiveTypes.example) sử dụng hằng số HiveTypes.example (giá trị 0) làm typeId cho lớp Example.
Ý nghĩa: typeId: HiveTypes.example (tức typeId: 0) báo cho Hive rằng lớp Example được xác định bằng ID 0 trong cơ sở dữ liệu.
 Điều này giúp Hive phân biệt Example với các model khác (Sense, Word, v.v.) khi serialize/deserialize.
 */
