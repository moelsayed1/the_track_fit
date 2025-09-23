import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/promotional_offer_body.dart';

class PromotionalOfferScreen extends StatefulWidget {
  const PromotionalOfferScreen({super.key});

  @override
  State<PromotionalOfferScreen> createState() => _PromotionalOfferScreenState();
}

class _PromotionalOfferScreenState extends State<PromotionalOfferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 1.sw, // Full screen width
        height: 1.sh, // Full screen height
        child: const PromotionalOfferBody(),
      ),
    );
  }
}
