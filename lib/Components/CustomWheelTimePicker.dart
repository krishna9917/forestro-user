import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomWheelTimePicker extends StatefulWidget {
  final TimeOfDay? initialTime;
  final Function(TimeOfDay) onTimeSelected;
  final String title;

  const CustomWheelTimePicker({
    super.key,
    this.initialTime,
    required this.onTimeSelected,
    this.title = "Select Time",
  });

  @override
  State<CustomWheelTimePicker> createState() => _CustomWheelTimePickerState();
}

class _CustomWheelTimePickerState extends State<CustomWheelTimePicker> {
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController secondController;
  late FixedExtentScrollController periodController;

  late List<int> hours;
  late List<int> minutes;
  late List<int> seconds;
  late List<String> periods;

  int selectedHour = 12;
  int selectedMinute = 0;
  int selectedSecond = 0;
  int selectedPeriod = 0; // 0 for AM, 1 for PM

  @override
  void initState() {
    super.initState();

    // Initialize with current time or provided initial time
    final initialTime = widget.initialTime ?? TimeOfDay.now();
    selectedHour =
        initialTime.hourOfPeriod == 0 ? 12 : initialTime.hourOfPeriod;
    selectedMinute = initialTime.minute;
    selectedSecond = 0; // Default to 0 seconds
    selectedPeriod = initialTime.period == DayPeriod.am ? 0 : 1;

    // Initialize scroll controllers
    hourController = FixedExtentScrollController(initialItem: selectedHour - 1);
    minuteController = FixedExtentScrollController(initialItem: selectedMinute);
    secondController = FixedExtentScrollController(initialItem: selectedSecond);
    periodController = FixedExtentScrollController(initialItem: selectedPeriod);

    _initializeData();
  }

  void _initializeData() {
    hours = List.generate(12, (index) => index + 1); // 1-12
    minutes = List.generate(60, (index) => index); // 0-59
    seconds = List.generate(60, (index) => index); // 0-59
    periods = ['AM', 'PM'];
  }

  void _onHourChanged(int hour) {
    setState(() {
      selectedHour = hour + 1;
    });
  }

  void _onMinuteChanged(int minute) {
    setState(() {
      selectedMinute = minute;
    });
  }

  void _onSecondChanged(int second) {
    setState(() {
      selectedSecond = second;
    });
  }

  void _onPeriodChanged(int period) {
    setState(() {
      selectedPeriod = period;
    });
  }

  void _onConfirm() {
    final hour24 = (selectedHour % 12) + (selectedPeriod == 0 ? 0 : 12);
    final selectedTime = TimeOfDay(
      hour: hour24,
      minute: selectedMinute,
    );
    widget.onTimeSelected(selectedTime);
    Get.back();
  }

  void _onCancel() {
    Get.back();
  }

  String _formatTime() {
    final period = selectedPeriod == 0 ? 'AM' : 'PM';
    return "${selectedHour.toString().padLeft(2, '0')}:"
        "${selectedMinute.toString().padLeft(2, '0')}:"
        "${selectedSecond.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C), // Dark gray background
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header with selected time display
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
                    Icons.access_time,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatTime(),
                    style:  GoogleFonts.inter(
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
                      'Hour',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Minute',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Second',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),

            // Wheel picker
            Expanded(
              child: Row(
                children: [
                  // Hour picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: hourController,
                      itemExtent: 50,
                      onSelectedItemChanged: _onHourChanged,
                      children: hours
                          .map((hour) => Center(
                                child: Text(
                                  hour.toString().padLeft(2, '0'),
                                  style:  GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  // Minute picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: minuteController,
                      itemExtent: 50,
                      onSelectedItemChanged: _onMinuteChanged,
                      children: minutes
                          .map((minute) => Center(
                                child: Text(
                                  minute.toString().padLeft(2, '0'),
                                  style:  GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  // Second picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: secondController,
                      itemExtent: 50,
                      onSelectedItemChanged: _onSecondChanged,
                      children: seconds
                          .map((second) => Center(
                                child: Text(
                                  second.toString().padLeft(2, '0'),
                                  style:  GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  // Period picker (AM/PM)
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: periodController,
                      itemExtent: 50,
                      onSelectedItemChanged: _onPeriodChanged,
                      children: periods
                          .map((period) => Center(
                                child: Text(
                                  period,
                                  style:  GoogleFonts.inter(
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
                    child:  Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _onConfirm,
                    child:  Text(
                      'Confirm',
                      style: GoogleFonts.inter(
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

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    periodController.dispose();
    super.dispose();
  }
}

// Helper function to show the time picker
Future<TimeOfDay?> showCustomWheelTimePicker({
  required BuildContext context,
  TimeOfDay? initialTime,
  String title = "Select Time",
}) {
  TimeOfDay? selectedTime;

  return showDialog<TimeOfDay>(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: CustomWheelTimePicker(
        initialTime: initialTime,
        title: title,
        onTimeSelected: (time) {
          selectedTime = time;
        },
      ),
    ),
  ).then((result) => selectedTime);
}
