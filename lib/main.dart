import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const GrandStrategyApp());
}

class GrandStrategyApp extends StatelessWidget {
  const GrandStrategyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'عصر الإمبراطوريات',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        primaryColor: Colors.blueGrey,
      ),
      home: const MapScreen(),
    );
  }
}

class Province {
  String name;
  String owner; // 'player', 'enemy', 'ally'
  int army;
  int income;
  Color color;

  Province({
    required this.name,
    required this.owner,
    required this.army,
    required this.income,
    required this.color,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int playerGold = 150;
  int playerGlobalArmy = 60;
  int turn = 1;

  List<Province> worldMap = [
    Province(name: "الوطن (العراق)", owner: "player", army: 60, income: 25, color: Colors.green[700]!),
    Province(name: "الشام وتركيا", owner: "enemy", army: 80, income: 20, color: Colors.red[800]!),
    Province(name: "الخليج العربي", owner: "enemy", army: 70, income: 30, color: Colors.red[800]!),
    Province(name: "أوروبا الغربية", owner: "enemy", army: 130, income: 45, color: Colors.red[800]!),
    Province(name: "إيران والشرق", owner: "enemy", army: 110, income: 35, color: Colors.red[800]!),
    Province(name: "شمال إفريقيا", owner: "enemy", army: 90, income: 25, color: Colors.red[800]!),
  ];

  void nextTurn() {
    setState(() {
      turn++;
      
      // تحصيل الضرائب التلقائي من الأراضي المملوكة والحلفاء
      int totalIncome = 0;
      for (var p in worldMap) {
        if (p.owner == 'player') {
          totalIncome += p.income;
        } else if (p.owner == 'enemy') {
          p.army += Random().nextInt(12) + 5; // نمو جيوش الأعداء
        } else if (p.owner == 'ally') {
          totalIncome += (p.income ~/ 2);
          p.army += 8;
        }
      }
      playerGold += totalIncome;

      // أحداث عشوائية كل عدة أدوار
      if (turn % 3 == 0) {
        triggerRandomEvent();
      }
    });
  }

  void triggerRandomEvent() {
    int eventType = Random().nextInt(3);
    String eventTitle = "";
    String eventDesc = "";

    if (eventType == 0) {
      playerGold += 80;
      eventTitle = "ازدهار تجاري!";
      eventDesc = "تم اكتشاف خط قوافل تجارية جديد. حصلت على +80 ذهب.";
    } else if (eventType == 1) {
      playerGlobalArmy += 20;
      eventTitle = "موجة تطوع وطني!";
      eventDesc = "هبّ الشباب للدفاع عن الوطن. انضم +20 جندي لصفوفك.";
    } else {
      playerGold = (playerGold >= 40) ? playerGold - 40 : 0;
      eventTitle = "أزمة اقتصادية طارئة!";
      eventDesc = "تراجع في الأسواق أدى لخسارة 40 قطعة ذهبية.";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[900],
        title: Text(eventTitle, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        content: Text(eventDesc, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("مفهوم", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void showActionDialog(Province province) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900],
          title: Text(province.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text(
            "السيادة: ${province.owner == 'player' ? 'تحت سيطرتك' : province.owner == 'ally' ? 'حليف استراتيجي' : 'منطقة معادية'}\n"
            "قوة الحامية العسكرية: ${province.army}\n"
            "العائد الاقتصادي: +${province.income} ذهب/دور",
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          actions: [
            if (province.owner == 'player') ...[
              TextButton(
                onPressed: () {
                  setState(() {
                    playerGold += province.income * 2;
                  });
                  Navigator.pop(context);
                  nextTurn();
                },
                child: const Text("فرض ضرائب استثنائية", style: TextStyle(color: Colors.amber)),
              ),
              TextButton(
                onPressed: () {
                  if (playerGold >= 30) {
                    setState(() {
                      playerGold -= 30;
                      playerGlobalArmy += 35;
                    });
                    Navigator.pop(context);
                    nextTurn();
                  } else {
                    Navigator.pop(context);
                    showError("لا تملك ذهباً كافياً للتجنيد!");
                  }
                },
                child: const Text("تجنيد جيش مركزي (30 ذهب)", style: TextStyle(color: Colors.blueAccent)),
              ),
            ] else if (province.owner == 'enemy') ...[
              TextButton(
                onPressed: () {
                  handleAttack(province);
                  Navigator.pop(context);
                },
                child: const Text("إعلان الحرب والغزو", style: TextStyle(color: Colors.redAccent)),
              ),
              TextButton(
                onPressed: () {
                  if (playerGold >= 120) {
                    setState(() {
                      playerGold -= 120;
                      province.owner = 'ally';
                      province.color = Colors.blue[600]!;
                    });
                    Navigator.pop(context);
                    nextTurn();
                  } else {
                    Navigator.pop(context);
                    showError("تحتاج 120 ذهب لعقد معاهدة سلام وتحالف!");
                  }
                },
                child: const Text("عقد تحالف سياسي (120 ذهب)", style: TextStyle(color: Colors.cyanAccent)),
              ),
            ] else if (province.owner == 'ally') ...[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("منطقة حليفة ومؤمنة", style: TextStyle(color: Colors.grey)),
              ),
            ]
          ],
        );
      },
    );
  }

  void handleAttack(Province target) {
    if (playerGlobalArmy > target.army) {
      setState(() {
        playerGlobalArmy -= (target.army ~/ 1.8).toInt();
        target.owner = 'player';
        target.color = Colors.green[700]!;
        target.army = 15; // ترك حامية دفاعية خفيفة
      });
      showError("انتصار ساحق! تم ضم ${target.name} لسيادتك.", isSuccess: true);
    } else {
      setState(() {
        target.army -= (playerGlobalArmy ~/ 2).toInt();
        playerGlobalArmy = 0;
      });
      showError("انكسار عسكري! تصدت الحامية المعادية لجيشك ودمرته.");
    }
    nextTurn();
  }

  void showError(String msg, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        backgroundColor: isSuccess ? Colors.green[800] : Colors.red[800],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الدور العسكري: $turn | الإمبراطورية'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            color: Colors.blueGrey[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                    const SizedBox(height: 4),
                    Text('الخ
