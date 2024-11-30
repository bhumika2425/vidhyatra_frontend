import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vidhyatra_flutter/screens/password_reset_page.dart';

class EnterOTPPage extends StatefulWidget {
  final String email;

  EnterOTPPage({required this.email});

  @override
  _EnterOTPPageState createState() => _EnterOTPPageState();
}

class _EnterOTPPageState extends State<EnterOTPPage> {
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;
  String? _errorMessage;
  final FocusNode _focusNode = FocusNode();
  Timer? _timer;
  int _remainingSeconds = 100;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startResendOTPTimer();
  }

  void _startResendOTPTimer() {
    setState(() {
      _isResendEnabled = false;
      _remainingSeconds = 100;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String otp = '';
    bool allFilled = true;

    for (var controller in _otpControllers) {
      if (controller.text.isEmpty) {
        allFilled = false;
        break;
      }
      otp += controller.text;
    }

    if (!allFilled || otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid 6-digit numeric OTP';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3001/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': widget.email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(email: widget.email),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        setState(() {
          _errorMessage = responseData['message'] ?? 'Invalid OTP';
        });
      }
    } catch (error) {
      print('Error verifying OTP: $error');
      setState(() {
        _errorMessage = 'Failed to verify OTP. Please check your internet connection.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Widget _otpField(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(2, 2),
          ),
        ],
        border: Border.all(color: Colors.deepOrange, width: 1.5),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: index == 0 ? _focusNode : null,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify OTP',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_open, size: 60, color: Colors.deepOrange),
              const SizedBox(height: 16),
              const Text(
                'Verification Required',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                'Please enter the 6-digit code sent to ${widget.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) => _otpField(index)),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Verify OTP',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _isResendEnabled
                    ? () {
                  _startResendOTPTimer();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('OTP resent to your email!')),
                  );
                }
                    : null,
                child: _isResendEnabled
                    ? const Text(
                  'Resend OTP',
                  style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                )
                    : RichText(
                  text: TextSpan(
                    text: 'Resend OTP in ',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    children: [
                      TextSpan(
                        text: '$_remainingSeconds sec',
                        style: const TextStyle(fontSize: 16, color: Colors.deepOrange),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Didn’t receive the code? Please wait a few seconds before requesting again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}