// feature/auth/presentation/view/profile_detail_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/auth/domain/entity/auth_entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hamro_grocery_mobile/common/null_safety_utils.dart';
import 'package:hamro_grocery_mobile/common/profile_utils.dart';
import '../view_model/profile_view_model/profile_event.dart';
import '../view_model/profile_view_model/profile_state.dart';
import '../view_model/profile_view_model/profile_view_model.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      context.read<ProfileViewModel>().add(
        ProfileImagePickedEvent(imageFile: File(image.path)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        actions: [
          BlocBuilder<ProfileViewModel, ProfileState>(
            builder: (context, state) {
              if (state.authEntity == null) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(state.isEditing ? Icons.save : Icons.edit),
                onPressed: () {
                  if (state.isEditing) {
                    if (_formKey.currentState!.validate()) {
                      final updatedEntity = ProfileUtils.createUpdateEntity(
                        currentEntity: state.authEntity!,
                        newFullName: _fullNameController.text,
                        newLocation: _locationController.text,
                      );
                      
                      // Debug logging
                      ProfileUtils.logEntity('Current Entity', state.authEntity!);
                      ProfileUtils.logEntity('Updated Entity', updatedEntity);
                      
                      context.read<ProfileViewModel>().add(
                        UpdateProfileEvent(authEntity: updatedEntity),
                      );
                    }
                  } else {
                    context.read<ProfileViewModel>().add(ToggleEditModeEvent());
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state.authEntity != null) {
            _fullNameController.text = state.authEntity!.fullName;
            _emailController.text = state.authEntity!.email;
            _locationController.text = state.authEntity!.location ?? '';
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<ProfileViewModel>().add(ClearMessageEvent());
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.authEntity == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.authEntity == null) {
            return Center(
              child: ElevatedButton(
                onPressed:
                    () => context.read<ProfileViewModel>().add(
                      LoadProfileEvent(),
                    ),
                child: const Text('Retry'),
              ),
            );
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Profile Picture Section
                      _buildProfileAvatar(state, context),
                      const SizedBox(height: 24),
                      // Other Fields
                      TextFormField(
                        controller: _fullNameController,
                        enabled: state.isEditing,
                        decoration: _inputDecoration('Full Name', Icons.person),
                        validator:
                            (v) => v!.isEmpty ? 'Full name is required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        enabled: false,
                        decoration: _inputDecoration(
                          'Email Address',
                          Icons.email,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        enabled: state.isEditing,
                        decoration: _inputDecoration(
                          'Location',
                          Icons.location_on,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: Key(NullSafetyUtils.intToString(state.authEntity!.grocerypoints)),
                        initialValue: NullSafetyUtils.intToString(state.authEntity!.grocerypoints),
                        enabled: false,
                        decoration: _inputDecoration(
                          'Grocery Points',
                          Icons.star,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              if (state.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(ProfileState state, BuildContext context) {
    ImageProvider? backgroundImage;
    if (state.newProfileImageFile != null) {
      backgroundImage = FileImage(state.newProfileImageFile!);
    } else if (NullSafetyUtils.isNotNullOrEmpty(state.authEntity?.profilePicture)) {
      backgroundImage = NetworkImage(state.authEntity!.profilePicture!);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: backgroundImage,
          child:
              backgroundImage == null
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
        ),
        if (state.isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                onPressed: () => _pickImage(context),
              ),
            ),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      filled: true,
      fillColor: Colors.black.withOpacity(0.05),
    );
  }
}
