import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:wrshh/Services/Auth/auth.dart';
import 'package:wrshh/Services/Auth/client_database.dart';
import '../../components/validators.dart';
import '../../constants.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({Key? key}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var gap = const SizedBox(height: 8.0);
  late String oldName;
  late String oldEmail;
  late String oldPhoneNumber;
  late String oldCity;
  late final String serial;
  late String oldPassword;
  bool passwordEntered = false;
  bool nameChanged = false;
  bool emailChanged = false;
  bool phoneNumberChanged = false;
  bool cityChanged = false;
  late String newName;
  late String newEmail;
  late String newPhoneNumber;
  late String newCity;
  late String newPassword;
  bool gotPath = false;

  Future _getData() async {
    final User? user = _auth.currentUser;
    final client = await getClientInfo(user!.email.toString());
    setState(() {
      oldName = client['name'];
      oldEmail = user.email!;
      oldPhoneNumber = client['phoneNumber'].replaceAll('+966', '');
      newPhoneNumber = oldPhoneNumber;
      oldCity = client['city'];
      serial = client['serial'];
      gotPath = true;
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    if (!gotPath) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Account'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.lightBlue[300], size: 24),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              gap,
              TextFormField(
                decoration: kTextFieldDecoratopn.copyWith(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                initialValue: oldEmail,
                onChanged: (value) {
                  newEmail = value;
                  emailChanged = true;
                },
                validator: emailValidator,
              ),
              gap,
              TextFormField(
                decoration: kTextFieldDecoratopn.copyWith(
                    hintText: 'Enter your name',
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person)),
                textAlign: TextAlign.center,
                initialValue: oldName,
                onChanged: (value) {
                  newName = value;
                  nameChanged = true;
                },
                validator: nameValidator,
              ),
              gap,
              IntlPhoneField(
                decoration: kTextFieldDecoratopn.copyWith(
                    hintText: 'Enter your phone number',
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone)),
                countries: const ['SA'],
                initialCountryCode: 'SA',
                initialValue: oldPhoneNumber,
                onChanged: (phone) {
                  newPhoneNumber = phone.completeNumber;
                  phoneNumberChanged = true;
                },
              ),
              gap,
              TextFormField(
                decoration: kTextFieldDecoratopn.copyWith(
                    hintText: 'Enter your city',
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city)),
                textAlign: TextAlign.center,
                enabled: false,
                initialValue: oldCity,
                onChanged: (value) {
                  newCity = value;
                  cityChanged = true;
                },
              ),
              gap,
              TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title:
                              const Center(child: Text('Enter your password')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                  "Are you sure you want to Update your password?"),
                              gap,
                              const Text(
                                  "If yes then re-enter your password to confirm",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12)),
                              gap,
                              TextFormField(
                                decoration: kTextFieldDecoratopn.copyWith(
                                    hintText: 'Enter your password',
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.lock)),
                                textAlign: TextAlign.center,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                validator: passwordValidator,
                                onChanged: (value) {
                                  oldPassword = value;
                                },
                              ),
                              gap,
                              TextFormField(
                                decoration: kTextFieldDecoratopn.copyWith(
                                    hintText: 'Enter new password',
                                    labelText: 'New Password',
                                    prefixIcon: Icon(Icons.lock)),
                                textAlign: TextAlign.center,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                validator: passwordValidator,
                                onChanged: (value) {
                                  newPassword = value;
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: const Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                                onPressed: updatePassword,
                                child: const Text("Yes")),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Change Password')),
              ElevatedButton.icon(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    if (emailChanged || nameChanged || phoneNumberChanged) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(
                                child: Text('Enter your password')),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                    "Are you sure you want to Update your information's?"),
                                gap,
                                const Text(
                                    "If yes then re-enter your password to confirm",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12)),
                                gap,
                                TextFormField(
                                  decoration: kTextFieldDecoratopn.copyWith(
                                      hintText: 'Enter your password',
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock)),
                                  textAlign: TextAlign.center,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  obscureText: true,
                                  validator: passwordValidator,
                                  onChanged: (value) {
                                    oldPassword = value;
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: const Text("No"),
                                onPressed: () {
                                  newEmail = oldEmail;
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                  onPressed: updateAccountInfo,
                                  child: const Text("Yes")),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                icon: const Icon(
                  Icons.save_as,
                ),
                label: const Text('Edit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updatePassword() async {
    UserCredential? userCredential;
    try {
      userCredential = await AuthService().signInUser(oldEmail, oldPassword);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Center(
                  child: Text(
                'Password is incorrect',
                style: TextStyle(color: Colors.red),
              )),
            );
          });
    }
    if (userCredential?.user?.email != null) {
      String result = await updateUserPassword(newPassword);
      if (result == 'success') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Center(
                    child: Text(
                  'Password updated successfully',
                  style: TextStyle(color: Colors.green),
                )),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Center(
                    child: Column(children: const [
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'Something went wrong',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]),
                  ));
            });
      }
    }
  }

  void updateAccountInfo() async {
    if (_formKey.currentState!.validate()) {
      late UserCredential? userCredential;
      try {
        userCredential = await AuthService().signInUser(oldEmail, oldPassword);
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Center(
                    child: Text(
                  'Password is incorrect',
                  style: TextStyle(color: Colors.red),
                )),
              );
            });
      }
      if (userCredential?.user?.email != null) {
        if (emailChanged) {
          Map data = {
            'email': oldEmail,
            'name': nameChanged ? newName : oldName,
            'phoneNumber': newPhoneNumber.toString().startsWith('+966')
                ? newPhoneNumber
                : '+966$newPhoneNumber',
            'city': cityChanged ? newCity : oldCity,
            'serial': serial
          };
          String result = await updateUserEmail(newEmail, data);
          if (result == 'success') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Center(
                        child: Column(children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 50,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Account updated successfully',
                            style: TextStyle(color: Colors.green),
                          ),
                        ]),
                      ));
                });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Center(
                        child: Column(children: const [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Something went wrong',
                            style: TextStyle(color: Colors.red),
                          ),
                        ]),
                      ));
                });
          }
        }
        if (nameChanged || phoneNumberChanged || cityChanged) {
          Map data = {
            'email': emailChanged ? newEmail : oldEmail,
            'phoneNumber': newPhoneNumber.startsWith('+966')
                ? newPhoneNumber
                : '+966$newPhoneNumber',
            'name': nameChanged ? newName : oldName,
            'city': cityChanged ? newCity : oldCity,
            'serial': serial,
          };
          String result = await updateUserInfo(data);
          if (result == 'success') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Center(
                        child: Column(children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 50,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Account updated successfully',
                            style: TextStyle(color: Colors.green),
                          ),
                        ]),
                      ));
                });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Center(
                        child: Column(children: const [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            'Something went wrong',
                            style: TextStyle(color: Colors.red),
                          ),
                        ]),
                      ));
                });
          }
        }
      }
    }
  }
}
