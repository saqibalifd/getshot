import 'package:flutter/material.dart';
import 'package:getshotapp/view/allUsers/all_users_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://yvpmthatdljrosekfxmy.supabase.co',

    anonKey: 'sb_publishable_lL0JO74hagaOAePdf1EZWQ_3gEi1iP9',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: AllUsersView(),
    );
  }
}
