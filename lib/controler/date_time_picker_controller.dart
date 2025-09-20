import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateTimePickerController extends GetxController {
  // Date picker state
  var selectedDay = 1.obs;
  var selectedMonth = 1.obs;
  var selectedYear = 2000.obs;
  
  // Time picker state
  var selectedHour = 12.obs;
  var selectedMinute = 0.obs;
  var selectedSecond = 0.obs;
  var selectedPeriod = 1.obs; // 0 for AM, 1 for PM
  
  // Controllers for scroll views
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController secondController;
  late FixedExtentScrollController periodController;
  
  // English month names
  final List<String> englishMonths = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  
  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }
  
  void _initializeControllers() {
    dayController = FixedExtentScrollController(initialItem: selectedDay.value - 1);
    monthController = FixedExtentScrollController(initialItem: selectedMonth.value - 1);
    yearController = FixedExtentScrollController(initialItem: selectedYear.value - 1900);
    hourController = FixedExtentScrollController(initialItem: selectedHour.value - 1);
    minuteController = FixedExtentScrollController(initialItem: selectedMinute.value);
    secondController = FixedExtentScrollController(initialItem: selectedSecond.value);
    periodController = FixedExtentScrollController(initialItem: selectedPeriod.value);
  }
  
  void initializeWithDateTime(DateTime? date, TimeOfDay? time) {
    if (date != null) {
      selectedDay.value = date.day;
      selectedMonth.value = date.month;
      selectedYear.value = date.year;
      
      dayController.animateToItem(selectedDay.value - 1, 
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      monthController.animateToItem(selectedMonth.value - 1, 
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      yearController.animateToItem(selectedYear.value - 1900, 
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
    
    if (time != null) {
      selectedHour.value = time.hourOfPeriod;
      selectedMinute.value = time.minute;
      selectedSecond.value = 0;
      selectedPeriod.value = time.period == DayPeriod.am ? 0 : 1;
      
      hourController.animateToItem(selectedHour.value - 1, 
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      minuteController.animateToItem(selectedMinute.value, 
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      secondController.animateToItem(selectedSecond.value, 
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      periodController.animateToItem(selectedPeriod.value, 
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }
  
  void updateDay(int day) {
    selectedDay.value = day;
    _validateDate();
  }
  
  void updateMonth(int month) {
    selectedMonth.value = month;
    _validateDate();
  }
  
  void updateYear(int year) {
    selectedYear.value = year;
    _validateDate();
  }
  
  void updateHour(int hour) {
    selectedHour.value = hour;
  }
  
  void updateMinute(int minute) {
    selectedMinute.value = minute;
  }
  
  void updateSecond(int second) {
    selectedSecond.value = second;
  }
  
  void updatePeriod(int period) {
    selectedPeriod.value = period;
  }
  
  void _validateDate() {
    final daysInMonth = getDaysInMonth(selectedYear.value, selectedMonth.value);
    if (selectedDay.value > daysInMonth) {
      selectedDay.value = daysInMonth;
      dayController.animateToItem(selectedDay.value - 1, 
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }
  
  int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
  
  DateTime get selectedDate {
    return DateTime(selectedYear.value, selectedMonth.value, selectedDay.value);
  }
  
  TimeOfDay get selectedTime {
    final hour = selectedPeriod.value == 0 
        ? (selectedHour.value == 12 ? 0 : selectedHour.value)
        : (selectedHour.value == 12 ? 12 : selectedHour.value + 12);
    return TimeOfDay(hour: hour, minute: selectedMinute.value);
  }
  
  String get formattedDate {
    return '${selectedDay.value} ${englishMonths[selectedMonth.value - 1]} ${selectedYear.value}';
  }
  
  String get formattedTime {
    final hour = selectedPeriod.value == 0 
        ? (selectedHour.value == 12 ? 12 : selectedHour.value)
        : (selectedHour.value == 12 ? 12 : selectedHour.value);
    final period = selectedPeriod.value == 0 ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${selectedMinute.value.toString().padLeft(2, '0')}:${selectedSecond.value.toString().padLeft(2, '0')} $period';
  }
  
  @override
  void onClose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    periodController.dispose();
    super.onClose();
  }
}
