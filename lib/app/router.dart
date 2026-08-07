import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../features/acts/act_detail_screen.dart';
import '../features/acts/acts_screen.dart';
import '../features/backstage/backstage_screen.dart';
import '../features/backstage/legal_page_screen.dart';
import '../features/console/stage_console_screen.dart';
import '../features/launch/launch_screen.dart';
import '../features/library/library_screen.dart';
import '../features/notes/notes_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/preparation/checklist_screen.dart';
import '../features/preparation/stage_plot_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/run_order/run_order_screen.dart';
import '../features/timeline/timeline_screen.dart';
import '../ringside/core/relay_models.dart';
import '../ringside/ring_gate.dart';
import 'orientation.dart';
import 'shell/app_shell.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();

int _actId(GoRouterState state) => int.parse(state.pathParameters['id']!);

/// The app's routes.
///
/// Launch sits outside the shell so the dock cannot appear before there is
/// anything to navigate to, and the four dock destinations are branches of a
/// [StatefulShellRoute] so each keeps its scroll position and filters when the
/// user moves between them.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/launch',
  routes: <RouteBase>[
    GoRoute(
      path: '/launch',
      builder: (BuildContext context, GoRouterState state) => LaunchScreen(
        onReady: () {
          // Bootstrap resolved both the local warm-up and the attribution
          // gate, so the branch is a simple field read here — no second
          // loading state appears.
          final container = ProviderScope.containerOf(context);
          final coordinator = container.read(ringCoordinatorProvider);
          final GateStage stage =
              coordinator?.outcome ?? const NativeStage();

          if (stage is NativeStage || coordinator == null) {
            OrientationPolicy.lockPortrait();
            final bool onboarded = container
                    .read(preferencesProvider)
                    .value
                    ?.onboardingCompleted ??
                false;
            context.go(onboarded ? '/console' : '/onboarding');
            return;
          }
          // Gray branches keep landscape available (portal + offline art rotate).
          enterGateStage(context, coordinator, stage);
        },
      ),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) => OnboardingScreen(
        onDone: () => context.go('/console'),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) =>
          AppShell(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/console',
              builder: (BuildContext context, GoRouterState state) =>
                  const StageConsoleScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/acts',
              builder: (BuildContext context, GoRouterState state) =>
                  const ActsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/library',
              builder: (BuildContext context, GoRouterState state) =>
                  const LibraryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/progress',
              builder: (BuildContext context, GoRouterState state) =>
                  const ProgressScreen(),
            ),
          ],
        ),
      ],
    ),
    // Pushed over the shell: an act fills the screen, and the dock would only
    // invite the user to lose their place in it.
    GoRoute(
      path: '/acts/:id',
      parentNavigatorKey: _rootKey,
      builder: (BuildContext context, GoRouterState state) => ActDetailScreen(
        actId: _actId(state),
      ),
      routes: <RouteBase>[
        GoRoute(
          path: 'run-order',
          parentNavigatorKey: _rootKey,
          builder: (BuildContext context, GoRouterState state) =>
              RunOrderScreen(actId: _actId(state)),
        ),
        GoRoute(
          path: 'timeline',
          parentNavigatorKey: _rootKey,
          builder: (BuildContext context, GoRouterState state) =>
              TimelineScreen(actId: _actId(state)),
        ),
        GoRoute(
          path: 'checklist',
          parentNavigatorKey: _rootKey,
          builder: (BuildContext context, GoRouterState state) =>
              ChecklistScreen(actId: _actId(state)),
        ),
        GoRoute(
          path: 'stage-plot',
          parentNavigatorKey: _rootKey,
          builder: (BuildContext context, GoRouterState state) =>
              StagePlotScreen(actId: _actId(state)),
        ),
        GoRoute(
          path: 'notes',
          parentNavigatorKey: _rootKey,
          builder: (BuildContext context, GoRouterState state) =>
              NotesScreen(actId: _actId(state)),
        ),
      ],
    ),
    GoRoute(
      path: '/backstage',
      parentNavigatorKey: _rootKey,
      builder: (BuildContext context, GoRouterState state) => const BackstageScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'privacy',
          parentNavigatorKey: _rootKey,
          builder: (BuildContext context, GoRouterState state) =>
              const LegalPageScreen(document: LegalDocument.privacy),
        ),
        GoRoute(
          path: 'support',
          parentNavigatorKey: _rootKey,
          builder: (BuildContext context, GoRouterState state) =>
              const LegalPageScreen(document: LegalDocument.support),
        ),
      ],
    ),
  ],
);
