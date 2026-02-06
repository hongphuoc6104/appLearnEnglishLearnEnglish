import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, ({User user, String token})>> login(String email, String password);
  Future<Either<Failure, ({User user, String token})>> register(String email, String password, String displayName);
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, void>> logout();
}
