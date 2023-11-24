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

    DateTime focusedDay = DateTime.now();
    if (controller.spotDate.value != DateTime(0, 0, 0)) {
      focusedDay = controller.spotDate.value;
    }
    DateTime selectedDay = controller.spotDate.value;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "날짜와 시각, 날씨 정보를 확인해주세요.",
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 10,
            ),
            TableCalendar(
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              focusedDay: focusedDay,
              firstDay: DateTime(2010, 1, 1),
              lastDay: DateTime(2023, 12, 31),
              locale: 'ko-KR',
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              daysOfWeekHeight: 20,
              calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.grey),
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle // 현재 날짜의 배경을 투명으로 설정
                      ),
                  todayTextStyle: TextStyle(color: Colors.blueGrey),
                  selectedDecoration: BoxDecoration(
                      color: Colors.tealAccent, shape: BoxShape.circle),
                  selectedTextStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.teal)),
              onDaySelected: (newSelectedDay, newFocusedDay) {
                setState(() {
                  selectedDay = newSelectedDay;
                  focusedDay = newFocusedDay;
                  controller.spotDate.value = selectedDay;
                });
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TIME',
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                DropdownButton<int>(
                  value: controller.spotTimeHour.value,
                  items: List.generate(12, (index) => index)
                      .map((hour) => DropdownMenuItem<int>(
                            value: hour,
                            child: Text('${hour + controller.getStartHour()}'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      controller.spotTimeHour.value = value!;
                    });
                  },
                ),
                const Text(
                  '  :  ',
                  style: TextStyle(fontSize: 20),
                ),
                DropdownButton<int>(
                  value: controller.spotTimeMinute.value,
                  items: List.generate(60, (index) => index)
                      .map((minute) => DropdownMenuItem<int>(
                            value: minute,
                            child: Text('$minute'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      controller.spotTimeMinute.value = value!;
                    });
                  },
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
                  borderRadius: BorderRadius.circular(12.0),
                  selectedColor: Colors.black,
                  fillColor: Colors.tealAccent,
                  highlightColor: Colors.tealAccent,
                  constraints:
                      const BoxConstraints(minHeight: 35, minWidth: 35),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('AM'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('PM'),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    backgroundColor: Colors.blueGrey,
                    shadowColor: Colors.black,
                    minimumSize: const Size(50, 50),
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
                  child: const Center(
                      child: Text(
                    '확인',
                    style: TextStyle(color: Colors.white),
                  ))),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
