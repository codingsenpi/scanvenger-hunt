import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scanvenger_hunt_2/app/routes/app_pages.dart';
import 'package:scanvenger_hunt_2/app/utils/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/utils/initial_binding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> with WidgetsBindingObserver, RouteAware {
  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _hideSystemUI();
    }
  }

  @override
  void didPush() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    _hideSystemUI();
  }

  @override
  void didPopNext() {
    _hideSystemUI();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "ScanVenger Hunt",
      theme: AppTheme.pastelLightTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      navigatorObservers: [routeObserver],
    );
  }
}
