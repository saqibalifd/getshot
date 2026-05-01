import 'package:flutter/material.dart';
import 'package:getshotapp/constants/window_setup.dart';
import 'package:getshotapp/provider/admin_provider.dart';
import 'package:getshotapp/provider/screenshot_provider.dart';
import 'package:getshotapp/view/allUsers/all_users_view.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'your supabase project url',

    anonKey: 'your supabase project anonkey',
  );
  await WindowSetup.configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => ScreenshotProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: AllUsersView(),
      ),
    );
  }
}
