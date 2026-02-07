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

    // ===== PALETA (dark premium) =====
    const primario = Color(0xFF5E17EB);
    const secundario = Color(0xFF2576FB);
    const claro = Color(0xFF36BAFE);

    const bg = Color(0xFF070710);
    const bg2 = Color(0xFF0B0B12);

    const ink = Color(0xFFFFFFFF);
    final muted = Colors.white.withOpacity(.72);

    final w = MediaQuery.of(context).size.width;
    // “tercio del medio” + limites
    final maxW = (w * 0.34).clamp(340.0, 520.0);

    InputDecoration _inputDec({
      required String label,
      required String hint,
      required IconData icon,
      Widget? suffixIcon,
    }) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: muted, fontWeight: FontWeight.w700),
        hintStyle: TextStyle(color: muted.withOpacity(.9)),
        prefixIcon: Icon(icon, color: claro),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(.06),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primario.withOpacity(.75), width: 1.4),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // background suave (dark) com glow
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bg,
              Color.lerp(bg, secundario, .06)!,
              bg,
            ],
          ),
        ),
        child: Stack(
          children: [
            // glow decorativo
            Positioned(
              top: -120,
              left: -120,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primario.withOpacity(.18),
                ),
              ),
            ),
            Positioned(
              bottom: -140,
              right: -140,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: claro.withOpacity(.12),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxW),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 14),

                        // Logo (mantido)
                        HomeLogo(),
                        const SizedBox(height: 18),

                        // Card (login)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: bg2,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: Colors.white.withOpacity(.08),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.40),
                                blurRadius: 24,
                                offset: const Offset(0, 14),
                              ),
                              BoxShadow(
                                color: primario.withOpacity(.10),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Entrar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ink,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .2,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Email
                              TextFormField(
                                onChanged: (text) =>
                                    controller.user.value.email = text,
                                style: const TextStyle(
                                  color: ink,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                cursorColor: primario,
                                decoration: _inputDec(
                                  label: "E-mail",
                                  hint: "Digite seu email",
                                  icon: Icons.email,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Password (GetX mantido)
                              ObxValue(
                                (show) => TextFormField(
                                  onChanged: (text) =>
                                      controller.user.value.password = text,
                                  obscureText: !show.value,
                                  style: const TextStyle(
                                    color: ink,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  cursorColor: primario,
                                  decoration: _inputDec(
                                    label: "Senha",
                                    hint: "Digite sua senha",
                                    icon: Icons.password,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        show.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white.withOpacity(.70),
                                      ),
                                      onPressed: () => show.value = !show.value,
                                    ),
                                  ),
                                ),
                                false.obs,
                              ),

                              const SizedBox(height: 16),

                              // Botão
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primario,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: controller.login,
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: .2,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              GestureDetector(
                                child: Text(
                                  "Esqueceu sua senha?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.60),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          "Encerrar Contrato • Mobile",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.35),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
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
