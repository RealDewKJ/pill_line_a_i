import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_endpoint.dart';
import 'package:pill_line_a_i/flutter_flow/flutter_flow_util.dart';
import 'package:pill_line_a_i/utils/helper/shared_preference/shared_preference_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  // Setup all dependencies
  setupServiceLocator();

  // Initialize Shared Preferences
  await SharedPrefHelper.init();

  // Initialize EHP
  Endpoints.isEHPConnect = await serviceLocator<EHPApi>().initializeEHPToken();
  if (Endpoints.isEHPConnect) {
    // await serviceLocator<EHPApi>().getUserJWT('0000000000001', 'admin');
  }

  Intl.defaultLocale = "th";

  // Always start at login page
  String initialRoute = '/login';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch = routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() => _router.routerDelegate.currentConfiguration.matches.map((e) => getRoute(e)).toList();

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier, widget.initialRoute);
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PillLine AI',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
