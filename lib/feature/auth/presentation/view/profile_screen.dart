// lib/feature/auth/presentation/view/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/common/shake_detector.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/profile_detail_screen.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view/signin_page.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/profile_view_model/profile_state.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';

// Assuming ServicePage is in this location, adjust if necessary
// import 'package:hamro_grocery_mobile/view/auth/dashboard/service_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector(onPhoneShake: _handleShakeToLogout);
    _shakeDetector.startListening();
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  void _handleShakeToLogout() async {
    if (!mounted || context.read<ProfileViewModel>().state.isLoading) return;
    final bool? didConfirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
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
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
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
                ImageProvider? profileImage;
                if (state.newProfileImageFile != null) {
                  profileImage = FileImage(state.newProfileImageFile!);
                } else if (user?.profilePicture?.isNotEmpty == true) {
                  final combinedUrl =
                      ApiEndpoints.baseUrl + user!.profilePicture!;
                  final fullImageUrl = combinedUrl.replaceAll('//', '/');
                  profileImage = NetworkImage(fullImageUrl);
                }

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
                    // =================== CORRECTED CODE BLOCK ===================
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFE0E0E0),
                      backgroundImage: profileImage,
                      // Conditionally provide the error handler only if an image exists
                      onBackgroundImageError: profileImage != null
                          ? (exception, stackTrace) {
                        debugPrint(
                            "Error loading profile image: $exception");
                      }
                          : null,
                      child: profileImage == null
                          ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      )
                          : null,
                    ),
                    // ==========================================================
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
                            builder: (_) => BlocProvider.value(
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
                        onPressed: state.isLoading
                            ? null
                            : () async {
                          final bool? didConfirm = await showDialog<bool>(
                            context: context,
                            builder: (
                                BuildContext dialogContext,
                                ) =>
                                AlertDialog(
                                  title: const Text('Confirm Logout'),
                                  content: const Text(
                                    'Are you sure you want to log out?',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () => Navigator.of(
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
                                      onPressed: () => Navigator.of(
                                        dialogContext,
                                      ).pop(true),
                                    ),
                                  ],
                                ),
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
                        child: state.isLoading
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