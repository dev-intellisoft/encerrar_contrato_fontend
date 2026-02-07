import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_pages.dart';
import '../models/agency_model.dart';
import '../widgets/logo.dart'; // ✅ para usar Logo() en el header del drawer

Future<Agency> whoAmI() async {
  Agency agency = Agency();
  var user = await GetStorage().read('user');
  if (user != null) {
    agency = Agency.fromJson(user);
  }
  return agency;
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  // ===== PALETA =====
  static const primario = Color(0xFF5E17EB);
  static const claro = Color(0xFF36BAFE);
  static const bg = Color(0xFF070710);
  static const bg2 = Color(0xFF0B0B12);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bg,
      child: FutureBuilder<Agency>(
        future: whoAmI(),
        builder: (context, AsyncSnapshot<Agency> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: primario),
            );
          }

          final agency = snapshot.data!;

          return Column(
            children: [
              // ================= HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
                decoration: BoxDecoration(
                  color: bg2,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(.08),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ LOGO ENCERRAR (reemplaza el icono edificio)
                    Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primario.withOpacity(.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: primario.withOpacity(.35),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Logo(),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      agency.name ?? "Encerrar Contrato",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      agency.login ?? "",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.65),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // ================= MENU =================
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    if (agency.agency == "encerrar")
                      _DrawerItem(
                        icon: Icons.apartment_outlined,
                        label: "Imobiliárias",
                        onTap: () {
                          Get.offNamed(Routes.AGENCIES);
                          Get.back();
                        },
                      ),
                    if (agency.agency == "encerrar")
                      _DrawerItem(
                        icon: Icons.miscellaneous_services_outlined,
                        label: "Serviços",
                        onTap: () {
                          Get.offNamed(Routes.SERVICES);
                          Get.back();
                        },
                      ),

                    const SizedBox(height: 10),

                    Divider(
                      color: Colors.white.withOpacity(.08),
                      indent: 16,
                      endIndent: 16,
                    ),

                    _DrawerItem(
                      icon: Icons.logout_rounded,
                      label: "Logout",
                      danger: true,
                      onTap: () {
                        GetStorage().remove('token');
                        Get.offAllNamed(Routes.LOGIN);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// =====================================================
// Drawer Item premium
// =====================================================
class _DrawerItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool _hover = false;
  bool _down = false;

  static const primario = Color(0xFF5E17EB);

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.danger ? Colors.redAccent : primario;

    final Color bg = _down
        ? accent.withOpacity(.20)
        : _hover
            ? accent.withOpacity(.12)
            : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _down = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.danger
                    ? Colors.redAccent
                    : Colors.white.withOpacity(.90),
              ),
              const SizedBox(width: 14),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.danger
                      ? Colors.redAccent
                      : Colors.white.withOpacity(.90),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
