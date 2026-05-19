import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;
  var isRememberMeChecked = false.obs;
  var isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  
  void toggleRememberMe(bool? value) {
    isRememberMeChecked.value = value ?? false;
  }
  
  void loginCheck() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      _showErrorSnackbar('Loi xac thuc', 'Vui long nhap dung dinh dang dia chi Email mau!');
      return;
    }
    if (password.isEmpty || password.length < 6) {
      _showErrorSnackbar('Loi xac thuc', 'mat khau bat buoc phai tu 6 ky tu tro len!');
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));

      if (email == "admin@gmail.com" && password == "123456") {
        Get.snackbar(
          'Thanh Cong',
          'Dang nhap vao he thong thanh cong!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 3),
        );
      } else {
        _showErrorSnackbar('That bai', 'Tai khoan hoac mat khau khong chinh xac tren he thong!');
      }
    } catch (e) {
      _showErrorSnackbar('Loi he thong', 'Da xay ra su co ket noi , vui long thu lai sau. ');
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title, message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.shade400,
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50.withOpacity(0.6),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade200.withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Icon(Icons.shopping_bag_outlined, size: 55, color: Colors.green.shade600),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Chao mung tro lai!',
                      style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dang nhap de tiep tuc quan ly he thong',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 40),

                    _buildInputField(
                      controller: controller.emailController,
                      hintText: 'Dia chi Email (admin@gmail.com)',
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    Obx(() => _buildInputField(
                      controller: controller.passwordController,
                      hintText: 'Mat khau he thong (123456)',
                      prefixIcon: Icons.lock_open_rounded,
                      obscureText: controller.isPasswordHidden.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        onPressed: () => controller.togglePasswordVisibility(),
                      ),
                    )),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(() => SizedBox(
                              width: 24,
                              child: Checkbox(
                                activeColor: Colors.green.shade600,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                value: controller.isRememberMeChecked.value,
                                onChanged: (value) => controller.toggleRememberMe(value),
                              ),
                            )),
                            const SizedBox(width: 6),
                            Text('Ghi nho dang nhap', style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(foregroundColor: Colors.green.shade700),
                          child: Text('Quen mat khau?', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          elevation: 4,
                          shadowColor: Colors.green.shade200,
                        ),
                        onPressed: controller.isLoading.value ? null : () => controller.loginCheck(),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : Text(
                                'Dang nhap he thong',
                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 14.5, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon, color: Colors.green.shade600, size: 20),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13.5),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        ),
      ),
    );
  }
}