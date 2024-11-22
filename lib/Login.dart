import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'main.dart';

class LoginPage extends StatefulWidget
{
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
{@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Login Page'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true, // Hide password text
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
        ],
      ),
    ),
  );
}

  late TextEditingController _passwordController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with empty values or default values
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _login()
  {
    String email = _emailController.text;
    String password = _passwordController.text;
    final GlobalKey<FlutterPwValidatorState> validatorKey = GlobalKey<FlutterPwValidatorState>();
    {

      FlutterPwValidator
        (
        key: validatorKey,
        controller: _passwordController,
        minLength: 8,
        uppercaseCharCount: 2,
        lowercaseCharCount: 3,
        numericCharCount: 3,
        specialCharCount: 1,
        normalCharCount: 3,
        width: 400,
        height: 200,
        onSuccess: ()
        {
          print("MATCHED");
          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
              content: new Text("Password is matched")));
        },
        onFail: ()
        {
          print("NOT MATCHED");
        });


      // Validate the password


      // Return error messages if validation fails



    // Validate input (optional)
    if (email.isEmpty || password.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both email and password")),
      );
      return;

    }
    if (!EmailValidator.validate(email))
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }




    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logged in as $email")),
    );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(title: 'Hediaty')), // Replace LoginPage with HomePage
      );
  }


}


  }





















