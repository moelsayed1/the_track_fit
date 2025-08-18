import 'package:flutter/material.dart';
import 'package:the_track_fit/features/questions/weight/ui/widgets/weight_question_body.dart';

class WeightQuestionScreen extends StatelessWidget {
  const WeightQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: WeightQuestionBody(),
      ),
    );
  }
}
