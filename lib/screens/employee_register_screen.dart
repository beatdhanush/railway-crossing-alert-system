import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmployeeRegisterScreen extends StatefulWidget {
  const EmployeeRegisterScreen({super.key});

  @override
  State<EmployeeRegisterScreen> createState() =>
      _EmployeeRegisterScreenState();
}

class _EmployeeRegisterScreenState
    extends State<EmployeeRegisterScreen> {

  final nameController = TextEditingController();
  final employeeIdController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool passwordHidden = true;
  bool confirmHidden = true;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    employeeIdController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> registerEmployee() async {
    FocusScope.of(context).unfocus();

    if (nameController.text.trim().isEmpty ||
        employeeIdController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields.",
          ),
        ),
      );

      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Passwords do not match.",
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
          employeeIdController.text
              .trim()
              .toUpperCase();

      /// Check if employee already registered
      final registeredEmployee =
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(employeeId)
              .get();

      if (registeredEmployee.exists) {
        throw Exception(
          "Employee ID already registered.",
        );
      }

      /// Create Firebase Authentication account
      final authResult =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      /// Create Firestore employee document
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(employeeId)
          .set({

        'uid': authResult.user!.uid,

        'employeeId': employeeId,

        'name': nameController.text.trim(),

        'email': emailController.text.trim(),

        'role': 'employee',

        'approvalStatus': 'pending',

        'active': true,

        'selectedTracks': [],

        'createdAt':
            FieldValue.serverTimestamp(),
      });

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registration submitted for admin approval.",
            ),
          ),
        );

        Navigator.pop(context);
      }

    } on FirebaseAuthException catch (e) {

      String message =
          "Registration failed.";

      if (e.code ==
          'email-already-in-use') {

        message =
            "This email is already registered.";
      }

      else if (e.code ==
          'weak-password') {

        message =
            "Password should be at least 6 characters.";
      }

      else if (e.code ==
          'invalid-email') {

        message =
            "Invalid email address.";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );

    } catch (e) {

      String error =
          e.toString().replaceFirst(
                "Exception: ",
                "",
              );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {

    return TextField(
      controller: controller,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(icon),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
        ),
      ),
    );
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
                maxWidth: 500,
              ),

              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.92,
                ),

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
                    Icons.app_registration,
                    size: 70,
                    color: Color(0xFF003B8E),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Employee Registration",

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Your registration request will be sent to Admin for approval.",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  buildField(
                    controller: nameController,
                    label: "Full Name",
                    icon: Icons.person,
                  ),

                  const SizedBox(height: 15),

                  buildField(
                    controller:
                        employeeIdController,

                    label: "Employee ID",

                    icon: Icons.badge,
                  ),

                  const SizedBox(height: 15),

                  buildField(
                    controller: emailController,

                    label: "Official Email",

                    icon: Icons.email,
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller:
                        passwordController,

                    obscureText:
                        passwordHidden,

                    decoration:
                        InputDecoration(

                      labelText: "Password",

                      prefixIcon:
                          const Icon(
                        Icons.lock,
                      ),

                      suffixIcon:
                          IconButton(

                        icon: Icon(
                          passwordHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),

                        onPressed: () {
                          setState(() {
                            passwordHidden =
                                !passwordHidden;
                          });
                        },
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller:
                        confirmPasswordController,

                    obscureText:
                        confirmHidden,

                    decoration:
                        InputDecoration(

                      labelText:
                          "Confirm Password",

                      prefixIcon:
                          const Icon(
                        Icons.lock,
                      ),

                      suffixIcon:
                          IconButton(

                        icon: Icon(
                          confirmHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),

                        onPressed: () {
                          setState(() {
                            confirmHidden =
                                !confirmHidden;
                          });
                        },
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : registerEmployee,

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
                                  15),
                        ),
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Register",

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