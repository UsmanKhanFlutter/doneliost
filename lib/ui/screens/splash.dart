import 'package:doneliost/core/constants/assets.dart';
import 'package:doneliost/ui/screens/task_screen/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'intro/introduction_screen_vm.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      checkApp();
    });
  }

  Future<void> checkApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? initScreen = prefs.getInt("initScreen");

    if (initScreen == 0 || initScreen == null) {
      Get.off(() => IntroductionScreenVm());
    } else {
      Get.off(() => const TasksScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppAssets.logo),
      ),
    );
  }
}
