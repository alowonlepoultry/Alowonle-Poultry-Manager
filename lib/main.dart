import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router.dart';
import 'core/storage_service.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  runApp(
    ProviderScope(
      overrides: [storageServiceProvider.overrideWithValue(storageService)],
      child: const PoultryManagerApp(),
    ),
  );
}

class PoultryManagerApp extends ConsumerStatefulWidget {
  const PoultryManagerApp({super.key});

  @override
  ConsumerState<PoultryManagerApp> createState() => _PoultryManagerAppState();
}

class _PoultryManagerAppState extends ConsumerState<PoultryManagerApp> {
  bool _showSplash = true;

  void _onInitializationComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          onInitializationComplete: _onInitializationComplete,
        ),
      );
    }

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Safehand Poultry Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
