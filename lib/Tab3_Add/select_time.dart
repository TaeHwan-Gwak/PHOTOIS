import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectTime extends StatefulWidget {
  const SelectTime({super.key});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put((PhotoSpotInfo()));
    final sizeController = Get.put((SizeController()));

    DateTime focusedDay = DateTime.now();
    if (controller.spotDate.value != DateTime(0, 0, 0)) {
      focusedDay = controller.spotDate.value;
    }
    DateTime selectedDay = controller.spotDate.value;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(sizeController.screenHeight.value * 0.05),
        child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false),
      ),
      body: Padding(
        padding: EdgeInsets.all(sizeController.screenHeight.value * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "날짜와 시각 정보를 확인해주세요.",
              style: TextStyle(fontSize: sizeController.bigFontSize.value),
            ),
            TableCalendar(
              rowHeight: sizeController.screenHeight.value * 0.07,
              daysOfWeekHeight: sizeController.screenHeight.value * 0.04,
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle:
                      TextStyle(fontSize: sizeController.mainFontSize.value),
                  weekendStyle:
                      TextStyle(fontSize: sizeController.mainFontSize.value)),
              headerStyle: HeaderStyle(
                  headerPadding: EdgeInsets.all(
                      sizeController.screenHeight.value * 0.0005),
                  titleTextStyle:
                      TextStyle(fontSize: sizeController.mainFontSize.value),
                  formatButtonTextStyle:
                      TextStyle(fontSize: sizeController.mainFontSize.value),
                  formatButtonVisible: false,
                  titleCentered: true),
              focusedDay: focusedDay,
              firstDay: DateTime(2010, 1, 1),
              lastDay: DateTime(2023, 12, 31),
              locale: 'ko-KR',
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: sizeController.middleFontSize.value),
                  weekendTextStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: sizeController.middleFontSize.value),
                  outsideDaysVisible: false,
                  todayDecoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle // 현재 날짜의 배경을 투명으로 설정
                      ),
                  todayTextStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: sizeController.middleFontSize.value),
                  selectedDecoration: const BoxDecoration(
                      color: Colors.tealAccent, shape: BoxShape.circle),
                  selectedTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                      fontSize: sizeController.middleFontSize.value)),
              onDaySelected: (newSelectedDay, newFocusedDay) {
                setState(() {
                  selectedDay = newSelectedDay;
                  focusedDay = newFocusedDay;
                  controller.spotDate.value = selectedDay;
                });
              },
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TIME',
                  style: TextStyle(fontSize: sizeController.mainFontSize.value),
                ),
                const Expanded(child: SizedBox()),
                DropdownButton<int>(
                  icon: Text("시",
                      style: TextStyle(
                          fontSize: sizeController.mainFontSize.value)),
                  value: controller.spotTimeHour.value,
                  items: List.generate(12, (index) => index)
                      .map((hour) => DropdownMenuItem<int>(
                            value: hour,
                            child: Text('${hour + controller.getStartHour()}',
                                style: TextStyle(
                                    fontSize:
                                        sizeController.mainFontSize.value)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      controller.spotTimeHour.value = value!;
                    });
                  },
                ),
                Text(
                  '  :  ',
                  style: TextStyle(fontSize: sizeController.mainFontSize.value),
                ),
                DropdownButton<int>(
                  icon: Text("분",
                      style: TextStyle(
                          fontSize: sizeController.mainFontSize.value)),
                  value: controller.spotTimeMinute.value,
                  items: List.generate(60, (index) => index)
                      .map((minute) => DropdownMenuItem<int>(
                            value: minute,
                            child: Text('$minute',
                                style: TextStyle(
                                    fontSize:
                                        sizeController.mainFontSize.value)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      controller.spotTimeMinute.value = value!;
                    });
                  },
                ),
                SizedBox(
                  width: sizeController.screenWidth.value * 0.03,
                ),
                ToggleButtons(
                  isSelected: controller.spotTimePeriod,
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < controller.spotTimePeriod.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          controller.spotTimePeriod[buttonIndex] = true;
                        } else {
                          controller.spotTimePeriod[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(5.0),
                  selectedColor: Colors.black,
                  fillColor: Colors.tealAccent,
                  highlightColor: Colors.tealAccent,
                  constraints: BoxConstraints(
                      minHeight: sizeController.screenHeight.value * 0.05,
                      minWidth: sizeController.screenWidth.value * 0.1),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sizeController.screenHeight.value * 0.02),
                      child: Text('AM',
                          style: TextStyle(
                              fontSize: sizeController.mainFontSize.value)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sizeController.screenHeight.value * 0.02),
                      child: Text('PM',
                          style: TextStyle(
                              fontSize: sizeController.mainFontSize.value)),
                    ),
                  ],
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    backgroundColor: Colors.blueGrey,
                    shadowColor: Colors.black,
                    minimumSize: Size(sizeController.screenWidth.value * 0.3,
                        sizeController.screenHeight.value * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    DateTime exDate = controller.spotDate.value;
                    controller.spotDate.value =
                        controller.spotTimePeriod[0] == true
                            ? DateTime(
                                exDate.year,
                                exDate.month,
                                exDate.day,
                                controller.spotTimeHour.value,
                                controller.spotTimeMinute.value)
                            : DateTime(
                                exDate.year,
                                exDate.month,
                                exDate.day,
                                controller.spotTimeHour.value + 12,
                                controller.spotTimeMinute.value);
                    Get.back();
                  },
                  child: Center(
                      child: Text(
                    '확인',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: sizeController.middleFontSize.value),
                  ))),
            ),
            SizedBox(
              height: sizeController.screenHeight * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
