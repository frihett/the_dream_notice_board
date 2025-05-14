import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/data/datasources/auth_remote_datasource_impl.dart';
import 'package:the_dream_notice_board/data/repositories/auth_repository_impl.dart';
import 'package:the_dream_notice_board/data/storage/token_storage.dart';
import 'package:the_dream_notice_board/domain/usecases/sign_in_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/sign_up_usecase.dart';
import 'package:the_dream_notice_board/presentation/home/home_screen.dart';
import 'package:the_dream_notice_board/presentation/sign_in/signin_screen.dart';
import 'package:the_dream_notice_board/presentation/sign_in/signin_view_model.dart';
import 'package:the_dream_notice_board/presentation/sign_up/signup_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialScreen = await _getInitialScreen();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  MyApp({super.key, required this.initialScreen});

  final _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SignInViewModel(
            signInUseCase: SignInUseCase(
                repository: AuthRepositoryImpl(
                    remoteDataSource: AuthRemoteDataSourceImpl(dio: _dio))),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SignUpViewModel(
            signUpUseCase: SignUpUseCase(
                repository: AuthRepositoryImpl(
                    remoteDataSource: AuthRemoteDataSourceImpl(dio: _dio))),
          ),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/signin': (_) => const SignInScreen(),
          '/home': (_) => const HomeScreen(),
        },
        home: initialScreen,
      ),
    );
  }
}

Future<Widget> _getInitialScreen() async {
  final token = await TokenStorage.getAccessToken();
  if (token != null) {
    return const HomeScreen();
  } else {
    return const SignInScreen();
  }
}
