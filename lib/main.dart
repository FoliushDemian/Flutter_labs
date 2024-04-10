import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/bloc/transaction_bloc.dart';
import 'package:my_project/bloc/user_bloc.dart';
import 'package:my_project/logic/services/auth_service.dart';
import 'package:my_project/logic/services/transaction_service.dart';
import 'package:my_project/pages/auto_login_screen.dart';
import 'package:my_project/pages/home_page.dart';
import 'package:my_project/pages/login.dart';
import 'package:my_project/pages/sign_up.dart';
import 'package:my_project/pages/user_profile.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Finance App',
    //   home: const AutoLoginScreen(),
    //   routes: {
    //     '/login': (context) => const LoginPage(),
    //     '/registration': (context) => const RegistrationPage(),
    //     '/profile': (context) => const UserProfilePage(),
    //     '/main': (context) => const HomePage(),
    //   },
    // );

    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<TransactionService>(
          create: (_) => TransactionService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TransactionBloc>(
            create: (context) =>
                TransactionBloc(context.read<TransactionService>()),
          ),
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(context.read<AuthService>()),
          ),
        ],
        child: MaterialApp(
          title: 'Finance App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const AutoLoginScreen(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/registration': (context) => const RegistrationPage(),
            '/profile': (context) => const UserProfilePage(),
            '/main': (context) => const HomePage(),
          },
        ),
      ),
    );
  }
}
