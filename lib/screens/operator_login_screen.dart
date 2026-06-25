import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'forgot_password_screen.dart';
import 'operator_dashboard_screen.dart';
import 'operator_notification_screen.dart';

class OperatorLoginScreen extends StatefulWidget {
  const OperatorLoginScreen({super.key});

  @override
  State<OperatorLoginScreen> createState() =>
      _OperatorLoginScreenState();
}

class _OperatorLoginScreenState
    extends State<OperatorLoginScreen> {

  final operatorIdController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    operatorIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginOperator() async {

    FocusScope.of(context).unfocus();

    if (operatorIdController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter Operator ID and Password.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final operatorId =
          operatorIdController.text.trim();

      final operatorDoc =
          await FirebaseFirestore.instance
              .collection('operators')
              .doc(operatorId)
              .get();

      if (!operatorDoc.exists) {

        throw Exception(
          'Operator account not found.',
        );
      }

      final operatorData =
          operatorDoc.data()!;

      if (operatorData['active'] != true) {

        throw Exception(
          'Operator account is inactive.',
        );
      }

      final email =
          operatorData['email'];

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(

        email: email,

        password:
            passwordController.text,
      );
            if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OperatorDashboardScreen(
            operatorId: operatorId,
          ),
        ),
      );

    } on FirebaseAuthException catch (e) {

      String message = 'Login failed.';

      if (e.code == 'wrong-password') {

        message = 'Incorrect password.';

      } else if (e.code == 'user-not-found') {

        message = 'User not found.';

      } else if (e.code == 'invalid-credential') {

        message = 'Invalid credentials.';
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

                borderRadius:
                    BorderRadius.circular(30),

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

                    alignment:
                        Alignment.centerLeft,

                    child: IconButton(

                      icon: const Icon(
                        Icons.arrow_back,
                      ),

                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const Icon(

                    Icons.admin_panel_settings,

                    size: 70,

                    color: Color(0xFF003B8E),
                  ),

                  const SizedBox(height: 15),

                  const Text(

                    "Operator Login",

                    style: TextStyle(

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(

                    "Login to manage crossings",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 35),

                  TextField(

                    controller:
                        operatorIdController,

                    decoration: InputDecoration(

                      labelText: "Operator ID",

                      hintText:
                          "Enter Operator ID",

                      prefixIcon:
                          const Icon(
                        Icons.badge,
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(

                    controller:
                        passwordController,

                    obscureText:
                        obscurePassword,

                    decoration: InputDecoration(

                      labelText: "Password",

                      hintText:
                          "Enter Password",

                      prefixIcon:
                          const Icon(
                        Icons.lock,
                      ),

                      suffixIcon:
                          IconButton(

                        icon: Icon(

                          obscurePassword

                              ? Icons.visibility

                              : Icons
                                  .visibility_off,
                        ),

                        onPressed: () {

                          setState(() {

                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(

                    alignment:
                        Alignment.centerRight,

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
                          isLoading
                              ? null
                              : loginOperator,

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            const Color(
                          0xFF003B8E,
                        ),

                        foregroundColor:
                            Colors.white,

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}