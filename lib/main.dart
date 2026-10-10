
import 'package:flutter/material.dart';

void main() {
  runApp(const WarGameApp());
}

class WarGameApp extends StatelessWidget {
  const WarGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لعبة استراتيجية',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int gold = 0;
  int army = 0;

  void collectGold() {
    setState(() {
      gold += 10;
    });
  }

  void buyArmy() {
    if (gold >= 50) {
      setState(() {
        gold -= 50;
        army += 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الذهب لا يكفي! تحتاج 50 ذهبة لتجنيد جيش.', style: TextStyle(fontSize: 16)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text('معركة الموارد'),
        backgroundColor: Colors.blueGrey[800],
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'الموارد الحالية',
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      'الذهب: $gold',
                      style: const TextStyle(fontSize: 22, color: Colors.amber, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.security, color: Colors.blueAccent, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      'الجيش: $army',
                      style: const TextStyle(fontSize: 22, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 60),
            ElevatedButton.icon(
              onPressed: collectGold,
              icon: const Icon(Icons.add),
              label: const Text('جمع الذهب (+10)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: buyArmy,
              icon: const Icon(Icons.person_add),
              label: const Text('تجنيد جيش (50 ذهب)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
