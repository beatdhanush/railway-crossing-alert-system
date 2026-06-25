import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'employee_home_screen.dart';
import 'employee_register_screen.dart';
import 'forgot_password_screen.dart';
import 'track_selection_screen.dart';
import '../services/theme_service.dart';
import '../services/fcm_service.dart';

class EmployeeLoginScreen extends StatefulWidget {
  const EmployeeLoginScreen({super.key});

  @override
  State<EmployeeLoginScreen> createState() =>
      _EmployeeLoginScreenState();
}

class _EmployeeLoginScreenState
    extends State<EmployeeLoginScreen> {

  final employeeIdController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    employeeIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginEmployee() async {

    FocusScope.of(context).unfocus();

    if (employeeIdController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter Employee ID and Password.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final employeeId =
          employeeIdController.text.trim();

      final employeeDoc =
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .get();

      if (!employeeDoc.exists) {
        throw Exception(
          'Employee account not found.',
        );
      }

      final employeeData =
          employeeDoc.data()!;

      if (employeeData['approvalStatus'] !=
          'approved') {

        throw Exception(
          'Your account is pending admin approval.',
        );
      }

      final email =
          employeeData['email'];

      await FirebaseAuth.instance
    .signInWithEmailAndPassword(
  email: email,
  password: passwordController.text,
);

print('CALLING FCM SERVICE');

await FCMService.saveToken();

print('FCM SERVICE COMPLETED');

      final selectedTracks =
          List<String>.from(
        employeeData['selectedTracks'] ?? [],
      );

      if (!mounted) return;

      await ThemeService.instance
    .loadEmployeeTheme(employeeId);

      if (selectedTracks.isEmpty) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TrackSelectionScreen(
              employeeId: employeeId,
            ),
          ),
        );

      } else {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EmployeeHomeScreen(
              employeeId: employeeId,
            ),
          ),
        );
      }

    } on FirebaseAuthException catch (e) {

      String message =
          'Login failed.';

      if (e.code == 'wrong-password') {

        message =
            'Incorrect password.';

      } else if (e.code ==
          'user-not-found') {

        message =
            'User not found.';

      } else if (e.code ==
          'invalid-credential') {

        message =
            'Invalid credentials.';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );

    } catch (e) {

      final error =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {
          isLoading = false;
        });
      }
    }
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const Icon(
                    Icons.person,
                    size: 70,
                    color: Color(0xFF003B8E),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Employee Login",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Login to receive crossing alerts",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 35),

                  TextField(
                    controller: employeeIdController,
                    decoration: InputDecoration(
                      labelText: "Employee ID",
                      hintText: "Enter Employee ID",
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : loginEmployee,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF003B8E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      const Text(
                        "Don't have an account?",
                      ),

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
                          "Register",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}