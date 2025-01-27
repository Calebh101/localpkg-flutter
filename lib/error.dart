import 'package:localpkg/logger.dart' as logger;

class ManualError extends Error {
  final String message;

  ManualError(
    this.message,
  );

  @override
  String toString() {
    return 'ManualError: $message';
  }

  void warn({String? code, bool? trace}) {
    logger.warn(toString(), code: code, trace: trace ?? false);
  }

  void error({String? code, bool? trace}) {
    logger.error(toString(), code: code, trace: trace ?? false);
  }

  void invoke({String? code, bool? trace}) {
    throw Exception(toString());
  }
}