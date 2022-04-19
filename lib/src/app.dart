import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_service.dart';

import 'package:lab1_provider_messager/src/authentication/authentication_view.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_controller.dart';
import 'package:lab1_provider_messager/src/chat/chat_view.dart';
import 'package:lab1_provider_messager/src/messager/messager_controller.dart';
import 'package:lab1_provider_messager/src/messager/messager_service.dart';
import 'package:lab1_provider_messager/src/messager/messager_view.dart';
import 'package:provider/provider.dart';

class MessagerApp extends StatelessWidget {
  const MessagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(),
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case AuthenticationView.routeName:
                return const AuthenticationView();

              case ChatView.routeName:
                final args = routeSettings.arguments as String;
                return ChatView(chatId: args);

              case MessagerView.routeName:
              default:
                return const MessagerView();
            }
          },
        );
      },
    );
  }
}

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationController>(
            create: (context) =>
                AuthenticationController(AuthenticationService())),
        ChangeNotifierProvider<MessagerController>(
            create: (context) => MessagerController()),
      ],
      child: const MessagerApp(),
    );
  }
}
