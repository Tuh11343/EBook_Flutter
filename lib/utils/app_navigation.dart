import 'package:ebook/controller/detail_book_controller.dart';
import 'package:ebook/controller/detail_book_controller_2.dart';
import 'package:ebook/controller/favoriteController.dart';
import 'package:ebook/controller/payment_controller.dart';
import 'package:ebook/controller/sign_in_controller.dart';
import 'package:ebook/controller/sign_up_controller.dart';
import 'package:ebook/views/author_view.dart';
import 'package:ebook/views/detail_book.dart';
import 'package:ebook/views/favorite_view.dart';
import 'package:ebook/views/listening_page.dart';
import 'package:ebook/views/main_wrapper.dart';
import 'package:ebook/views/audio_view.dart';
import 'package:ebook/views/payment_view.dart';
import 'package:ebook/views/search_view.dart';
import 'package:ebook/views/user_not_login_view.dart';
import 'package:ebook/views/user_sign_in_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/HomeAuthorController.dart';
import '../controller/audio_controller.dart';
import '../controller/home_controller.dart';
import '../controller/main_wrapper_controller.dart';
import '../controller/search_controller.dart';
import '../controller/user_sign_in_controller.dart';
import '../model/Author.dart';
import '../model/Book.dart';
import '../views/home_view.dart';
import '../views/sign_in_view.dart';
import '../views/sign_up_view.dart';
import '../widgets/show_exit_dialog.dart';

class AppNavigation {
  AppNavigation._();

  static String initR = '/home';

  //Private Navigators Keys
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHomeKey =
      GlobalKey<NavigatorState>(debugLabel: 'Shell Home');
  static final _rootNavigatorSearchKey =
      GlobalKey<NavigatorState>(debugLabel: 'Shell Search');
  static final _rootNavigatorSongControlKey =
      GlobalKey<NavigatorState>(debugLabel: 'Shell Song Control');
  static final _rootNavigatorDetailBookKey =
      GlobalKey<NavigatorState>(debugLabel: 'Shell Detail Book');
  static final _rootNavigatorAuthorKey =
      GlobalKey<NavigatorState>(debugLabel: 'Shell Author');
  static final _rootNavigatorFavoriteKey =
      GlobalKey<NavigatorState>(debugLabel: 'Shell Favorite');
  static final _rootNavigatorUserNLGKey =
      GlobalKey<NavigatorState>(debugLabel: 'Shell User Not Log In');
  static final _rootNavigatorUserSIKey =
      GlobalKey<NavigatorState>(debugLabel: 'Shell User Sign In');


  //Config
  static final GoRouter router = GoRouter(
      initialLocation: initR,
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      routes: [
        //Main Route
        StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (context) => MainWrapperController()),
                  ChangeNotifierProvider(
                      create: (context) => HomeAuthorController()),
                  ChangeNotifierProvider(create: (context) => HomeController()),
                  ChangeNotifierProvider(
                      create: (context) => AudioController()),
                  // ChangeNotifierProvider(
                  //     create: (context) => DetailBookController()),
                  ChangeNotifierProvider(
                    create: (context) => SearchViewController(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) {
                      return SignInController();
                    },
                  ),
                  ChangeNotifierProvider(
                    create: (context) => SignUpController(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => UserSignInController(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => PaymentController(),
                  ),
                  ChangeNotifierProvider(create: (context) => FavoriteController(),),
                  ChangeNotifierProvider(create: (context) => DetailBookController2(),),
                ],
                child: MainWrapper(
                  navigationShell: navigationShell,
                ),
              );
            },
            branches: [
              //Branch Home
              StatefulShellBranch(navigatorKey: _rootNavigatorHomeKey, routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) {
                    final mainWrapperState = context.findAncestorStateOfType<MainWrapperState>();
                    return HomeView(onBottomNavBarButtonPressed: mainWrapperState!.onBottomNavBarButtonPressed,
                      key: state.pageKey,
                    );
                  },
                ),
              ]),

              //Branch Search
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorSearchKey,
                  routes: [
                    GoRoute(
                      path: '/search',
                      name: 'search',
                      builder: (context, state) {
                        return SearchView();
                      },
                    ),
                  ]),

              //Branch Favorite
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorFavoriteKey,
                  routes: [
                    GoRoute(
                      path: '/favorite',
                      name: 'favorite',
                      builder: (context, state) {
                        return Favorite(
                          key: state.pageKey,
                        );
                      },
                    ),
                  ]),

              //Branch UserNLG
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorUserNLGKey,
                  routes: [
                    GoRoute(
                        path: '/userNLG',
                        name: 'userNLG',
                        builder: (context, state) {
                          return UserNLG(
                            key: state.pageKey,
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'signIn',
                            name: 'signIn',
                            builder: (context, state) {
                              return SignIn(key: state.pageKey);
                            },
                          ),
                          GoRoute(
                            path: 'signUp',
                            name: 'signUp',
                            builder: (context, state) {
                              return SignUp(
                                key: state.pageKey,
                              );
                            },
                          ),
                        ]),
                  ]),

              //Branch UserSI
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorUserSIKey,
                  routes: [
                    GoRoute(
                        path: '/userSI',
                        name: 'userSI',
                        builder: (context, state) {
                          return UserSignIn(
                            key: state.pageKey,
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'payment',
                            name: 'payment',
                            builder: (context, state) {
                              return PaymentView(key: state.pageKey);
                            },
                          )
                        ]),
                  ]),

              //Branch SongControl
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorSongControlKey,
                  routes: [
                    GoRoute(
                      path: '/songControl',
                      name: 'songControl',
                      builder: (context, state) {
                        return const ListeningPage();
                      },
                    )
                  ]),

              //Branch Detail Book
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorDetailBookKey,
                  routes: [
                    GoRoute(
                        path: '/detailBook',
                        name: 'detailBook',
                        builder: (context, state) {
                          final book = state.extra as Book;
                          return ChangeNotifierProvider(
                            create: (BuildContext context) => DetailBookController2(),
                            child: DetailBookView(
                              book: book,
                              key: state.pageKey,
                            ),
                          );
                        })
                  ]),

              //Branch Author
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorAuthorKey,
                  routes: [
                    GoRoute(
                      path: '/author',
                      name: 'author',
                      builder: (context, state) {
                        final author = state.extra as Author;
                        return AuthorView(
                          author: author,
                          key: state.pageKey,
                        );
                      },
                    ),
                  ])
            ]),
      ]);
}
