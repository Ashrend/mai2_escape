class CommonResponse<T> {
  final bool success;
  final String message;
  final T data;

  CommonResponse(
      {required this.success, required this.message, required this.data});
}
