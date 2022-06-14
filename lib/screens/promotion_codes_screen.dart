import 'dart:io';

import 'package:admin_app/config/palette.dart';
import 'package:admin_app/models/admin_info.dart';
import 'package:admin_app/models/promotion_code.dart';
import 'package:admin_app/screens/promotion_users_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../components/promotion_code_form.dart';

class PromotionCodes extends StatefulWidget {
  const PromotionCodes({Key? key}) : super(key: key);

  @override
  State<PromotionCodes> createState() => _PromotionCodesState();
}

class _PromotionCodesState extends State<PromotionCodes> {
  final String? baseUrl = dotenv.env['ADMIN_API_BASE_URL'];
  var codes = <PromotionCode>[];
  int _currentSortColumn = 0;
  bool _isAscending = true;
  bool isLoaded = false;
  String token = "";



  void reloadPromotionCode(){
    setState(() {
      isLoaded = false;
    });
  }


  @override
  Widget build(BuildContext context) {

    token = context.watch<AdminInfo>().token;

    if(token.length > 3 && isLoaded == false){
      _getPromotionCodeList().then((value) {
        setState(() {
          codes = value;
          isLoaded = true;
        });
      }, onError: (e) {
        debugPrint(e.toString());
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 24.0,
            webShowClose: true,
            webPosition: "center");
      });
    }
    debugPrint("build PromotionCode $token");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Flexible(
              child: Text("프로모션 코드 리스트",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context)
                  {
                    return PromotionCodeForm(notifyParent: reloadPromotionCode,);
                  }
                  );
                },
                icon: const Icon(Icons.add_circle))
          ],
        ),
        Expanded(child: _getDataTable(codes)),
      ],
    );
  }

  Future<List<PromotionCode>> _getPromotionCodeList() async {
    List<PromotionCode> result = <PromotionCode>[];

    var url = Uri.parse('$baseUrl/api/v3/promotions?');

    var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    var codes = jsonDecode(utf8.decode(response.bodyBytes) );

    for (Map<String, dynamic> code in codes) {
      result.add(PromotionCode.fromJson(code));
    }

    return result;
  }


  Widget _getDataTable(List<PromotionCode> listOfData) {
    if (listOfData.length == 0) {
      return const Center(
        child: CircularProgressIndicator(

        ),
      );
    }

    List<DataRow> rows = [];

    listOfData.forEach((row) {
      rows.add(DataRow(cells: [
        DataCell(
          Text(row.code),
        ),
        DataCell(
          Text(row.startedAt),
        ),
        DataCell(
          Text("${row.expiredAt}"),
        ),
        DataCell(
          Checkbox(
            value: row.enabled,
            onChanged: (value){},
          ),
        ),
        DataCell(
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      PromotionUsersScreen.routeName,
                      arguments: row
                  );
                },
                child: Text(
                  "${row.users}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Palette.activeColor,
                  ),


                )
            ),
          ),
        ),
        DataCell(
           ElevatedButton(
            child: Icon(Icons.edit_note_rounded ),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context)
                  {
                    return PromotionCodeForm(code: row, notifyParent: reloadPromotionCode,);
                  }
              );
            }
          ),

        )
      ]));
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isAscending,
        columns: [
          const DataColumn(
            label: Text('Code'),
          ),
          DataColumn(
              label: Text('시작일'),
              // Sorting function
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isAscending == true) {
                    _isAscending = false;
                    // sort the product list in Ascending, order by Price
                    codes.sort((productA, productB) =>
                        productB.startedAt.compareTo(productA.startedAt));
                  } else {
                    _isAscending = true;
                    // sort the product list in Descending, order by Price
                    codes.sort((productA, productB) =>
                        productA.startedAt.compareTo(productB.startedAt));
                  }
                });
              }),
          const DataColumn(
            label: Text('만료일'),
          ),
          const DataColumn(
            label: Text('활성화'),
          ),
          const DataColumn(
            label: Text('등록수'),
          ),
          const DataColumn(label: Text("수정"))
        ],
        rows: rows,
      ),
    );
  }
}
