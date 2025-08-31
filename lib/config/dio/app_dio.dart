import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'connectivity_interceptor.dart';
import 'logging_interceptor.dart';

export 'connectivity_interceptor.dart';
export 'logging_interceptor.dart';

abstract class AppDio {
  Dio? _dio; // kiểu private để lưu trữ đối tượng Dio ban đầu là null

  Dio get dio {
    _dio ??=
        _get(); // lazy initialization chỉ tạo Dio khi cần thiết ví dụ khi gọi lần đầu tiên lần sau // sẽ sử dụng lại đối tượng đã tạo
    return _dio!;
  }

  Dio _get();
}

// Cung cấp một instance Dio được cấu hình đặc biệt cho dịch vụ dịch thuật.
class ComicDio extends AppDio {
  final int _connectTimeout = 60000;
  final int _receiveTimeout = 60000;
  final Connectivity _connectivity;

  ComicDio({required Connectivity connectivity})
    : _connectivity =
          connectivity; // nhận 1 tham số bắt buộc là Connectivity và gán cho biến _connectivity
  // giải thích: đây là constructor của lớp ComicDio, nhận vào một đối tượng Connectivity để kiểm tra kết nối mạng.

  // Triển khai phương thức get()
  @override
  Dio _get() {
    return Dio()
      ..options = BaseOptions(
        // baseUrl: const String.fromEnvironment("COMIC_BASE_URL"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: Duration(milliseconds: _connectTimeout),
        receiveTimeout: Duration(milliseconds: _receiveTimeout),
      )
      ..interceptors.addAll([
        LoggingInterceptor(),
        ConnectivityInterceptor(connectivity: _connectivity),
        // Interceptors: Cung cấp khả năng tùy chỉnh yêu cầu HTTP, như kiểm tra mạng trước khi gọi API hoặc ghi log để debug.
      ]);
  }
}
