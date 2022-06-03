import 'package:admin_app/models/promotion_code.dart';
import 'package:flutter/material.dart';

class PromotionCodeItem extends StatelessWidget {
  const PromotionCodeItem({Key? key, required this.code}) : super(key: key);

  final PromotionCode code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,


        children: [

          Text(
            code.code,),
          Text(code.startedAt),
          Text(code.expiredAt ?? ""),
          Checkbox(value: code.enabled, onChanged: (value){})

        ]
      ),
    );
  }
}