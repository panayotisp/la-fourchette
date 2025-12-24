import 'package:equatable/equatable.dart';

/// User roles in the system
enum UserRole {
  employee,
  admin,
}

/// Authentication state
class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? userEmail;
  final String? userName;
  final String? userSurname;
  final UserRole? role;

  const AuthState({
    this.isAuthenticated = false,
    this.userEmail,
    this.userName,
    this.userSurname,
    this.role,
  });

  const AuthState.unauthenticated()
      : isAuthenticated = false,
        userEmail = null,
        userName = null,
        userSurname = null,
        role = null;

  AuthState copyWith({
    bool? isAuthenticated,
    String? userEmail,
    String? userName,
    String? userSurname,
    UserRole? role,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userSurname: userSurname ?? this.userSurname,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, userEmail, userName, userSurname, role];
}

/// Global auth state - simple mutable state for now
/// Future: Will be replaced with proper state management when SSO is implemented
class AuthService {
  static AuthState _currentState = const AuthState.unauthenticated();
  
  static AuthState get currentState => _currentState;
  
  static void setAuthState(AuthState newState) {
    _currentState = newState;
  }
  
  static void signOut() {
    _currentState = const AuthState.unauthenticated();
  }
}
