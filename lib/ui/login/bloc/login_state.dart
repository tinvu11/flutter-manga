part of 'login_bloc.dart';

// Thêm part file cho freezed. Tên file phải khớp.

@freezed
abstract class LoginState with _$LoginState {
  // Trạng thái ban đầu hoặc khi người dùng đang nhập liệu.
  // Chứa dữ liệu về validation.
  const factory LoginState.initial({
    @Default(true) bool isEmailValid,
    @Default(true) bool isPasswordValid,
  }) = _Initial;

  // Trạng thái đang xử lý đăng nhập (loading).
  const factory LoginState.loading() = _Loading;

  // Trạng thái đăng nhập thành công.
  const factory LoginState.success() = _Success;

  // Trạng thái đăng nhập thất bại, có thể kèm theo thông báo lỗi.
  const factory LoginState.failure({String? message}) = _Failure;
}

// (Tùy chọn) Thêm một extension để lấy getter isFormValid cho tiện
extension LoginStateX on LoginState {
  bool get isFormValid => maybeWhen(
    initial: (isEmailValid, isPasswordValid) => isEmailValid && isPasswordValid,
    orElse: () => false, // Chỉ state initial mới có form valid
  );
}
