import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../contants/constants.dart';
import '../provider/auth_provider.dart';
import '../routes/route_enum.dart';
import '../shared/validators.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  Future<User?> loginUser(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final box = Hive.box('authBox');
      box.put('email', email);
      box.put('password', password); // optional, consider security
      box.put('isLoggedIn', true);


      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = e.message ?? 'An error occurred';
      }

      // Show error as a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(validateModeProvider(id: 1));
    final pass = ref.watch(passShowProvider(id: 1));

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('LoginPage')),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.amber.shade200,
      body: FormBuilder(
        key: _formKey,
        autovalidateMode: mode,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
            
                sizedBoxH10,
            
                FormBuilderTextField(
                  name: 'email',
                  decoration: InputDecoration(
                    prefix: const Icon(Icons.email),
                    contentPadding: const EdgeInsets.only(left: 10),
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
            
                sizedBoxH10,
            
                FormBuilderTextField(
                  name: 'password',
                  obscureText: !pass,
                  decoration: InputDecoration(
                    prefix: const Icon(Icons.password),
                    contentPadding: const EdgeInsets.only(left: 10),
                    suffixIcon: IconButton(
                      onPressed: () {
                        ref.read(passShowProvider(id: 1).notifier).toggle();
                      },
                      icon: Icon(
                        pass ? Icons.visibility_off : Icons.remove_red_eye_outlined,
                      ),
                    ),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ]),
                ),
            
                sizedBoxH10,
            

                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.saveAndValidate()) {
                          final map = _formKey.currentState!.value;
                          final email = map['email'];
                          final password = map['password'];

                          final user = await loginUser(email, password);

                          if (user != null) {
                            // Save login state in Hive
                            ref.read(authControllerProvider.notifier).login(user);
                            final box = Hive.box('authBox');
                            box.put('isLoggedIn', true);
                            box.put('email', email);
// optionally store token or UID if needed

                            _formKey.currentState?.reset();

                            // Navigate to home on success
                            if (mounted) {
                              context.pushNamed(AppRoute.home.name);
                            }
                          }
                        } else {
                          ref
                              .read(validateModeProvider(id: 1).notifier)
                              .change();
                        }
                      },
                      child: const Text('Login'),
                    ),





            
                sizedBoxH10,
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Haven\'t an account?'),
                    TextButton(
                      onPressed: () {
                        context.pushNamed(AppRoute.signup.name);
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
