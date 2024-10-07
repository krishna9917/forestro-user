import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/PhoneInputBox.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Components/Widgts/title_widget.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/innerpage/contact%20_supportverifiy.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:gap/gap.dart';

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
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text("Online Puja",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
            ),
            const Center(
              child: Text("Coming Soon",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primary)),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Welcome, Let's get started with your Online Puja. \nPlease provide some details about yourself",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputBox(
                    title: "Name",
                    controller: nameController,
                    hintText: "Enter Name ",
                    validator: (inp) {
                      if (inp!.isEmpty) {
                        return "Enter Your Name";
                      }
                      return null;
                    },
                  ),
                  TitleWidget(
                    title: "Puja Date",
                    child: TextFormField(
                      controller: pujaDateController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      decoration: const InputDecoration(
                        hintText: 'DD/MM/YYYY',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                    ),
                  ),
                  Gap(2.h),
                  TitleWidget(
                    title: "Puja Time",
                    child: TextFormField(
                      controller: birthtimeController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "12:00 PM",
                        hintStyle: const TextStyle(
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
                  const Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 5),
                    child: Text(
                      "Kind of Puja",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
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
                        });
                      },
                      hint: "Select",
                      initialItem: puja,
                    ),
                  ),
                  Gap(3.h),
                  InputBox(
                    title: "Please Write Your Issue",
                    hintText: "Write here...",
                  ),
                  Gap(2.h),
                  SizedBox(
                    width: scrWeight(context),
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          navigate.push(routeMe(const ContactVerifiction()));
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
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
