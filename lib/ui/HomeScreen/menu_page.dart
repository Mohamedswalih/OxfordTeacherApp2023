import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/database_helper.dart';
import '../../Database/database_model.dart';
import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../LoginPage/google_signin_api.dart';
import '../LoginPage/login.dart';
import 'menu_model.dart';

class MenuItems {
  static const myClasses = MenuItem("My Classes", Icons.class_outlined);
  static const timetable = MenuItem("My Timetable", Icons.timeline_outlined);
  static const Leave = MenuItem("Leave Request", Icons.badge_outlined,);
  static const ObservatioResult = MenuItem("Observation Results", Icons.badge_outlined);

  //static const  reports = MenuItem("Reports", Icons.help_outline);
  //static const profile = MenuItem("Profile", Icons.account_circle_outlined);

  static const all = <MenuItem>[
    myClasses,
    timetable,
    Leave,
    ObservatioResult,

    //reports,
    // profile
  ];
  static const notall = <MenuItem>[
    myClasses,
    timetable,
    ObservatioResult,



    //reports,
    // profile
  ];
}

class MenuPage extends StatefulWidget {
  final MenuItem? currentItem;
  final ValueChanged<MenuItem>? onSelected;
  String? name;
  String? ptofileImage;
  var isAClassTeacher;
  var academicYear;
  var user_id;
  var schoolId;
  var notclassteacher;
  bool? isclassTEACHER;

  MenuPage(
      {this.currentItem,
      this.onSelected,
      this.name,
      this.notclassteacher,
      this.ptofileImage,
      this.isAClassTeacher,
      this.academicYear,
      this.user_id,
      this.isclassTEACHER,
      this.schoolId});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var duplicateTeacherData = [];
  var newTeacherDatamenupage;
  var teacherData = [];
  var employeeUnderHOS = [];
  var classB = [];
  var getmenuteacher;
  bool isSpinner = false;
Future addToLocalDb() async {
print("database created");

String newTeacher = jsonEncode(teacherData);
String newEmployeeData = jsonEncode(employeeUnderHOS);
String newOtherTeacherData = jsonEncode(classB);

final loginData = LoginData(
onlyTeacherData: newTeacher,
    otherTeacherData: newOtherTeacherData,
    employeeUnderHead: newEmployeeData);

await LoginDatabase.instance.create(loginData);
}
  Map<String, dynamic>? loginCredential;
  bool? isclassteachermenupage;
  // getclassteacher() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   isclassteachermenupage = preferences.getBool('isclassteacher');
  //   print('---classteacher menupage5---------------->$isclassteachermenupage');
  // }

