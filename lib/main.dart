import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';

import 'controllers/session_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'routes.dart';
import 'theme.dart';

void main() {

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final sessionController = Get.put(SessionController());
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      'https://ctshop.ssspl.net/graphql/',
      defaultHeaders: {
        'Authorization': 'Bearer ${sessionController.sessionId.value}',
      },
    );

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce',
        theme: AppTheme.lightTheme(context),
        initialRoute: SplashScreen.routeName,
        routes: routes,
      ),
    );
  }
}