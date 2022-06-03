// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:admin_app/layout/adaptive.dart';
import 'package:admin_app/colors.dart';
import 'package:admin_app/routes.dart' as rally_route;

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Container(
        padding: EdgeInsets.only(top: isDisplayDesktop(context) ? 24 : 0),
        child: ListView(
          restorationId: 'settings_list_view',
          shrinkWrap: true,
          children: [
            for (String title
            in DummyDataService.getSettingsTitles(context)) ...[
              _SettingsItem(title),
              const Divider(
                color: RallyColors.dividerColor,
                height: 1,
              )
            ]
          ],
        ),
      ),
    );
  }


}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        Navigator.of(context).restorablePushNamed(rally_route.loginRoute);
      },
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
        child: Text(title),
      ),
    );
  }
}

class DummyDataService {
  static List<AccountData> getAccountDataList(BuildContext context) {
    return <AccountData>[
      AccountData(
        name: "1",
        primaryAmount: 2215.13,
        accountNumber: '1234561234',
      ),
      AccountData(
        name: "2",
        primaryAmount: 8678.88,
        accountNumber: '8888885678',
      ),
      AccountData(
        name: "3",
        primaryAmount: 987.48,
        accountNumber: '8888889012',
      ),
      AccountData(
        name: "4",
        primaryAmount: 253,
        accountNumber: '1231233456',
      ),
    ];
  }
  static List<String> getSettingsTitles(BuildContext context) {
    return <String>[
      "계정 관리",
      "세무 서류",
      "비밀번호 및 Touch ID"
    ];
  }

}

class AccountData {
  const AccountData({
  required this.name,
  required this.primaryAmount,
  required this.accountNumber,
  });

  /// The display name of this entity.
  final String name;

  /// The primary amount or value of this entity.
  final double primaryAmount;

  /// The full displayable account number.
  final String accountNumber;
}