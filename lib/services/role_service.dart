class RoleService {
  RoleService._();

  /// Detect role based on ID prefix
  static String? detectRole(String userId) {
    final id = userId.trim().toUpperCase();

    if (id.startsWith('EMP')) {
      return 'employee';
    }

    if (id.startsWith('OP')) {
      return 'operator';
    }

    if (id.startsWith('ADM')) {
      return 'admin';
    }

    return null;
  }

  /// Check if Employee ID
  static bool isEmployee(String userId) {
    return detectRole(userId) == 'employee';
  }

  /// Check if Operator ID
  static bool isOperator(String userId) {
    return detectRole(userId) == 'operator';
  }

  /// Check if Admin ID
  static bool isAdmin(String userId) {
    return detectRole(userId) == 'admin';
  }

  /// Convert role to display text
  static String roleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'employee':
        return 'Employee';

      case 'operator':
        return 'Operator';

      case 'admin':
        return 'Administrator';

      default:
        return 'Unknown';
    }
  }
}