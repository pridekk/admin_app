import 'package:admin_app/models/promotion_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class PromotionUsersScreen extends StatefulWidget {
  const PromotionUsersScreen({Key? key, required this.promotionCode}) : super(key: key);
  static const routeName = '/promotion_users';

  final PromotionCode promotionCode;
  @override
  State<PromotionUsersScreen> createState() => _PromotionUsersScreenState();
}

class _PromotionUsersScreenState extends State<PromotionUsersScreen> {

  final String? baseUrl = dotenv.env['ADMIN_API_BASE_URL'];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Text('프로모션: ${widget.promotionCode.code} 참여자'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.promotionCode.code),
          ],
        ),
      ),
    );
  }
}

