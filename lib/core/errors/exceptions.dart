class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class ServerException extends AppException {
  ServerException(super.message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);
}

class ForbiddenException extends AppException {
  ForbiddenException(super.message);
}

class NotFoundException extends AppException {
  NotFoundException(super.message);
}

class BadRequestException extends AppException {
  final String code;
  final String detail;

  BadRequestException(super.message, this.code, this.detail);

  @override
  String toString() => '$message (Code: $code)';
}

class UnknownException extends AppException {
  UnknownException(super.message);
}
