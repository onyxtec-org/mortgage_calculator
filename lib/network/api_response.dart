enum ApiResponseState { loading, success, error }

class ApiResponse<T> {
  final ApiResponseState state;
  final T? data;
  final String? errorMessage;

  ApiResponse.loading(this.errorMessage, {this.data}) : state = ApiResponseState.loading;
  ApiResponse.success(this.data) : state = ApiResponseState.success, errorMessage = null;
  ApiResponse.error(this.errorMessage, {this.data}) : state = ApiResponseState.error;

  bool get isLoading => state == ApiResponseState.loading;
  bool get isSuccess => state == ApiResponseState.success;
  bool get isError => state == ApiResponseState.error;
}