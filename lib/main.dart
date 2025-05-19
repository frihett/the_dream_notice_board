import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:the_dream_notice_board/core/network/auth_interceptor.dart';
import 'package:the_dream_notice_board/data/datasources/auth_remote_datasource_impl.dart';
import 'package:the_dream_notice_board/data/datasources/board_remote_datasource_impl.dart';
import 'package:the_dream_notice_board/data/models/board_detail.dart';
import 'package:the_dream_notice_board/data/repositories/auth_repository_impl.dart';
import 'package:the_dream_notice_board/data/repositories/board_repository_impl.dart';
import 'package:the_dream_notice_board/data/storage/token_storage.dart';
import 'package:the_dream_notice_board/domain/usecases/create_board_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/delete_board_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/get_board_detail_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/get_board_list_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/get_categories_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/sign_in_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/sign_up_usecase.dart';
import 'package:the_dream_notice_board/domain/usecases/update_board_usecase.dart';
import 'package:the_dream_notice_board/presentation/board/board_screen.dart';
import 'package:the_dream_notice_board/presentation/board/board_view_model.dart';
import 'package:the_dream_notice_board/presentation/board_detail/board_detail_screen.dart';
import 'package:the_dream_notice_board/presentation/board_detail/board_detail_view_model.dart';
import 'package:the_dream_notice_board/presentation/edit/edit_screen.dart';
import 'package:the_dream_notice_board/presentation/edit/edit_view_model.dart';
import 'package:the_dream_notice_board/presentation/home/home_screen.dart';
import 'package:the_dream_notice_board/presentation/main/main_screen.dart';
import 'package:the_dream_notice_board/presentation/profile/profile_view_model.dart';
import 'package:the_dream_notice_board/presentation/sign_in/signin_screen.dart';
import 'package:the_dream_notice_board/presentation/sign_in/signin_view_model.dart';
import 'package:the_dream_notice_board/presentation/sign_up/signup_view_model.dart';
import 'package:the_dream_notice_board/presentation/write/write_screen.dart';
import 'package:the_dream_notice_board/presentation/write/write_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialScreen = await _getInitialScreen();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  final Dio _dio = _createDio();

  MyApp({super.key, required this.initialScreen});

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
        ChangeNotifierProvider(
          create: (_) => BoardViewModel(
            getBoardListUseCase: GetBoardListUseCase(
              repository: BoardRepositoryImpl(
                remoteDataSource: BoardRemoteDataSourceImpl(dio: _dio),
              ),
            ),
            getCategoriesUseCase: GetCategoriesUseCase(
                repository: BoardRepositoryImpl(
                    remoteDataSource: BoardRemoteDataSourceImpl(dio: _dio))),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(),
        ),
        ChangeNotifierProvider(
            create: (_) => WriteViewModel(
                useCase: CreateBoardUseCase(
                    repository: BoardRepositoryImpl(
                        remoteDataSource:
                            BoardRemoteDataSourceImpl(dio: _dio))),
                getCategoriesUseCase: GetCategoriesUseCase(
                    repository: BoardRepositoryImpl(
                        remoteDataSource:
                            BoardRemoteDataSourceImpl(dio: _dio)))))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/signin': (_) => const SignInScreen(),
          '/home': (_) => const HomeScreen(),
          '/main': (_) => const MainScreen(),
          '/write': (_) => const WriteScreen(),
          '/board':(_)=> const BoardScreen(),
          '/board_detail': (context) {
            final boardId = ModalRoute.of(context)!.settings.arguments as int;
            return ChangeNotifierProvider(
              create: (_) => BoardDetailViewModel(
                  useCase: GetBoardDetailUseCase(
                    repository: BoardRepositoryImpl(
                      remoteDataSource:
                          BoardRemoteDataSourceImpl(dio: _dio), // 혹은 기존 dio
                    ),
                  ),
                  deleteUseCase: DeleteBoardUseCase(
                      repository: BoardRepositoryImpl(
                          remoteDataSource:
                              BoardRemoteDataSourceImpl(dio: _dio)))),
              child: BoardDetailScreen(boardId: boardId),
            );
          },
          '/edit': (context) {
            final board =
                ModalRoute.of(context)!.settings.arguments as BoardDetail;
            return ChangeNotifierProvider(
              create: (_) => EditViewModel(
                  updateUseCase: UpdateBoardUseCase(
                      repository: BoardRepositoryImpl(
                          remoteDataSource:
                              BoardRemoteDataSourceImpl(dio: _dio))),
                  getCategoriesUseCase: GetCategoriesUseCase(
                      repository: BoardRepositoryImpl(
                          remoteDataSource:
                              BoardRemoteDataSourceImpl(dio: _dio)))),
              child: EditBoardScreen(
                board: board,
              ),
            );
          },
        },
        home: initialScreen,
      ),
    );
  }
}

Future<Widget> _getInitialScreen() async {
  final token = await TokenStorage.getAccessToken();
  if (token != null && !JwtDecoder.isExpired(token)) {
    return const MainScreen();
  } else {
    return const SignInScreen();
  }
}

Dio _createDio() {
  final dio = Dio();
  dio.interceptors.add(AuthInterceptor(dio: dio));
  return dio;
}
