import 'package:flutter/material.dart';

class ForgotPasswordScreen
    extends StatelessWidget {

  const ForgotPasswordScreen({super.key});

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
                color: Colors.white.withOpacity(0.92),

                borderRadius:
                    BorderRadius.circular(30),
              ),

              child: Column(
                children: [

                  Align(
                    alignment: Alignment.centerLeft,

                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back),

                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const Icon(
                    Icons.lock_reset,
                    size: 70,
                    color: Color(0xFF003B8E),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Forgot Password",

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    decoration: InputDecoration(
                      labelText:
                          "Employee ID",

                      prefixIcon:
                          const Icon(Icons.badge),

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    decoration: InputDecoration(
                      labelText:
                          "Official Email",

                      prefixIcon:
                          const Icon(Icons.email),

                      border: OutlineInputBorder(
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
                      onPressed: () {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Reset Link Coming Next",
                            ),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF003B8E),

                        foregroundColor:
                            Colors.white,
                      ),

                      child: const Text(
                        "Send Reset Link",
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