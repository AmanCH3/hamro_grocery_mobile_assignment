import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// IMPORT YOUR API CONSTANTS
import 'package:hamro_grocery_mobile/app/constant/api_endpoints.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/profile_view_model/profile_state.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileViewModel, ProfileState>(
      builder: (context, state) {
        // Don't show banner if user data is not loaded or loading
        if (state.isLoading || state.authEntity == null) {
          return const SizedBox.shrink();
        }

        final user = state.authEntity!;
        final displayName = _getDisplayName(user.fullName);

        ImageProvider? profileImage;

        // 1. Check for a newly picked local image first.
        if (state.newProfileImageFile != null) {
          profileImage = FileImage(state.newProfileImageFile!);
        }
        // 2. If no local image, check for an existing network image.
        else if (user.profilePicture?.isNotEmpty == true) {
          // ======================= THE FIX IS HERE =======================
          final combinedUrl = ApiEndpoints.baseUrl + user.profilePicture!;

          // First, replace all double slashes. This might break "http://".
          var fullImageUrl = combinedUrl.replaceAll('//', '/');

          // Now, specifically fix the protocol if it was broken.
          if (fullImageUrl.startsWith("http:/")) {
            fullImageUrl = fullImageUrl.replaceFirst("http:/", "http://");
          } else if (fullImageUrl.startsWith("https:/")) {
            fullImageUrl = fullImageUrl.replaceFirst("https:/", "https://");
          }

          profileImage = NetworkImage(fullImageUrl);
          // ===============================================================
        }

        return Container(
          margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              // Profile avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child:
                    profileImage != null
                        ? ClipOval(
                          child: Image(
                            image: profileImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint("Image Error in Banner: $error");
                              return _buildInitialsAvatar(displayName);
                            },
                          ),
                        )
                        : _buildInitialsAvatar(displayName),
              ),

              const SizedBox(width: 16),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Hello, ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          TextSpan(
                            text: displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (user.location != null && user.location!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.grey.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              user.location!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade200, width: 1),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDisplayName(String fullName) {
    if (fullName.isEmpty) return 'User';

    final nameParts = fullName.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts.first;
    } else if (nameParts.length >= 2) {
      return '${nameParts.first} ${nameParts.last}';
    }
    return nameParts.first;
  }

  Widget _buildInitialsAvatar(String displayName) {
    String initials = '';
    final nameParts = _getDisplayName(displayName).split(' ');

    if (nameParts.isNotEmpty && nameParts.first.isNotEmpty) {
      initials = nameParts[0][0].toUpperCase();
      if (nameParts.length > 1 && nameParts.last.isNotEmpty) {
        initials += nameParts.last[0].toUpperCase();
      }
    } else {
      initials = 'U';
    }

    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
