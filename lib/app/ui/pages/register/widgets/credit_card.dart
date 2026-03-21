import 'package:encerrar_contrato/app/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditCard extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    // ===== PALETA (dark premium) =====
    const primario = Color(0xFF5E17EB);
    const claro = Color(0xFF36BAFE);
    const bgField = Color(0x1AFFFFFF);
    const ink = Color(0xFFFFFFFF);

    InputDecoration _dec({
      required String label,
      String? hint,
      IconData? icon,
    }) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: bgField,
        prefixIcon: icon != null ? Icon(icon, color: claro) : null,
        labelStyle: const TextStyle(color: ink, fontWeight: FontWeight.w700),
        hintStyle: TextStyle(color: Colors.white.withOpacity(.75)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(.18), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: primario.withOpacity(.90), width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.redAccent.withOpacity(.85),
            width: 1.3,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      );
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Dados do titular do cartão',
            style: TextStyle(
              color: Colors.white.withOpacity(.92),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              style: const TextStyle(color: ink, fontWeight: FontWeight.w600),
              onChanged: (text) => controller.creditCard.value.number = text,
              keyboardType: TextInputType.number,
              decoration: _dec(
                label: 'Número do cartão',
                hint: '0000 0000 0000 0000',
                icon: Icons.credit_card_rounded,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              style: const TextStyle(color: ink, fontWeight: FontWeight.w600),
              onChanged: (text) =>
                  controller.creditCard.value.holderName = text,
              decoration: _dec(
                label: 'Nome impresso no cartão',
                hint: 'Como está no cartão',
                icon: Icons.badge_outlined,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(
                      color: ink,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (text) =>
                        controller.creditCard.value.expiryMonth = text,
                    keyboardType: TextInputType.number,
                    decoration: _dec(
                      label: 'Mês',
                      hint: 'MM',
                      icon: Icons.date_range_outlined,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(
                      color: ink,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (text) =>
                        controller.creditCard.value.expiryYear = text,
                    keyboardType: TextInputType.number,
                    decoration: _dec(
                      label: 'Ano',
                      hint: 'AA',
                      icon: Icons.event_outlined,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(
                      color: ink,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (text) => controller.creditCard.value.ccv = text,
                    keyboardType: TextInputType.number,
                    decoration: _dec(
                      label: 'CVV',
                      hint: '123',
                      icon: Icons.lock_outline_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              style: const TextStyle(color: ink, fontWeight: FontWeight.w600),
              onChanged: (text) =>
                  controller.creditCardHolderInfo.value.name = text,
              decoration: _dec(
                label: 'Nome do titular',
                hint: 'Nome completo',
                icon: Icons.person_outline_rounded,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(
                      color: ink,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (text) =>
                        controller.creditCardHolderInfo.value.cpfCnpj = text,
                    keyboardType: TextInputType.number,
                    decoration: _dec(
                      label: 'CPF',
                      hint: '000.000.000-00',
                      icon: Icons.badge_outlined,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(
                      color: ink,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (text) =>
                        controller.creditCardHolderInfo.value.phone = text,
                    keyboardType: TextInputType.phone,
                    decoration: _dec(
                      label: 'Telefone',
                      hint: '(00) 00000-0000',
                      icon: Icons.phone_outlined,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              style: const TextStyle(color: ink, fontWeight: FontWeight.w600),
              onChanged: (text) =>
                  controller.creditCardHolderInfo.value.email = text,
              keyboardType: TextInputType.emailAddress,
              decoration: _dec(
                label: 'E-mail',
                hint: 'email@exemplo.com',
                icon: Icons.email_outlined,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(
                      color: ink,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (text) =>
                        controller.creditCardHolderInfo.value.postalCode = text,
                    keyboardType: TextInputType.number,
                    decoration: _dec(
                      label: 'CEP',
                      hint: '00.000-000',
                      icon: Icons.location_on_outlined,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    style: const TextStyle(
                      color: ink,
                      fontWeight: FontWeight.w600,
                    ),
                    onChanged: (text) =>
                        controller.creditCardHolderInfo.value.addressNumber =
                            text,
                    keyboardType: TextInputType.number,
                    decoration: _dec(
                      label: 'Número',
                      hint: 'Nº',
                      icon: Icons.numbers_outlined,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.processCreditCardPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0099FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Pagar',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
