import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photois/Main/data.dart';
import 'package:photois/style/style.dart';
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
      backgroundColor: AppColor.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "날짜 및 시간 조정",
            style: TextStyle(
                fontSize: sizeController.mainFontSize.value,
                fontWeight: FontWeight.w700,
                color: AppColor.textColor),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(
            color: AppColor.objectColor,
            thickness: 3, // 줄의 색상 설정
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(sizeController.screenHeight.value * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizeController.screenHeight.value * 0.05,
              child: Center(
                child: Text(
                  "\"사진 명소의 자세한 날짜와 시간으로 조정해주세요\"",
                  style: TextStyle(
                      fontSize: sizeController.middleFontSize.value,
                      fontWeight: FontWeight.w300,
                      color: AppColor.textColor),
                ),
              ),
            ),
            TableCalendar(
              daysOfWeekHeight: sizeController.screenHeight.value * 0.05,
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      color: AppColor.textColor),
                  weekendStyle: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      color: AppColor.textColor)),
              headerStyle: HeaderStyle(
                  leftChevronIcon: const Icon(Icons.chevron_left,
                      color: AppColor.objectColor),
                  rightChevronIcon: const Icon(Icons.chevron_right,
                      color: AppColor.objectColor),
                  titleTextStyle: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      color: AppColor.textColor),
                  formatButtonTextStyle: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      color: AppColor.textColor),
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
                  tableBorder: const TableBorder(
                    top: BorderSide(color: AppColor.textColor),
                    right: BorderSide(color: AppColor.textColor),
                    bottom: BorderSide(color: AppColor.textColor),
                    left: BorderSide(color: AppColor.textColor),
                    horizontalInside: BorderSide(color: AppColor.textColor),
                    verticalInside: BorderSide(color: AppColor.textColor),
                    borderRadius: BorderRadius.zero,
                  ),
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(
                      color: AppColor.textColor,
                      fontSize: sizeController.middleFontSize.value),
                  weekendTextStyle: TextStyle(
                      color: AppColor.textColor,
                      fontSize: sizeController.middleFontSize.value),
                  todayDecoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle // 현재 날짜의 배경을 투명으로 설정
                      ),
                  todayTextStyle: TextStyle(
                      color: AppColor.textColor,
                      fontSize: sizeController.middleFontSize.value),
                  selectedDecoration: const BoxDecoration(
                      color: AppColor.objectColor, shape: BoxShape.circle),
                  selectedTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.backgroundColor,
                      fontSize: sizeController.middleFontSize.value)),
              onDaySelected: (newSelectedDay, newFocusedDay) {
                setState(() {
                  selectedDay = newSelectedDay;
                  focusedDay = newFocusedDay;
                  controller.spotDate.value = selectedDay;
                });
              },
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TIME',
                  style: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textColor),
                ),
                const Expanded(child: SizedBox()),
                DropdownButton<int>(
                  dropdownColor: AppColor.backgroundColor,
                  icon: Text(
                    "시",
                    style: TextStyle(
                        fontSize: sizeController.mainFontSize.value,
                        fontWeight: FontWeight.w300,
                        color: AppColor.textColor),
                  ),
                  value: controller.spotTimeHour.value,
                  items: List.generate(12, (index) => index)
                      .map((hour) => DropdownMenuItem<int>(
                            value: hour,
                            child: Text(
                              '${hour + controller.getStartHour()}',
                              style: TextStyle(
                                  fontSize: sizeController.mainFontSize.value,
                                  fontWeight: FontWeight.w300,
                                  color: AppColor.textColor),
                            ),
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
                  style: TextStyle(
                      fontSize: sizeController.mainFontSize.value,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textColor),
                ),
                DropdownButton<int>(
                  dropdownColor: AppColor.backgroundColor,
                  icon: Text(
                    "분",
                    style: TextStyle(
                        fontSize: sizeController.mainFontSize.value,
                        fontWeight: FontWeight.w300,
                        color: AppColor.textColor),
                  ),
                  value: controller.spotTimeMinute.value,
                  items: List.generate(60, (index) => index)
                      .map((minute) => DropdownMenuItem<int>(
                            value: minute,
                            child: Text(
                              '$minute',
                              style: TextStyle(
                                  fontSize: sizeController.mainFontSize.value,
                                  fontWeight: FontWeight.w300,
                                  color: AppColor.textColor),
                            ),
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
                  borderRadius: BorderRadius.circular(10.0),
                  fillColor: AppColor.objectColor,
                  constraints: BoxConstraints(
                    minHeight: sizeController.screenHeight.value * 0.05,
                    minWidth: sizeController.screenWidth.value * 0.1,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizeController.screenHeight.value * 0.02,
                      ),
                      child: Text(
                        'AM',
                        style: TextStyle(
                            fontSize: sizeController.middleFontSize.value,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizeController.screenHeight.value * 0.02,
                      ),
                      child: Text(
                        'PM',
                        style: TextStyle(
                            fontSize: sizeController.middleFontSize.value,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Expanded(child: SizedBox()),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColor.objectColor,
                backgroundColor: AppColor.objectColor,
                shadowColor: AppColor.objectColor,
                minimumSize: Size(
                  sizeController.screenWidth.value * 0.6,
                  sizeController.screenHeight.value * 0.05,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                DateTime exDate = controller.spotDate.value;
                controller.spotDate.value = controller.spotTimePeriod[0] == true
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
                  '날짜 및 시간 설정',
                  style: TextStyle(
                      fontSize: sizeController.middleFontSize.value,
                      fontWeight: FontWeight.w500,
                      color: AppColor.backgroundColor),
                ),
              ),
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
