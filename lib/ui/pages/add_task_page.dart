// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print, empty_catches

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controllers/task_controller.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/ui/theme.dart';
import 'package:todoapp/ui/widgets/button.dart';
import 'package:todoapp/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController taskController = Get.put(TaskController());

  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _notecontroller = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _starttime = DateFormat("hh : mm a").format(DateTime.now()).toString();
  String _endtime = DateFormat("hh : mm a")
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindlist = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatlist = ["None", "Daily", "Weekly", "Monthly"];

  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: _appbar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              InputField(
                title: "Title",
                hint: "Enter title here",
                controller: _titlecontroller,
              ),
              InputField(
                title: "Note",
                hint: "Enter note here",
                controller: _notecontroller,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate).toString(),
                widget: IconButton(
                  onPressed: () => _getDatefromUser(),
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _starttime,
                      widget: IconButton(
                        onPressed: () => _getTimefromUser(isStarttime: true),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endtime,
                      widget: IconButton(
                        onPressed: () => _getTimefromUser(isStarttime: false),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: Row(
                  children: [
                    DropdownButton(
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.blueGrey,
                      items: remindlist
                          .map<DropdownMenuItem<String>>(
                            (element) => DropdownMenuItem<String>(
                              value: element.toString(),
                              child: Text(
                                "$element",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey,
                      ),
                      iconSize: 25,
                      elevation: 4,
                      underline: Container(height: 0),
                      style: SubTitleStyle,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedRemind = int.parse(value!);
                        });
                      },
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
              InputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    DropdownButton(
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.blueGrey,
                      items: repeatlist
                          .map<DropdownMenuItem<String>>(
                            (String element) => DropdownMenuItem<String>(
                              value: element,
                              child: Text(
                                element,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey,
                      ),
                      iconSize: 25,
                      elevation: 4,
                      underline: Container(height: 0),
                      style: SubTitleStyle,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedRepeat = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  colorpallete(),
                  MyButton(
                      label: "Creat Task",
                      onTap: () {
                        _validateDate();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 24,
          color: primaryClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.surface,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: CircleAvatar(
            backgroundImage: AssetImage("images/person.jpeg"),
            radius: 23,
          ),
        ),
      ],
    );
  }

  _validateDate() {
    if (_titlecontroller.text.isNotEmpty && _notecontroller.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titlecontroller.text.isEmpty || _notecontroller.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All Fields are Required",
        duration: const Duration(milliseconds: 2500),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.white : darkGreyClr,
        colorText: Get.isDarkMode ? darkGreyClr : Colors.white,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 30,
        ),
      );
    } else
      print("########### SOMETHING BAD HAPPENED ##########");
  }

  _addTasksToDb() async {
    try {
      int value = await taskController.addTask(
        task: Task(
          title: _titlecontroller.text,
          note: _notecontroller.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _starttime,
          endTime: _endtime,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
        ),
      );
      print("$value");
    } catch (e) {
      print("Error");
    }
  }

  Column colorpallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(height: 8),
        Wrap(
            children: List.generate(
          3,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: index == 0
                    ? bluishClr
                    : index == 1
                        ? pinkClr
                        : orangeClr,
                radius: 16,
                child: _selectedColor == index
                    ? const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ),
          ),
        )),
      ],
    );
  }

  _getDatefromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null)
      setState(() => _selectedDate = pickedDate);
    else
      print("it's null or somthing is wrong!");
  }

  _getTimefromUser({required bool isStarttime}) async {
    TimeOfDay? pickeTime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: isStarttime
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 15))));
    // ignore: use_build_context_synchronously
    String formattedTime = pickeTime!.format(context);

    if (isStarttime) {
      try {
        setState(() => _starttime = formattedTime);
      } catch (e) {}
    } else if (!isStarttime) {
      try {
        setState(() => _endtime = formattedTime);
      } catch (e) {}
    } else
      print("time cancled or somthing is wrong");
  }
}
