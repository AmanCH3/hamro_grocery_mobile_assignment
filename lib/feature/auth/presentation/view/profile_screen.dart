import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/common/shake_detector.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/profile_detail_screen.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/signin_page.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/profile_view_model/profile_state.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';

// --- 2. Convert to a StatefulWidget ---
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- 3. Declare an instance of the ShakeDetector ---
  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();
    // --- 4. Initialize and start the detector ---
    _shakeDetector = ShakeDetector(
      onPhoneShake: _handleShakeToLogout, // Set the callback function
    );
    _shakeDetector.startListening();
  }

  @override
  void dispose() {
    // --- 5. Stop the detector to prevent memory leaks ---
    _shakeDetector.stopListening();
    super.dispose();
  }

  // --- 6. Create the callback function to handle the shake event ---
  void _handleShakeToLogout() async {
    // Prevent triggering another logout if one is already in progress or the widget is gone.
    if (!mounted || context.read<ProfileViewModel>().state.isLoading) {
      return;
    }

    // This logic is identical to the button's onPressed logic.
    final bool? didConfirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text(
            'Are you sure you want to log out? (Triggered by shake)',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (didConfirm == true && mounted) {
      context.read<ProfileViewModel>().add(LogoutEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileViewModel, ProfileState>(
      listener: (context, state) {
        if (state.isLoggedOut) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            alignment: Alignment.center,
            child: BlocBuilder<ProfileViewModel, ProfileState>(
              builder: (context, state) {
                final user = state.authEntity;

                // The UI part remains the same
                return Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Hamro Grocery',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Hello, ${user?.fullName ?? 'User'}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'user@email.com',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    _ProfileMenuButton(
                      text: 'Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider.value(
                                  value: context.read<ProfileViewModel>(),
                                  child: const ProfileDetailScreen(),
                                ),
                          ),
                        );
                      },
                    ),
                    _ProfileMenuButton(
                      text: 'Delivery Address',
                      onPressed: () {},
                    ),
                    _ProfileMenuButton(
                      text: 'Support Center',
                      onPressed: () {},
                    ),
                    _ProfileMenuButton(text: 'Legal Policy', onPressed: () {}),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state.isLoading
                                ? null
                                : () async {
                                  final bool?
                                  didConfirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: const Text('Confirm Logout'),
                                        content: const Text(
                                          'Are you sure you want to log out?',
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed:
                                                () => Navigator.of(
                                                  dialogContext,
                                                ).pop(false),
                                          ),
                                          TextButton(
                                            child: const Text(
                                              'Logout',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            onPressed:
                                                () => Navigator.of(
                                                  dialogContext,
                                                ).pop(true),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (didConfirm == true && mounted) {
                                    context.read<ProfileViewModel>().add(
                                      LogoutEvent(),
                                    );
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9534F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            state.isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                                : const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _ProfileMenuButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
