import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../contants/constants.dart';
import '../routes/route_enum.dart';
import '../shared/validators.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override

  void dispose() {
    super.dispose();
  }
  Future<User?> signupUser(String username, String email, String password) async {
    try {
      // Create user in Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        // Save extra data (username) in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already in use.';
      } else if (e.code == 'weak-password') {
        message = 'Password should be at least 6 characters.';
      } else {
        message = e.message ?? 'An error occurred';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
      return null;
    }
  }


  Widget build(BuildContext context) {
    final pass = ref.watch(passShowProvider(id: 2));
    final mode = ref.watch(validateModeProvider(id: 2));
    return  Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('SignUpPage')),
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
                  name: 'username',
                  decoration: InputDecoration(
                    prefix: const Icon(Icons.person),
                    contentPadding: const EdgeInsets.only(left: 10),
                    labelText: 'username',
                    hintText: 'Enter your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),

                  ]),
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
                        ref.read(passShowProvider(id: 2).notifier).toggle();
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
                          final username = map['username'];
                          final email = map['email'];
                          final password = map['password'];

                          final user = await signupUser(username, email, password);

                          if (user != null) {
                            _formKey.currentState?.reset();

                            // On success, navigate to home
                            if (mounted) {
                              context.pushNamed(AppRoute.home.name);
                            }
                          }
                        } else {
                          ref.read(validateModeProvider(id: 2).notifier).change();
                        }
                      },
                      child: const Text('Sign up'),
                    ),





                sizedBoxH10,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an Account?'),
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Login Page'),
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

