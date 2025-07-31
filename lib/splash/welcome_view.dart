import 'package:flutter/material.dart';
import 'package:hamro_grocery_mobile/app/shared_pref/token_shared_pref.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/usecase/check_auth_usecase.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/signin_page.dart';
import 'package:hamro_grocery_mobile/state/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the DashboardScreen

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    try {
      // 1. Get the SharedPreferences instance FIRST. This is an async operation.
      final prefs = await SharedPreferences.getInstance();

      // 2. Now that you have the instance, initialize your dependencies correctly.
      final tokenSharedPrefs = TokenSharedPrefs(sharedPreferences: prefs);
      final checkAuthStatusUseCase = CheckAuthStatusUseCase(
        tokenSharedPrefs: tokenSharedPrefs,
      );

      // 3. Call the use case to get the result
      final result = await checkAuthStatusUseCase();

      // Before navigating, check if the widget is still mounted
      if (!mounted) return;

      result.fold(
        (failure) {
          debugPrint("Error checking auth status: $failure");
        },
        (token) {
          if (token != null && token.isNotEmpty) {
            // If a token exists, navigate to the Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          }
          // If token is null or empty, do nothing. The user will see the WelcomeView UI.
        },
      );
    } catch (e) {
      // Catch any other potential errors during initialization
      debugPrint("Failed to initialize SharedPreferences: $e");
    }
  }
  // --- END NEW ---

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset("assets/welcom_bg.png", fit: BoxFit.cover),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: media.width * (isTablet ? 0.15 : 0.08),
                      right: media.width * (isTablet ? 0.15 : 0.08),
                      bottom: media.height * (isTablet ? 0.08 : 0.06),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // This button is now for users without a token
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: media.height * (isTablet ? 0.03 : 0.018),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: media.width * (isTablet ? 0.035 : 0.045),
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
