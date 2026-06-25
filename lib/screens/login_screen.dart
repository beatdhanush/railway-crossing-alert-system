import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'employee_home_screen.dart';
import 'admin_dashboard_screen.dart';
import 'employee_register_screen.dart';
import 'operator_home_screen.dart';
import '../services/fcm_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final _userIdController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  bool _isLoading = false;

  bool _obscurePassword = true;

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF001F54),
              Color(0xFF003B8E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(30),

              child: Column(
                children: [

                  const Icon(
                    Icons.train,
                    color: Colors.white,
                    size: 90,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Railway Crossing\nAlert System",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Universal Login",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 50),

                  TextField(
                    controller:
                        _userIdController,

                    textCapitalization:
                        TextCapitalization
                            .characters,

                    decoration:
                        InputDecoration(
                      filled: true,
                      fillColor:
                          Colors.white,

                      hintText:
                          "Employee / Operator / Admin ID",

                      prefixIcon:
                          const Icon(
                        Icons.person,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller:
                        _passwordController,

                    obscureText:
                        _obscurePassword,

                    decoration:
                        InputDecoration(
                      filled: true,
                      fillColor:
                          Colors.white,

                      hintText:
                          "Password",

                      prefixIcon:
                          const Icon(
                        Icons.lock,
                      ),

                      suffixIcon:
                          IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons
                                  .visibility
                              : Icons
                                  .visibility_off,
                        ),

                        onPressed: () {
                          setState(() {
                            _obscurePassword =
                                !_obscurePassword;
                          });
                        },
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment:
                        Alignment.centerRight,

                    child: TextButton(
                      onPressed: () {

                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Forgot Password coming next",
                            ),
                          ),
                        );
                      },

                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color:
                              Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                                    SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _login,

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white,

                        foregroundColor:
                            const Color(
                          0xFF003B8E,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(16),
                        ),
                      ),

                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const EmployeeRegisterScreen(),
      ),
    );
  },

  child: const Text(
    "New Employee? Register Here",
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {

    final userId =
        _userIdController.text
            .trim()
            .toUpperCase();

    final password =
        _passwordController.text
            .trim();

    if (userId.isEmpty ||
        password.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter User ID and Password.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      final result =
          await AuthService.instance
              .login(
        userId: userId,
        password: password,
      );

      final role =
    result['role'];

debugPrint("====== LOGIN DEBUG ======");
debugPrint("USER ID: $userId");
debugPrint("ROLE: $role");
debugPrint("=========================");
print('CALLING FCM SERVICE');

await FCMService.saveToken();

print('FCM SERVICE COMPLETED');
      if (!mounted) return;

      if (role == 'employee') {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EmployeeHomeScreen(
              employeeId: userId,
            ),
          ),
        );
      }

      else if (role ==
          'operator') {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OperatorHomeScreen(
  operatorId: userId,
)
          ),
        );
      }

      else if (role == 'admin') {

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) =>
          AdminDashboardScreen(
        adminId: userId,
      ),
    ),
  );
}
    }

    catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(e.toString()),
        ),
      );
    }

    finally {

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}