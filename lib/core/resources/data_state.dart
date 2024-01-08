import 'package:equatable/equatable.dart';

abstract class DataState<T> extends Equatable {
  final T? data;
  final String? error;
  final String? errorMsg;
  final ErrorType? errorType;

  const DataState({
    this.data,
    this.error,
    this.errorMsg,
    this.errorType,
  });
}

class SuccessState<T> extends DataState<T> {
  const SuccessState({required T data}) : super(data: data);
  @override
  List<Object?> get props => [data];
}

class FailureState<T> extends DataState<T> {
  const FailureState({
    required String error,
    required String errorMsg,
    required String errorType,
  }) : super(
          error: error,
          errorMsg: errorMsg,
          errorType: ErrorType.unknown,
        );

  @override
  List<Object?> get props => [error, errorMsg, errorType];
}

enum ErrorType { unknown, dioException, npNetwork }
