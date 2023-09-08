import 'package:flutter/material.dart';
import 'package:supabase_app/pages/chat_page.dart';
import 'package:supabase_app/pages/register.dart';
import 'package:supabase_app/util/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);

    // セッションが切れていたらログイン画面へ
    final session = supabase.auth.currentSession;
    if (session == null) {
      if (mounted) {
        Navigator.of(context)
            .pushAndRemoveUntil(RegisterPage.route(), (route) => false);
      }
    } else {
      if (mounted) {
        Navigator.of(context)
            .pushAndRemoveUntil(ChatPage.route(), (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: preloader);
  }
}
