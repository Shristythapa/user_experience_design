import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momo_rating_app_frontend/core/utils/snackbar.dart';
import 'package:momo_rating_app_frontend/screens/auth/login.dart';
import 'package:momo_rating_app_frontend/viewmodel/viewmodel/auth_view_model.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  bool showPassword = false;
  bool buttonPressed = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController optController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.showMessage!) {
        SnackBarManager.showSnackBar(
            isError: ref.read(authViewModelProvider).isError,
            message: ref.read(authViewModelProvider).message,
            context: context);
        ref.read(authViewModelProvider.notifier).reset();
      }
    });
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('image/momo_background2.jpg'),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                body: Form(
                  key: form,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      padding: const EdgeInsets.all(40),
                      decoration: const BoxDecoration(
                        color: Color(0xfffffdef),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70.0),
                          topRight: Radius.circular(70.0),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      color: Color(0xff474747),
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                style: const TextStyle(fontSize: 20),
                                controller: emailController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email is invalid";
                                  } else if (!value.contains('@gmail.com')) {
                                    return 'Email is invalid';
                                  } else {
                                    return null;
                                  }
                                },
                                focusNode: myFocusNode,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red[900]),
                                  prefixIcon: const Icon(
                                    Icons.mail,
                                    // color: Color(0xFF6D3F83),
                                  ),
                                  labelText: "email",
                                  labelStyle: const TextStyle(
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    // color: myFocusNode.hasFocus
                                    //     ? const Color.fromARGB(
                                    //         255, 136, 117, 163)
                                    //     : const Color.fromARGB(
                                    //         255, 139, 117, 169),
                                  ),
                                  border: const UnderlineInputBorder(),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                style: const TextStyle(fontSize: 20),
                                controller: optController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "otp is required";
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: !showPassword,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red[900]),
                                  labelText: "otp",
                                  labelStyle: const TextStyle(
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.password,
                                  ),
                                  border: const UnderlineInputBorder(),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusColor:
                                      const Color.fromARGB(255, 141, 125, 164),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                style: const TextStyle(fontSize: 20),
                                controller: passwordController,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "password is required";
                                  } else if (value.length < 4) {
                                    return 'password must be higher than four character';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: !showPassword,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red[900]),
                                  labelText: "password",
                                  labelStyle: const TextStyle(
                                    fontFamily: 'roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                  ),
                                  suffixIcon: showPassword
                                      ? InkWell(
                                          onTap: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.visibility,
                                            // color: Color(0xFF6D3F83),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.visibility_off,
                                            // color: Color(0xFF6D3F83),
                                          ),
                                        ),
                                  border: const UnderlineInputBorder(),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusColor:
                                      const Color.fromARGB(255, 141, 125, 164),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                width: 150,
                                height: 50,
                                child: ElevatedButton(
                                  //  style: ButtonStyle(backgroundColor: Colors.ye),
                                  onHover: (value) {
                                    setState(() {
                                      !buttonPressed;
                                    });
                                  },
                                  onPressed: (() {
                                    buttonPressed = !buttonPressed;
                                    // if (true) {
                                    if (form.currentState!.validate()) {
                                      ref
                                          .read(authViewModelProvider.notifier)
                                          .resetPassword(
                                              emailController.text,
                                              optController.text,
                                              passwordController.text,
                                              context);
                                    }
                                  }),
                                  child: const Text(
                                    "Reset",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Center(
                                    child: InkWell(
                                  child: const Text(
                                    "Go to login?",
                                    style: TextStyle(
                                      fontFamily: 'roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()),
                                    );
                                  },
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            if (authState.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.yellow,
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
