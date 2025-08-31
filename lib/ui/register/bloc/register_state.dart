part of 'register_bloc.dart';

// Thêm part file cho freezed. Tên file phải khớp.

@freezed
abstract class RegisterState with _$RegisterState {
  // Trạng thái ban đầu hoặc khi người dùng đang nhập liệu.
  // Chứa dữ liệu về validation.
  const factory RegisterState.initial({
    @Default(true) bool isNameValid,
    @Default(true) bool isEmailValid,
    @Default(true) bool isPasswordValid,
    @Default(true) bool isConfirmPasswordValid,
  }) = _Initial;

  // Trạng thái đang xử lý đăng nhập (loading).
  const factory RegisterState.loading() = _Loading;

  // Trạng thái đăng nhập thành công.
  const factory RegisterState.success() = _Success;

  // Trạng thái đăng nhập thất bại, có thể kèm theo thông báo lỗi.
  const factory RegisterState.failure({String? message}) = _Failure;
}

// (Tùy chọn) Thêm một extension để lấy getter isFormValid cho tiện
extension RegisterStateX on RegisterState {
  bool get isFormValid => maybeWhen(
    initial:
        (isNameValid, isEmailValid, isPasswordValid, isConfirmPasswordValid) =>
            isNameValid &&
            isEmailValid &&
            isPasswordValid &&
            isConfirmPasswordValid,
    orElse: () => false, // Chỉ state initial mới có form valid
  );
}
