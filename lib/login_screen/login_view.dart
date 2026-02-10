import 'package:flutter/material.dart';
import 'package:nutrikmais/login_screen/login_service.dart';
import 'package:nutrikmais/globals/configs/route_generator.dart';
import 'package:nutrikmais/globals/configs/colors.dart';
import 'package:nutrikmais/globals/customs/components/custom_button.dart';
import 'package:nutrikmais/globals/customs/components/custom_input_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                        ),
                        color: MyColors.myPrimary,
                      ),
                      height: 120,
                      width: 70,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "images/icon_insta.png",
                            color: MyColors.myPrimary,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "Site",
                            style: TextStyle(color: MyColors.myPrimary),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "images/icon_whats.png",
                            color: MyColors.myPrimary,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "Suporte",
                            style: TextStyle(color: MyColors.myPrimary),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "images/icon_site.png",
                            color: MyColors.myPrimary,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "Site",
                            style: TextStyle(color: MyColors.myPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Image.asset(
                        "images/Logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.myPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 30),
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      CustomInputField(
                        controller: _usernameController,
                        labelText: "Sem texto",
                        hintText: "Email",
                        spacingHeight: 0,
                        hintStyle: const TextStyle(color: Colors.white),
                        autoFocus: true,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 100,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                        ),
                      ),
                      CustomInputField(
                        controller: _passwordController,
                        labelText: "Sem texto",
                        hintText: "Senha",
                        spacingHeight: 0,
                        hintStyle: const TextStyle(color: Colors.white),
                        obscureText: true,
                        maxLength: 32,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await LoginService.login(
                            _usernameController.text,
                            _passwordController.text,
                            context,
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        title: "ENTRAR NO APP",
                        titleColor: MyColors.myPrimary,
                        titleSize: 18,
                        titleFontWeight: FontWeight.w300,
                        icon: Icons.keyboard_arrow_right,
                        iconColor: MyColors.myPrimary,
                        iconSize: 30,
                        isLoading: _isLoading,
                        loadingColor: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        onPressed: () async {
                          Navigator.pushNamed(
                            context,
                            RouteGenerator.createAccount,
                          );
                        },
                        title: "CRIAR CONTA NO APP",
                        titleColor: MyColors.myPrimary,
                        titleSize: 18,
                        titleFontWeight: FontWeight.w300,
                        icon: Icons.keyboard_arrow_right,
                        iconColor: MyColors.myPrimary,
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
