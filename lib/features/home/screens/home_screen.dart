import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_flit/core/providers/providers.dart';
import 'package:riverpod_todo_flit/features/auth/controller/auth_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  logout() async {
    var prefs = await ref.watch(sharedPrefsProvider.future);
    ref.read(authControllerProvider.notifier).logOut(prefs, context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Home Screen"),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  logout();
                },
                child: const Text("Logout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
