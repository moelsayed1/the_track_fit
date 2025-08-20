import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
// 0: Home, 1: Workout, 2: Scan, 3: Report, 4: Plan



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Center(child: Text("Plan Screen")),
  );
  }
}
