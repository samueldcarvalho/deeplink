// ignore_for_file: constant_identifier_names

enum StatusReponse {
  empty,
  error,
  report_not_available,
  success,
  unauthorized,
  activation_pending,
  blocked_user,
  error_connection_internet,
  user_incomplete_data
}

class ApiResponse<T> {
  final StatusReponse cStatus;
  final String cMessage;
  final T cResult;

  ApiResponse({
    required this.cStatus,
    required this.cMessage,
    required this.cResult,
  });
}
