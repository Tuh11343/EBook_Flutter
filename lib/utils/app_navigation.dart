import 'package:ebook/views/author_view.dart';
import 'package:ebook/views/detail_book.dart';
import 'package:ebook/views/main_wrapper.dart';
import 'package:ebook/views/audio_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../model/Author.dart';
import '../model/Book.dart';
import '../views/home_view.dart';

enum AppState { home, audio, detailBook }

class AppStateNotifier extends ChangeNotifier {
  final List<AppState> _stateStack = [AppState.home];
  final List<Book> _selectedBook = [];
  final List<Author> _selectedAuthor = [];

  AppState get currentState => _stateStack.last;

  Book get selectedBook => _selectedBook.last;

  Author get selectedAuthor => _selectedAuthor.last;

  void pushState(AppState state) {
    _stateStack.add(state);
    notifyListeners();
  }

  void returnLastState() {
    AppState lastState = _stateStack.removeLast();
    if (lastState == AppState.detailBook) {
      _selectedBook.removeLast();
    }
    notifyListeners();
  }

  void updateState(AppState state) {
    _stateStack.last = state;
    notifyListeners();
  }

  void resetState(AppState state) {
    _stateStack.removeRange(0, _stateStack.length - 1);
    _stateStack.add(state);
    notifyListeners();
  }

  List<AppState> get stateStack => List.unmodifiable(_stateStack);
}

class AppNavigation {
  AppNavigation._();

  static String initR = '/home';

  //Private Navigators Keys
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHomeKey =
      GlobalKey<NavigatorState>(debugLabel: 'Shell Home');

  //Config
  static final GoRouter router = GoRouter(
      initialLocation: initR,
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      routes: [
        //Main Route
        StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return MainWrapper(
                navigationShell: navigationShell,
              );
            },
            branches: [
              //Branch Home
              StatefulShellBranch(routes: [
                GoRoute(
                    path: '/home',
                    name: 'Home',
                    builder: (context, state) {
                      return HomeView(
                        key: state.pageKey,
                      );
                    },
                    routes: [
                      GoRoute(
                          path: 'detailBook',
                          name: 'detailBook',
                          builder: (context, state) {
                            final book = state.extra as Book;
                            return DetailBookView(
                              book: book,
                              key: state.pageKey,
                            );
                          },
                          routes: [
                            GoRoute(
                              path: 'author',
                              name: 'author',
                              builder: (context, state) {
                                final author = state.extra as Author;
                                return AuthorView(
                                  author: author,
                                  key: state.pageKey,
                                );
                              },
                            ),
                            GoRoute(
                              path: 'audio',
                              name: 'audio',
                              builder: (context, state) {
                                return AudioView();
                              },
                            ),
                          ])
                    ]),
              ]),
            ]),
      ]);
}
