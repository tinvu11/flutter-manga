// import 'package:fluter_comic/data/models/library.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';

// // AppHive quản lý việc khởi tạo và truy cập các hộp (boxes) của Hive, mỗi hộp lưu trữ một loại dữ liệu cụ thể.
// class AppHive {
//   static const String libraryKey = 'library';
//   // Các getter để truy cập hộp Hive
//   Box<Library> get libraryBox => Hive.box<Library>(libraryKey);

//   init() async {
//     final dir = await getApplicationDocumentsDirectory();
//     // (từ path_provider) trả về đường dẫn đến thư mục tài liệu của ứng dụng trên thiết bị
//     await Hive.initFlutter(dir.path);
//     // Đường dẫn này được dùng để khởi tạo Hive.
//     // Hive.initFlutter(dir.path): Khởi tạo Hive với đường dẫn thư mục lưu trữ, chuẩn bị môi trường để lưu trữ các hộp.

//     // Adapter: Là các lớp (được tạo tự động hoặc viết tay) để chuyển đổi các đối tượng Dart thành dữ liệu nhị phân mà Hive có thể lưu trữ và ngược lại. Mỗi model cần một adapter tương ứng (ví dụ: WordAdapter cho Word).
//     Hive.registerAdapter(LibraryAdapter());

//     await Hive.openBox<Library>(libraryKey);

//     // Hive.openBox<T>(key): Mở một hộp Hive với tên key và kiểu dữ liệu T. Các hộp này được dùng để lưu trữ và truy xuất dữ liệu.
//   }
// }
