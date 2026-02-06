import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Unit;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/domain/entities/user.dart';
import 'package:mobile/domain/repositories/auth_repository.dart';
import 'package:mobile/domain/usecases/login_usecase.dart';
import 'package:mobile/domain/usecases/register_usecase.dart';
import 'package:mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:mobile/presentation/blocs/auth/auth_event.dart';
import 'package:mobile/presentation/blocs/auth/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockAuthRepository mockAuthRepository;

  const testUser = User(id: '1', email: 'test@test.com', displayName: 'Test', xp: 100, hearts: 5, streak: 3, level: 1);
  const testToken = 'jwt-token-123';

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() => authBloc.close());

  test('initial state is AuthInitial', () {
    expect(authBloc.state, const AuthInitial());
  });

  group('LoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on successful login',
      build: () {
        when(() => mockLoginUseCase('test@test.com', 'password'))
            .thenAnswer((_) async => const Right((user: testUser, token: testToken)));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(email: 'test@test.com', password: 'password')),
      expect: () => [
        const AuthLoading(),
        const Authenticated(user: testUser, token: testToken),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failed login',
      build: () {
        when(() => mockLoginUseCase('test@test.com', 'wrong'))
            .thenAnswer((_) async => const Left(AuthFailure('Invalid credentials')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(email: 'test@test.com', password: 'wrong')),
      expect: () => [
        const AuthLoading(),
        const AuthError('Invalid credentials'),
      ],
    );
  });

  group('RegisterRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on successful register',
      build: () {
        when(() => mockRegisterUseCase('test@test.com', 'password', 'Test'))
            .thenAnswer((_) async => const Right((user: testUser, token: testToken)));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterRequested(email: 'test@test.com', password: 'password', displayName: 'Test')),
      expect: () => [
        const AuthLoading(),
        const Authenticated(user: testUser, token: testToken),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failed register',
      build: () {
        when(() => mockRegisterUseCase('test@test.com', 'password', 'Test'))
            .thenAnswer((_) async => const Left(ServerFailure('Email already exists')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterRequested(email: 'test@test.com', password: 'password', displayName: 'Test')),
      expect: () => [
        const AuthLoading(),
        const AuthError('Email already exists'),
      ],
    );
  });

  group('LogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [Unauthenticated] on logout',
      build: () {
        when(() => mockAuthRepository.logout())
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [const Unauthenticated()],
    );
  });

  group('CheckAuthStatus', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when user is logged in',
      build: () {
        when(() => mockAuthRepository.getProfile())
            .thenAnswer((_) async => const Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const CheckAuthStatus()),
      expect: () => [
        const AuthLoading(),
        const Authenticated(user: testUser, token: ''),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when no session',
      build: () {
        when(() => mockAuthRepository.getProfile())
            .thenAnswer((_) async => const Left(AuthFailure('Not authenticated')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const CheckAuthStatus()),
      expect: () => [
        const AuthLoading(),
        const Unauthenticated(),
      ],
    );
  });
}
