import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controllers/task_controller.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/services/notification_services.dart';
import 'package:todoapp/services/theme_services.dart';
import 'package:todoapp/ui/pages/add_task_page.dart';
import 'package:todoapp/ui/theme.dart';
import 'package:todoapp/ui/widgets/button.dart';
import 'package:todoapp/ui/widgets/task_tile.dart';

import '../size_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions;
    notifyHelper.initializeNotification();
    taskController.getTasks();
  }

  DateTime _dateTime = DateTime.now();
  final TaskController taskController = Get.put(TaskController());
  bool c = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: _appbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 6),
          _showTasks(),
        ],
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().SwitchMode();

          // notifyHelper.displayNotification(
          //   title: "Mode ghange",
          //   body: "fdf",
          // );
          // notifyHelper.scheduledNotification();
        },
        icon: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.surface,
      actions: [

         IconButton(
         icon: Icon( Icons.cleaning_services_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,),
          onPressed: (){
           notifyHelper.canselsAllcheduledNotification();
             taskController.deleteAllTasks();
          },
        ),
       const Padding(
          padding:  EdgeInsets.only(right: 10),
          child: CircleAvatar(
            backgroundImage: AssetImage("images/person.jpeg"),
            radius: 23,
          ),
        ),
        
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: SubHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.to(() => const AddTaskPage());
                taskController.getTasks();
              }),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      // height: 85,
      margin: const EdgeInsets.only(left: 20, top: 6),
      child: DatePicker(
         DateTime.now(),
        width: 70,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryClr,
        )),
        dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryClr,
        )),
        monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: primaryClr,
        )),
        initialSelectedDate: _dateTime,
        onDateChange: (newvalue) {
          setState(() {
            _dateTime = newvalue;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                shrinkWrap: true,
                itemCount: taskController.taskList.length,
                itemBuilder: (BuildContext contextx, int index) {
                  var task = taskController.taskList[index];

                  if (task.repeat == "Daily" ||
                      task.date == DateFormat.yMd().format(_dateTime)||
                     ( task.repeat == "Weekly" && _dateTime.difference( DateFormat.yMd().parse(task.date!)).inDays %7==0)||
                      ( task.repeat == "Monthly" && DateFormat.yMd().parse(task.date!).day==_dateTime.day)
                      ) {
                    // var hour = task.startTime.toString().split(":")[0];
                    // var minutes = task.startTime.toString().split(":")[1];
                    // debugPrint("my time is" + hour);
                    // debugPrint("my minutes is" + minutes);
                    var date = DateFormat.jm().parse(task.startTime!);
                    var mytime = DateFormat("HH:mm").format(date);
                    notifyHelper.scheduledNotification(
                      int.parse(mytime.toString().split(":")[0]),
                      int.parse(mytime.toString().split(":")[1]),
                      task,
                    );
                    return AnimationConfiguration.staggeredList(
                      duration: const Duration(milliseconds: 600),
                      position: index,
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => showBottomSheet(
                              context,
                              task,
                            ),
                            child: TaskTile(
                              task,
                            ),
                          ),
                        ),
                      ),
                    );
                  }else{
                    return Container(height: 0);
                  }
                }),
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: SizeConfig.orientation == Orientation.landscape
                      ? Axis.horizontal
                      : Axis.vertical,
                  children: [
                    SizeConfig.orientation == Orientation.landscape
                        ? SizedBox(height: 6)
                        : SizedBox(height: 250),
                    SvgPicture.asset(
                      "images/task.svg",
                      color: primaryClr.withOpacity(0.5),
                      height: 90,
                      semanticsLabel: "Task",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Text(
                        "You don't have any tasks yet!\n Add new Tasks to make your days productive",
                        style: SubTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizeConfig.orientation == Orientation.landscape
                        ? SizedBox(height: 120)
                        : SizedBox(height: 180),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.25
                  : SizeConfig.screenHeight * 0.33),
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: "Task Completed",
                      onTap: () {
                         notifyHelper.canselscheduledNotification(task);
                        taskController.markusCompleted(task.id!);
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              _buildBottomSheet(
                label: "Delet Task",
                onTap: () {
                  
                  notifyHelper.canselscheduledNotification(task);
                  taskController.deleteTasks(task);
                  Get.back();
                },
                clr: Colors.red[300]!,
              ),
              Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
              _buildBottomSheet(
                label: "Cansel",
                onTap: () {
                  Get.back();
                },
                clr: primaryClr,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
