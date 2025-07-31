import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:hamro_grocery_mobile/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String fullPhoneNumber = "";
  bool _isPasswordValid = true;
  bool _isEmailValid = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  void _signUp() {
    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty || email.isEmpty  || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar("Please fill in all fields", Colors.red);
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() => _isEmailValid = false);
      _showSnackBar("Please enter a valid email address", Colors.red);
      return;
    }

    if (password.length < 6) {
      setState(() => _isPasswordValid = false);
      _showSnackBar("Password should be at least 6 characters", Colors.red);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("Passwords do not match", Colors.red);
      return;
    }

   

    context.read<RegisterViewModel>().add(
          RegisterUserEvent(
            context: context,
            fullName: fullName,
            email: email,
            password: password,

          ),
        );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterViewModel, RegisterState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          FocusScope.of(context).unfocus();
        }
      },
      child: BlocBuilder<RegisterViewModel, RegisterState>(
        builder: (context, state) {
          final size = MediaQuery.of(context).size;
          final paddingH = size.width * 0.06;
          final spacing = size.height * 0.025;
          final imageHeight = size.height * 0.08;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: paddingH),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: spacing),
                                  _buildTopBar(imageHeight),
                                  SizedBox(height: spacing),
                                  _buildTitle(size),
                                  SizedBox(height: spacing * 1.2),
                                  _buildFormFields(spacing, size),
                                  SizedBox(height: spacing),
                                  _buildSignUpButton(size),
                                  SizedBox(height: spacing * 1.2),
                                  _buildSocialOptions(size),
                                  const Spacer(),
                                  _buildBottomPrompt(),
                                  SizedBox(height: spacing * 0.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(double imageHeight) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
        const Spacer(flex: 2),
        Image.asset('assets/hamro2.png', height: imageHeight),
        const Spacer(flex: 2),
      ],
    );
  }

  Widget _buildTitle(Size size) {
    final titleFontSize = size.width * 0.07;
    final subtitleFontSize = size.width * 0.042;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create Account", style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Text("Sign up to start your shopping journey", style: TextStyle(color: Colors.black54, fontSize: subtitleFontSize)),
      ],
    );
  }

  Widget _buildFormFields(double spacing, Size size) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          focusNode: _nameFocusNode,
          decoration: _inputDecoration("Full Name", Icons.person_outline),
        ),
        SizedBox(height: spacing),

        TextFormField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => setState(() => _isEmailValid = _isValidEmail(value)),
          decoration: _inputDecoration("Email Address", Icons.email_outlined).copyWith(
            errorText: _isEmailValid ? null : "Please enter a valid email",
          ),
        ),
        SizedBox(height: spacing),

        // IntlPhoneField(
        //   controller: _phoneController,
        //   initialCountryCode: 'NP',
        //   onChanged: (phone) {
        //     fullPhoneNumber = phone.completeNumber;
        //     setState(() => _isPhoneValid = phone.number.length >= 10);
        //   },
        //   decoration: _inputDecoration("Phone Number", Icons.phone_outlined),
        // ),
        // SizedBox(height: spacing),

        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          onChanged: (value) => setState(() => _isPasswordValid = value.length >= 6),
          decoration: _inputDecoration("Password", Icons.lock_outline).copyWith(
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            errorText: _isPasswordValid ? null : "Password must be at least 6 characters",
          ),
        ),
        SizedBox(height: spacing),

        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: _inputDecoration("Confirm Password", Icons.lock_outline).copyWith(
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            errorText: _confirmPasswordController.text != _passwordController.text
                ? "Passwords do not match"
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(Size size) {
    final subtitleFontSize = size.width * 0.042;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _signUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: subtitleFontSize),
        ),
        child: const Text("SIGN UP"),
      ),
    );
  }

  Widget _buildSocialOptions(Size size) {
    return Column(
      children: [
        Center(
          child: Text(
            "Or sign up with",
            style: TextStyle(color: Colors.black54, fontSize: size.width * 0.042),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.facebook, color: Colors.blue),
                label: const Text("Facebook", style: TextStyle(color: Colors.black87)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black26),
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.016),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Image.asset("assets/google.png", height: 20, width: 20),
                label: const Text("Google", style: TextStyle(color: Colors.black87)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black26),
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.016),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ", style: TextStyle(color: Colors.black54)),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Sign in here", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black87), borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(12)),
    );
  }
}
