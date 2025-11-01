import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:encerrar_contrato/app/models/pix_model.dart';

import '../models/credit_card_response.dart';

class PaymentService {
  final Dio dio;
  PaymentService(this.dio);
  Future<AsaaspaymentResponse> processCreditCardPayment({
    required  solicitationId, required Map<String, dynamic> data
  }) async {
    var response = await dio.post('/payments/credit-card/${solicitationId}', data: json.encode(data));
    if(response.statusCode == 201 || response.statusCode == 200) {
      return AsaaspaymentResponse.fromJson(response.data);
    }
    throw Exception("Some err occurred while trying to process payment");
  }

  Future<PIXResponse> processPIXPayment({required solicitationId}) async {
    var response = await dio.post('/payments/pix/${solicitationId}');
    if(response.statusCode == 201 || response.statusCode == 200) {
      return PIXResponse.fromJson(response.data);
    }
    throw Exception("Some err occurred while trying to process payment");
  }
}