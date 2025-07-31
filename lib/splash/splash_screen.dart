import 'package:flutter/material.dart';
import "package:hamro_grocery_mobile/splash/welcome_view.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _startApp(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeView()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _startApp(context);

    final media = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/bg.jpg",
                fit: BoxFit.cover,
              ),
            ),

            Container(
              color: Colors.black.withOpacity(0.5),
            ),

            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 2),
                curve: Curves.easeIn,
                builder: (context, opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: child,
                  );
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: media.width * 0.08),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: media.width * 0.5,
                            maxHeight: media.width * 0.5,
                          ),
                          child: Image.asset(
                            "assets/hamro2.png",
                            fit: BoxFit.contain,
                          ),
                        ),

                        SizedBox(height: media.height * 0.04),

                        Text(
                          "Your online grocery app\nwhere you can find everything you need.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: media.width * 0.045,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),

                        SizedBox(height: media.height * 0.05),
                        
                        const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),

                        SizedBox(height: media.height * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
