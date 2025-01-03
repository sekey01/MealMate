import 'package:flutter/material.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mealmate/PaymentProvider/payment_provider.dart';
import 'package:provider/provider.dart';

import '../pages/navpages/index.dart';

class PaymentResult {
  final bool success;
  final String message;
  final String? reference;

  PaymentResult({
    required this.success,
    required this.message,
    this.reference,
  });
}

class PaystackPaymentProvider extends ChangeNotifier {
 final String _baseUrl = '${dotenv.env['PAYSTACK_BASE_URL']}';
  final String _secretKey = '${dotenv.env['PAYSTACK_SECRET_KEY']}';

  Future<PaymentResult> startPayment(BuildContext context,int amount,  String VendorID) async {
    try {
      final response = await _initializeTransaction(amount, VendorID);
      if (response.statusCode == 200) {
        print('Payment initialized: ${response.body}');
        final responseData = jsonDecode(response.body);
        final authorizationUrl = responseData['data']['authorization_url'];
        final reference = responseData['data']['reference'];

        // Launch the authorization URL
        await EasyLauncher.url(url: authorizationUrl);

        // Wait for a few seconds before verifying the transaction
        await Future.delayed(const Duration(seconds: 45));

        // Verify the transaction
        final result = await _verifyTransaction(reference);

        if (result.success) {
         //Provider.of<PaymentProvider>(context,listen: false).addMoneyToCourierAccount(context, VendorID, amount.toDouble(), '0553767177');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Index(),
            ),
          );
        }
        return result;
      } else {
        print('Payment initialization failed: ${response.body}');
        return PaymentResult(
          success: false,
          message: 'Payment initialization failed: ${response.body}',
        );
      }
    } catch (e) {
      print('Payment error: ${e.toString()}');
      return PaymentResult(
        success: false,
        message: 'Payment error: ${e.toString()}',

      );
    }
  }

  Future<http.Response> _initializeTransaction(int amount, VendorID) async {
    final url = Uri.parse('$_baseUrl/transaction/initialize');
    final headers = {
      'Authorization': 'Bearer $_secretKey',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'email': '$VendorID@mealmate.com',
      'amount': amount * 100,
      'currency': 'GHS',
      'reference': _generateReference(),
      'callback_url': 'myapp://payment-success',
      'mobile_money': {
        'phone': '0553767177',
        'provider': 'MTN',

      },
      //add my account id i.e ACCT_m4

    });

    return await http.post(url, headers: headers, body: body);
  }

  Future<PaymentResult> _verifyTransaction(String reference) async {
    final url = Uri.parse('$_baseUrl/transaction/verify/$reference');
    final headers = {
      'Authorization': 'Bearer $_secretKey',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final status = responseData['data']['status'];
        if (status == 'success') {
          return PaymentResult(
            success: true,
            message: 'Payment completed successfully!',
            reference: reference,
          );
        } else {
          return PaymentResult(
            success: false,
            message: 'Payment not successful. Status: $status',
            reference: reference,
          );
        }
      } else {
        return PaymentResult(
          success: false,
          message: 'Payment verification failed: ${response.body}',
          reference: reference,
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Verification error: ${e.toString()}',
        reference: reference,
      );
    }
  }

  String _generateReference() {
    return 'MealMate${DateTime.now().millisecondsSinceEpoch}';
  }
}