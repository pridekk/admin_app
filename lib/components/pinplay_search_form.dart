import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PinPlaySearchBar extends StatefulWidget {
  PinPlaySearchBar(
      {Key? key,
      required this.notifyParent})
      : super(key: key);

  void Function(
      {String? query,
      bool? deleted,
      bool? private,
      bool? display,
      bool? admin,
      String? roomType,
      DateTime? startedFrom,
      DateTime? startedTo,
      DateTime? endedFrom,
      DateTime? endedTo}) notifyParent;

  @override
  State<PinPlaySearchBar> createState() => _PinPlaySearchBarState();
}

class _PinPlaySearchBarState extends State<PinPlaySearchBar> {
  final _formKey = GlobalKey<FormState>();

  String? query = "";
  bool? deleted;
  int deletedIndex =0;
  bool? private;
  int privateIndex = 0;
  bool? display;
  int displayIndex =0;
  bool? admin;
  int adminIndex = 0;
  String? roomType;
  int roomTypeIndex=0;
  DateTime? startedFrom;
  DateTime? startedTo;
  DateTime? endedFrom;
  DateTime? endedTo;

  void notify(){
    widget.notifyParent(
        query: query,
        deleted:deleted,
        private: private,
        display: display,
        admin: admin,
        roomType: roomType,
        startedFrom: startedFrom,
        startedTo: startedTo,
        endedFrom: endedFrom,
        endedTo: endedTo
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: query,
              decoration: const InputDecoration(
                hintText: '검색어 입력',
              ),
              onChanged: (value) {
                query = value;
                notify();
              },
            ),
          ),
          Row(
            children: [
              // 방종류
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("방종류"),
                    ToggleSwitch(
                      initialLabelIndex: roomTypeIndex,
                      totalSwitches: 3,
                      labels: ['전체', '개인', '공개'],
                      onToggle: (index) {
                        if(index == 0){
                          private = null;
                          roomTypeIndex = 0;
                        } else if(index ==1){
                          private = true;
                          roomTypeIndex = 1;
                        } else {
                          private = false;
                          roomTypeIndex = 2;
                        }
                        notify();
                      },
                    ),
                  ],
                ),
              ),
              // 개시유무
              Row(
                children: [
                  Text("개시유무"),
                  ToggleSwitch(
                    initialLabelIndex: displayIndex,
                    totalSwitches: 3,
                    labels: ['전체', '개시', '비개시'],
                    onToggle: (index) {
                      if(index == 0){
                        display = null;
                        displayIndex = 0;
                      } else if(index ==1){
                        display = true;
                        displayIndex = 1;
                      } else {
                        display = false;
                        displayIndex = 2;
                      }
                      notify();
                    },
                  ),
                ],
              ),
              // 삭제유무
              Row(
                children: [
                  Text("삭제유무"),
                  ToggleSwitch(
                    initialLabelIndex: deletedIndex,
                    totalSwitches: 3,
                    labels: ['전체', '삭제O', '삭제X'],
                    onToggle: (index) {
                      if(index == 0){
                        deleted = null;
                        deletedIndex = 0;
                      } else if(index ==1){
                        deleted = true;
                        deletedIndex = 1;
                      } else {
                        deleted = false;
                        deletedIndex = 2;
                      }
                      notify();
                    },
                  ),
                ],
              ),
              // 관리자, 사용자 생성유무
              Row(
                children: [
                  Text("생성자"),
                  ToggleSwitch(
                    initialLabelIndex: adminIndex,
                    totalSwitches: 3,
                    labels: ['전체', '관리자', '사용자'],
                    onToggle: (index) {
                      if(index == 0){
                        admin = null;
                        adminIndex = 0;
                      } else if(index ==1){
                        admin = true;
                        adminIndex = 1;
                      } else {
                        admin = false;
                        adminIndex = 2;
                      }
                      notify();
                    },
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              const Text("개임시작"),
              const Text("FROM"),
              Text(startedFrom != null
                  ? DateFormat("yyyy-MM-dd").format(startedFrom!)
                  : ''),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  var selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2030),
                  );

                  setState(() {
                    if (selectedDate != null) {
                      startedFrom = selectedDate;
                      notify();
                    }
                  });
                },
              ),
              const Text("TO"),
              Text(startedTo != null
                  ? DateFormat("yyyy-MM-dd").format(startedTo!)
                  : ''),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  var selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2030),
                  );

                  setState(() {
                    if (selectedDate != null) {
                      startedTo = selectedDate;
                      notify();
                    }
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text("개임종료"),
              const Text("FROM"),
              Text(endedFrom != null
                  ? DateFormat("yyyy-MM-dd").format(endedFrom!)
                  : ''),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  var selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2030),
                  );

                  setState(() {
                    if (selectedDate != null) {
                      endedFrom = selectedDate;
                      notify();
                    }
                  });
                },
              ),
              const Text("TO"),
              Text(endedTo != null
                  ? DateFormat("yyyy-MM-dd").format(endedTo!)
                  : ''),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  var selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2030),
                  );
                  setState(() {
                    if (selectedDate != null) {
                      endedTo = selectedDate;
                      notify();
                    }
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
