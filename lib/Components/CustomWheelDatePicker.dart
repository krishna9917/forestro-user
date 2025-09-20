import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomWheelDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final Function(DateTime) onDateSelected;
  final String title;

  const CustomWheelDatePicker({
    super.key,
    this.initialDate,
    this.minimumDate,
    this.maximumDate,
    required this.onDateSelected,
    this.title = "Select Date",
  });

  @override
  State<CustomWheelDatePicker> createState() => _CustomWheelDatePickerState();
}

class _CustomWheelDatePickerState extends State<CustomWheelDatePicker> {
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  late List<int> days;
  late List<int> months;
  late List<int> years;

  int selectedDay = 1;
  int selectedMonth = 1;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    final initialDate = widget.initialDate ?? DateTime.now();
    selectedDay = initialDate.day;
    selectedMonth = initialDate.month;
    selectedYear = initialDate.year;

    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController = FixedExtentScrollController(initialItem: 0);

    _initializeData();
  }

  void _initializeData() {
    months = List.generate(12, (index) => index + 1);

    final currentYear = DateTime.now().year;
    years = List.generate(111, (index) => currentYear - 100 + index);

    _updateDays();
  }

  void _updateDays() {
    final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    days = List.generate(daysInMonth, (index) => index + 1);

    if (selectedDay > daysInMonth) {
      selectedDay = daysInMonth;
    }

    dayController = FixedExtentScrollController(
      initialItem: selectedDay - 1,
    );
  }

  void _onDayChanged(int day) {
    setState(() {
      selectedDay = day + 1;
    });
  }

  void _onMonthChanged(int month) {
    setState(() {
      selectedMonth = month + 1;
      _updateDays();
    });
  }

  void _onYearChanged(int year) {
    setState(() {
      selectedYear = year;
      _updateDays();
    });
  }

  void _onConfirm() {
    final selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
    widget.onDateSelected(selectedDate);
    Get.back();
  }

  void _onCancel() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2C2C2C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "$selectedDay ${_getMonthName(selectedMonth)} $selectedYear",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Column headers
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Day',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Month',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Year',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Wheel picker
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: dayController,
                      itemExtent: 50,
                      onSelectedItemChanged: _onDayChanged,
                      children: days
                          .map((day) => Center(
                                child: Text(
                                  day.toString().padLeft(2, '0'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: monthController,
                      itemExtent: 50,
                      onSelectedItemChanged: _onMonthChanged,
                      children: months
                          .map((month) => Center(
                                child: Text(
                                  _getMonthName(month),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: yearController,
                      itemExtent: 50,
                      onSelectedItemChanged: (index) {
                        _onYearChanged(years[index]);
                      },
                      children: years
                          .map((year) => Center(
                                child: Text(
                                  year.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onCancel,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _onConfirm,
                    child: const Text(
                      'Select',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }
}

// Show date picker
Future<DateTime?> showCustomWheelDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? minimumDate,
  DateTime? maximumDate,
  String title = "Select Date",
}) {
  DateTime? selectedDate;

  return showDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: CustomWheelDatePicker(
        initialDate: initialDate,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
        title: title,
        onDateSelected: (date) {
          selectedDate = date;
        },
      ),
    ),
  ).then((result) => selectedDate);
}
