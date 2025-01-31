import 'package:apphealthsync/ui/widgets/custom_button.dart';
import 'package:apphealthsync/ui/widgets/custom_password_form_field.dart';
import 'package:apphealthsync/ui/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/authservice.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.onTap});

  final void Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  // Função para registrar o usuário
  void signUp() async {
    if (passwordController.value.text != rePasswordController.value.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("As senhas não coincidem."),
        ),
      );
      return;
    }

    final AuthService authService = Provider.of<AuthService>(context, listen: false);
    try {
      // Tenta cadastrar o usuário com o email e a senha
      UserCredential userCredential = await authService.signUpWithEmailAndPassword(
        emailController.value.text,
        passwordController.value.text,
      );

      // Após o cadastro, o perfil será criado automaticamente no Firestore
      await authService.criarPerfil(userCredential.user!);  // Aqui chamamos o método _criarPerfil

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cadastro realizado com sucesso!"),
        ),
      );

      // Você pode redirecionar para outra página ou realizar outra ação aqui

    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Vamos criar uma nova conta!",
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Registro", // Adiciona o texto no topo
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000), // Cor ajustada para legibilidade
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      labelText: "Usuário",
                      controller: emailController,
                    ),
                    const SizedBox(height: 10),
                    CustomPasswordFormField(
                      labelText: "Senha",
                      controller: passwordController,
                    ),
                    const SizedBox(height: 10),
                    CustomPasswordFormField(
                      labelText: "Confirmar Senha",
                      controller: rePasswordController,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Cadastrar",
                      height: 50,
                      onClick: signUp, // Chama a função signUp ao clicar
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Já é cadastrado?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Entrar agora.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
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
          const SizedBox(height: 10),
          const Text(
            'ATILETSE',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Bebas Neue",
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
