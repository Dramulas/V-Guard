import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:valorant/screens/dashboard_screen/dashboard_screen.dart';

final player = AudioPlayer();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    playMusic();
    _startAnimation();
    super.initState();
  }

  void playMusic() async {
    await player.setSourceAsset('lobby.mp3').then((value) {
      player.play(AssetSource('lobby.mp3'));
    });
    player.setReleaseMode(ReleaseMode.loop);
    // player.play();
  }

  bool animate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: animate ? 1 : 0,
                duration: const Duration(milliseconds: 3000),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/splash.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => animate = true);
    await Future.delayed(
      const Duration(milliseconds: 5000),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashBoardScreen(),
          ),
        );
      },
    );
  }
}