  @override
  void initState() {
    print('notclassteachernotclassteachermenupage${widget.notclassteacher}');
    print('isAClassTeachernotclassteachermenupage${widget.isAClassTeacher}');
    print('isAClassTeachernotclassteachermenupage${widget.isAClassTeacher}');
    print('isclassTEACHERisclassTEACHER${widget.isclassTEACHER}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.fill,
              )),
          widget.isclassTEACHER!= true ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DrawerHeader(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Hello,",
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: 15.sp,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            width: 150.w,
                            height: 70.h,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.name.toString(),
                                style: TextStyle(
                                    fontFamily: "WorkSans",
                                    fontSize: 15.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFFD6E4FA)),
                          image: DecorationImage(
                              image: NetworkImage(widget.ptofileImage == ""
                                  ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                  : ApiConstants.IMAGE_BASE_URL +
                                  "${widget.ptofileImage}"),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //     margin: EdgeInsets.only(left: 20.w),
                //     child: Image.asset("assets/images/dashboard.png")),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Text(
                    'Teacher',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                ...MenuItems.notall.map(buildMenuItem).toList(),
                // widget.isAClassTeacher == null
                //     ? Text("")
                // : Column(
                //   children: [
                //     if(widget.isAClassTeacher.length == 1)
                //       GestureDetector(
                //         onTap: () {
                //           NavigationUtils.goNext(
                //               context, StudentProfileListView(
                //             ClassAndBatch: widget.isAClassTeacher[0]["class"],
                //             name: widget.name,
                //             image: widget.ptofileImage,
                //             academicYear: widget.academicYear,
                //             userId: widget.user_id,
                //             classId: widget.isAClassTeacher[0]["class_id"],
                //             batchId: widget.isAClassTeacher[0]["batch_id"],
                //             curriculumId: widget.isAClassTeacher[0]["curriculumId"],
                //             schoolId: widget.schoolId,
                //             sessionId: widget.isAClassTeacher[0]["session_id"],
                //           ));
                //         },
                //         child: Container(
                //           width: 154.w,
                //           height: 50.h,
                //           margin: EdgeInsets.only(left: 14.w),
                //           child: Row(
                //             children: [
                //               Container(
                //                 child: Icon(
                //                   Icons.edit,
                //                   color: Colors.white,
                //                 ),
                //               ),
                //               width >= 590 ? SizedBox(
                //                 width: 10.w,
                //               ) : SizedBox(
                //                 width: 13.w,
                //               ),
                //               width >= 590 ? Container(
                //                 child: Text(
                //                   "Manage Profile",
                //                   style: TextStyle(
                //                       color: Colors.white, fontSize: 10.sp),
                //                 ),
                //               ) : Container(
                //                 child: Text(
                //                   "Manage Profile",
                //                   style: TextStyle(
                //                       color: Colors.white, fontSize: 16.sp),
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     if(widget.isAClassTeacher.length > 1)
                //       ExpansionTile(
                //         title: Transform.translate(
                //           offset: Offset(-16, 0),
                //           child: width >= 590 ? Text(
                //             "Manage Profile",
                //             style:
                //             TextStyle(color: Colors.white, fontSize: 10.sp),
                //           ) : Text(
                //             "Manage Profile",
                //             style:
                //             TextStyle(color: Colors.white, fontSize: 16.sp),
                //           ),
                //         ),
                //         leading: const Icon(
                //           Icons.edit,
                //           color: Colors.white,
                //         ),
                //         children: [
                //           ListView.builder(
                //               shrinkWrap: true,
                //               itemCount: widget.isAClassTeacher.length,
                //               itemBuilder: (BuildContext context, int index) {
                //                 return GestureDetector(
                //                   onTap: (){
                //                     NavigationUtils.goNext(context, StudentProfileListView(
                //                       ClassAndBatch: widget.isAClassTeacher[index]["class"],
                //                       name: widget.name,
                //                       image: widget.ptofileImage,
                //                       academicYear: widget.academicYear,
                //                       userId: widget.user_id,
                //                       classId: widget.isAClassTeacher[index]["class_id"],
                //                       batchId: widget.isAClassTeacher[index]["batch_id"],
                //                       curriculumId: widget.isAClassTeacher[index]["curriculumId"],
                //                       schoolId: widget.schoolId,
                //                       sessionId: widget.isAClassTeacher[index]["session_id"],
                //                     ));
                //                   },
                //                   child: Column(
                //                     children: [
                //                       Container(
                //                           margin: const EdgeInsets.all(8.0),
                //                           child: Row(
                //                             children: [
                //                               SizedBox(width: 170.w,),
                //                               Text(
                //                                 widget.isAClassTeacher[index]["class"],
                //                                 style: const TextStyle(color: Colors.white),
                //                               ),
                //                               const Icon(Icons.navigate_next,color: Colors.white,)
                //                             ],
                //                           ))
                //                     ],
                //                   ),
                //                 );
                //               })
                //         ],
                //       ),
                //   ],
                // ),
                Spacer(),
                Center(
                  child: Text(
                    'Version ${ApiConstants.Version}',
                    style: TextStyle(
                        color: Colors.white, fontSize: 10.sp),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _logout(context);
                  },
                  child: Container(
                    width: 100.w,
                    height: 50.h,
                    margin: EdgeInsets.only(left: 20.w),
                    child: Row(
                      children: [
                        Container(
                          child: Image.asset("assets/images/signoutIcon.png"),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Container(
                          child: width >= 590
                              ? Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.white, fontSize: 10.sp),
                          )
                              : Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.sp),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ) :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DrawerHeader(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Hello,",
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: 15.sp,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            width: 150.w,
                            height: 70.h,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.name.toString(),
                                style: TextStyle(
                                    fontFamily: "WorkSans",
                                    fontSize: 15.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFFD6E4FA)),
                          image: DecorationImage(
                              image: NetworkImage(widget.ptofileImage == ""
                                  ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                  : ApiConstants.IMAGE_BASE_URL +
                                  "${widget.ptofileImage}"),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //     margin: EdgeInsets.only(left: 20.w),
                //     child: Image.asset("assets/images/dashboard.png")),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Text(
                    'Teacher',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                ...MenuItems.all.map(buildMenuItem).toList(),
                // widget.isAClassTeacher == null
                //     ? Text("")
                // : Column(
                //   children: [
                //     if(widget.isAClassTeacher.length == 1)
                //       GestureDetector(
                //         onTap: () {
                //           NavigationUtils.goNext(
                //               context, StudentProfileListView(
                //             ClassAndBatch: widget.isAClassTeacher[0]["class"],
                //             name: widget.name,
                //             image: widget.ptofileImage,
                //             academicYear: widget.academicYear,
                //             userId: widget.user_id,
                //             classId: widget.isAClassTeacher[0]["class_id"],
                //             batchId: widget.isAClassTeacher[0]["batch_id"],
                //             curriculumId: widget.isAClassTeacher[0]["curriculumId"],
                //             schoolId: widget.schoolId,
                //             sessionId: widget.isAClassTeacher[0]["session_id"],
                //           ));
                //         },
                //         child: Container(
                //           width: 154.w,
                //           height: 50.h,
                //           margin: EdgeInsets.only(left: 14.w),
                //           child: Row(
                //             children: [
                //               Container(
                //                 child: Icon(
                //                   Icons.edit,
                //                   color: Colors.white,
                //                 ),
                //               ),
                //               width >= 590 ? SizedBox(
                //                 width: 10.w,
                //               ) : SizedBox(
                //                 width: 13.w,
                //               ),
                //               width >= 590 ? Container(
                //                 child: Text(
                //                   "Manage Profile",
                //                   style: TextStyle(
                //                       color: Colors.white, fontSize: 10.sp),
                //                 ),
                //               ) : Container(
                //                 child: Text(
                //                   "Manage Profile",
                //                   style: TextStyle(
                //                       color: Colors.white, fontSize: 16.sp),
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     if(widget.isAClassTeacher.length > 1)
                //       ExpansionTile(
                //         title: Transform.translate(
                //           offset: Offset(-16, 0),
                //           child: width >= 590 ? Text(
                //             "Manage Profile",
                //             style:
                //             TextStyle(color: Colors.white, fontSize: 10.sp),
                //           ) : Text(
                //             "Manage Profile",
                //             style:
                //             TextStyle(color: Colors.white, fontSize: 16.sp),
                //           ),
                //         ),
                //         leading: const Icon(
                //           Icons.edit,
                //           color: Colors.white,
                //         ),
                //         children: [
                //           ListView.builder(
                //               shrinkWrap: true,
                //               itemCount: widget.isAClassTeacher.length,
                //               itemBuilder: (BuildContext context, int index) {
                //                 return GestureDetector(
                //                   onTap: (){
                //                     NavigationUtils.goNext(context, StudentProfileListView(
                //                       ClassAndBatch: widget.isAClassTeacher[index]["class"],
                //                       name: widget.name,
                //                       image: widget.ptofileImage,
                //                       academicYear: widget.academicYear,
                //                       userId: widget.user_id,
                //                       classId: widget.isAClassTeacher[index]["class_id"],
                //                       batchId: widget.isAClassTeacher[index]["batch_id"],
                //                       curriculumId: widget.isAClassTeacher[index]["curriculumId"],
                //                       schoolId: widget.schoolId,
                //                       sessionId: widget.isAClassTeacher[index]["session_id"],
                //                     ));
                //                   },
                //                   child: Column(
                //                     children: [
                //                       Container(
                //                           margin: const EdgeInsets.all(8.0),
                //                           child: Row(
                //                             children: [
                //                               SizedBox(width: 170.w,),
                //                               Text(
                //                                 widget.isAClassTeacher[index]["class"],
                //                                 style: const TextStyle(color: Colors.white),
                //                               ),
                //                               const Icon(Icons.navigate_next,color: Colors.white,)
                //                             ],
                //                           ))
                //                     ],
                //                   ),
                //                 );
                //               })
                //         ],
                //       ),
                //   ],
                // ),
                Spacer(),
                Center(
                  child: Text(
                    'Version ${ApiConstants.Version}',
                    style: TextStyle(
                        color: Colors.white, fontSize: 10.sp),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _logout(context);
                  },
                  child: Container(
                    width: 100.w,
                    height: 50.h,
                    margin: EdgeInsets.only(left: 20.w),
                    child: Row(
                      children: [
                        Container(
                          child: Image.asset("assets/images/signoutIcon.png"),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Container(
                          child: width >= 590
                              ? Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.white, fontSize: 10.sp),
                          )
                              : Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.sp),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )

        ],
      ),
    );
  }

  _logout(context) {
    return Alert(
      context: context,
      type: AlertType.info,
      title: "Are you sure you want to logout?",
      style: const AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          color: ColorUtils.BLUE,
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.remove("school_token");
            preferences.remove("count");
            preferences.remove("email");
            preferences.remove('userID');
            preferences.remove('employeeNumber');
            preferences.remove('name');
            preferences.remove('designation');
            preferences.remove("classData");
            preferences.remove("employeeData");
            preferences.remove("teacherData");
            preferences.remove("school_id");
            preferences.remove("images");
            preferences.remove("teacher");
            preferences.remove("hos");
            NavigationUtils.goNextFinishAll(context, LoginPage());
          },
          // print(widget.academicyear);
          //width: 120,
        ),
        DialogButton(
          color: ColorUtils.BLUE,
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          // print(widget.academicyear);
          //width: 120,
        )
      ],
    ).show();
  }

  Widget buildMenuItem(MenuItem item) {
    return ListTileTheme(
      selectedColor: Colors.white,
      child: ListTile(
        selectedTileColor: Colors.black26,
        selected: widget.currentItem == item,
        minLeadingWidth: 20.w,
        leading: Icon(
          item.icons,
          color: Colors.white,
        ),
        title: Text(
          item.title,
          style: TextStyle(color: Colors.white),
        ),
        onTap: () => widget.onSelected!(item),
      ),
    );
  }
_checkInternet(context) {
  return Alert(
    context: context,
    type: AlertType.warning,
    title: "No Internet",
    style: const AlertStyle(
        isCloseButton: false,
        titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
    buttons: [
      DialogButton(
        child: const Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        // print(widget.academicyear);
        //width: 120,
      )
    ],
  ).show();
}
}
