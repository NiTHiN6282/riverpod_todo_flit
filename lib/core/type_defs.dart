import 'package:fpdart/fpdart.dart';
import 'package:riverpod_todo_flit/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
