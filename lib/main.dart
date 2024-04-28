import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:oktoast/oktoast.dart';

import 'components/loading_dialog/controller.dart';
import 'providers/storage_provider.dart';
import 'routes/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StorageProvider.init();
  
  // HttpOverrides.global = ProxiedHttpOverrides('127.0.0.1', 8080);

  Get.create(() => LoadingDialogController());

  runApp(const MainApp());
}

class ProxiedHttpOverrides extends HttpOverrides {
  final String _host;
  final int _port;

  ProxiedHttpOverrides(this._host, this._port);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return 'PROXY $_host:$_port;';
      };
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Color _defaultColor = Colors.blue;

  Widget _buildToast(BuildContext context, Widget? child) {
    return OKToast(
      position: ToastPosition.bottom,
      textPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textStyle:
          TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: child ?? const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme? lightColorScheme;
      ColorScheme? darkColorScheme;

      if (lightDynamic != null && darkDynamic != null) {
        lightColorScheme = lightDynamic.harmonized();
        darkColorScheme = darkDynamic.harmonized();
      } else {
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: _defaultColor,
          brightness: Brightness.light,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: _defaultColor,
          brightness: Brightness.dark,
        );
      }

      return GetMaterialApp(
        builder: _buildToast,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.home,
        defaultTransition: Transition.native,
        getPages: AppPages.pages,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
        ).copyWith(
          actionIconTheme: ActionIconThemeData(
            backButtonIconBuilder: (BuildContext context) =>
                const Icon(Icons.arrow_back),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
        ).copyWith(
          actionIconTheme: ActionIconThemeData(
            backButtonIconBuilder: (BuildContext context) =>
                const Icon(Icons.arrow_back),
          ),
        ),
        themeMode: ThemeMode.system,
      );
    }));
  }
}
