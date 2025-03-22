import 'package:flutter/material.dart';


class TryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vidhyatra App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white, // White background for the upper part
          image: DecorationImage(
            image: NetworkImage(
              'https://www.transparenttextures.com/patterns/clean-gray-paper.png', // Subtle paper texture
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            // Upper Section with Branding
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF971F20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.school, // College-themed icon
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Vidhyatra",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF971F20),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Your College Companion",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Lower Section with Red-Blended Card
            Container(
              height: MediaQuery.of(context).size.height * 0.65, // Adjust height to cover form
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF971F20).withOpacity(0.9), // Deep red with opacity
                    Color(0xFF5A1213).withOpacity(0.9), // Darker red shade
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 35),
                      // Welcome Text
                      Text(
                        "Login to Continue",
                        style: TextStyle(
                          fontSize: 28,
                          // fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 30),
                      // Email Field
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: Colors.white70),
                          hintText: 'johnwilliams@gmail.com',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      // Password Field
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white70),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: Colors.white54,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      // Remember Me Checkbox and Forgot Password Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: null, // No logic, just UI
                                activeColor: Colors.white,
                                checkColor: Color(0xFF971F20),
                              ),
                              Text(
                                "Remember me",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {}, // No logic, just UI
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Login Button
                      ElevatedButton(
                        onPressed: () {}, // No logic, just UI
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // White button
                          foregroundColor: Color(0xFF971F20), // Red text
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          GestureDetector(
                            onTap: () {}, // No logic, just UI
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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