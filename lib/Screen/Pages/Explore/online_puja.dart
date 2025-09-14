import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/PhoneInputBox.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Components/Widgts/title_widget.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/innerpage/contact%20_supportverifiy.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class OnlinePuja extends StatefulWidget {
  const OnlinePuja({super.key});

  @override
  State<OnlinePuja> createState() => _OnlinePujaState();
}

class _OnlinePujaState extends State<OnlinePuja>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthtimeController = TextEditingController();
  final TextEditingController pujaDateController = TextEditingController();

  String? puja;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    birthtimeController.dispose();
    pujaDateController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: [
            AnimatedBuilder(
              animation: _animation,
              child: Image.asset(
                "assets/icons/task-3.png",
                height: 70,
              ),
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + _animation.value * 0.2,
                  child: child,
                );
              },
            ),
            const SizedBox(height: 10),
             Center(
              child: Text("Online Puja",
                  style: GoogleFonts.inter(fontSize: 25, fontWeight: FontWeight.w700)),
            ),
             Center(
              child: Text("Coming Soon",
                  style: GoogleFonts.inter(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primary)),
            ),
             Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Welcome, Let's get started with your Online Puja. \nPlease provide some details about yourself",
                  style: GoogleFonts.inter(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name field
                  InputBox(
                    title: "Name",
                    controller: nameController,
                    hintText: "Enter Name",
                    validator: (inp) {
                      if (inp == null || inp.isEmpty) {
                        return "Enter Your Name";
                      }
                      return null;
                    },
                  ),
                  // Puja Date field
                  TitleWidget(
                    title: "Puja Date",
                    child: TextFormField(
                      controller: pujaDateController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Puja date';
                        }
                        return null;
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                          setState(() {
                            pujaDateController.text = formattedDate;
                          });
                        }
                      },
                      keyboardType: TextInputType.datetime,
                      decoration:  InputDecoration(
                        hintText: 'DD/MM/YYYY',
                        hintStyle:GoogleFonts.inter(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                    ),
                  ),
                  Gap(2.h),
                  // Puja Time field
                  TitleWidget(
                    title: "Puja Time",
                    child: TextFormField(
                      controller: birthtimeController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Puja time';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "12:00 PM",
                        hintStyle: GoogleFonts.inter(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              String formattedTime = pickedTime.format(context);
                              setState(() {
                                birthtimeController.text = formattedTime;
                              });
                            }
                          },
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  Gap(2.h),
                  // Kind of Puja selection field wrapped in a FormField
                   Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 5),
                    child: Text(
                      "Kind of Puja",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                  FormField<String>(
                    initialValue: puja,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a type of Puja';
                      }
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: SelectBox(
                              list: const [
                                "Hindu Puja",
                                "Havan",
                                "Yagna",
                                "Pitra Paksha",
                                "Navratri",
                                "Diwali",
                                "Holi",
                                "Makar Sankranti",
                                "Kumbh Mela",
                                "Rudra Abhisek",
                                "Ganesh Chaturthi",
                                "Durga Puja",
                                "Janmashtami"
                              ],
                              onChanged: (e) {
                                setState(() {
                                  puja = e;
                                  state.didChange(e);
                                });
                              },
                              hint: "Select",
                              initialItem: puja,
                            ),
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 5),
                              child: Text(
                                state.errorText!,
                                style:GoogleFonts.inter(color: Colors.red),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  Gap(3.h),
                  // Issue description field
                  InputBox(
                    title: "Please Write Your Issue",
                    hintText: "Write here...",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe your issue';
                      }
                      return null;
                    },
                  ),
                  Gap(2.h),
                  // Submit button
                  SizedBox(
                    width: scrWeight(context),
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          navigate.push(routeMe(const ContactVerifiction()));
                        }
                      },
                      child:  Text(
                        "Submit",
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
