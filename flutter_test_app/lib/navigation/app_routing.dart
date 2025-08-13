import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test_app/Screens/home.dart';
import 'package:flutter_test_app/Backend/bluetooth_logic.dart';

class AppRouting {
  static const String onPathName = "ON";
  static const String offPathName = "OFF";
  static const String connectedDevice = "DEVICE";
}


final GoRouter _router = GoRouter(
  initialLocation: initialBleStatus(),

  routes: <RouteBase>[
    GoRoute(
      name: AppRouting.offPathName,
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return BtOffWidget();
      },
    ),

    // the on route
    GoRoute(
      name: AppRouting.onPathName,
      path: '/${AppRouting.onPathName}',
      builder: (BuildContext context, GoRouterState state) {
        return const BtOnWidget();
      },
      routes: [
            GoRoute(
              name: AppRouting.connectedDevice,
              path: AppRouting.connectedDevice,
              builder: (BuildContext context, GoRouterState state) {
                
                return BtOffWidget();
              },
    ),
      ]
    ),
  ],
);


GoRouter get router => _router;