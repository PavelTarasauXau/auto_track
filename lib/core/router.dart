import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/data_manager/data_manager_screen.dart';
import '../features/documents/documents_screen.dart';
import '../features/garage/garage_screen.dart';
import '../features/garage/vehicle_form_screen.dart';
import '../features/history/history_screen.dart';
import '../features/plan/plan_screen.dart';
import '../features/record_details/record_details_screen.dart';
import '../features/record_form/record_form_screen.dart';
import '../features/shell/main_shell.dart';
import '../features/stats/stats_screen.dart';

/// Route paths used across the app.
abstract final class Routes {
  static const home = '/home';
  static const history = '/history';
  static const plan = '/plan';
  static const documents = '/documents';
  static const stats = '/stats';

  static const garage = '/garage';
  static const newVehicle = '/garage/new';
  static String editVehicle(int id) => '/garage/$id/edit';

  static const newRecord = '/record/new';
  static String record(int id) => '/record/$id';
  static String editRecord(int id) => '/record/$id/edit';

  static const data = '/data';
}

final routerProvider = Provider<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>();
  final router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: Routes.home,
    routes: [
      // Bottom navigation: each tab keeps its own navigation stack.
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          _branch(Routes.home, const DashboardScreen()),
          _branch(Routes.history, const HistoryScreen()),
          _branch(Routes.plan, const PlanScreen()),
          _branch(Routes.documents, const DocumentsScreen()),
          _branch(Routes.stats, const StatsScreen()),
        ],
      ),

      // Full-screen routes, shown above the bottom navigation.
      GoRoute(
        path: Routes.garage,
        parentNavigatorKey: rootKey,
        builder: (context, state) => const GarageScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const VehicleFormScreen(),
          ),
          GoRoute(
            path: ':id/edit',
            builder: (context, state) =>
                VehicleFormScreen(vehicleId: _id(state)),
          ),
        ],
      ),
      GoRoute(
        path: Routes.newRecord,
        parentNavigatorKey: rootKey,
        builder: (context, state) =>
            RecordFormScreen(initialType: state.uri.queryParameters['type']),
      ),
      GoRoute(
        path: '/record/:id',
        parentNavigatorKey: rootKey,
        builder: (context, state) => RecordDetailsScreen(recordId: _id(state)),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) => RecordFormScreen(recordId: _id(state)),
          ),
        ],
      ),
      GoRoute(
        path: Routes.data,
        parentNavigatorKey: rootKey,
        builder: (context, state) => const DataManagerScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

StatefulShellBranch _branch(String path, Widget screen) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (context, state) => screen)],
);

int _id(GoRouterState state) => int.parse(state.pathParameters['id']!);
