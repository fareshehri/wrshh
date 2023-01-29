import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wrshh/Services/Auth/auth.dart';

import '../../components/roundedButton.dart';
import '../../components/validators.dart';
import '../../constants.dart';
import '../client/Home.dart';
import '../workshopAdmin/workshopAdmin_Home.dart';
import '../workshopTechnician/technician_home.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool showSpinner = false;
  late String email;
  late String password;

  var gap = const SizedBox(height: 8.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(size: 24),
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: kDarkColor, size: 24),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('assets/images/Logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your email',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email)),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  validator: emailValidator,
                ),
                gap,
                TextFormField(
                  decoration: kTextFieldDecoratopn.copyWith(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  validator: passwordValidator,
                ),
                gap,
                RoundedButton(
                  title: 'Log In',
                  colour: kLightColor,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        showSpinner = true;
                      });

                      try {
                        final newUser = await AuthService().signInUser(email, password);
                        if (newUser?.user?.email != null){
                          var userType = await AuthService().getUserType(newUser?.user!.email!);
                          if (userType == 'ClientUser'){
                            Navigator.pushNamed(context, Home.id);
                          } else if (userType == 'workshopAdmin'){
                            Navigator.pushNamed(context, WorkshopAdminHome.id);
                          } else if (userType == 'workshopTechnician'){
                            print('technician');
                            Navigator.pushNamed(context, WorkshopTechnicianHome.id);
                          // } else if (userType == 'AdminUser'){
                          //   Navigator.pushNamed(context, AHome.id);
                          } else {
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Email or password is incorrect')),
                        );
                      } finally {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
