import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encerrar_contrato/app/widgets/home_logo.dart';
import 'package:encerrar_contrato/app/controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.checkSession(),
    );
    return Scaffold(
      body: Container(
        color: Color(0xFF048FDF),
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomeLogo(),
                    TextFormField(
                      onChanged: (text) => controller.user.value.email = text,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Digite seu email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(height: 10),
                    ObxValue(
                      (show) => TextFormField(
                        onChanged: (text) =>
                            controller.user.value.password = text,
                        obscureText: !show.value,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: show.value
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () => show.value = !show.value,
                          ),
                          labelText: 'Password',
                          hintText: 'Digite sua senha',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      false.obs,
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0099FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.black, width: 1),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: controller.login,
                        child: Text('Login'),
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'Esqueceu sua senha?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
