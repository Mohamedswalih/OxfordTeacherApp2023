
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:com.bmark.oxfordteacher.oxford_teacher_app/exports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/learningdatabase/learningdbhelper.dart';
import '../../Database/learningdatabase/learningmodel.dart';
import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../DrawerPageHOSLogin/drawer_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../LoginPage/hoslisting.dart';
import '../Rubrics/rubrics.dart';

class learningwalkIndicators extends StatefulWidget {
  var roleUnderLoginTeacher;
  String? teacherName;
  final String value;
  final String? curriculam_Id;
  String? classId;
  String? teachername;
  String? subjectName;
  String? batchId;
  String? image;
  final String? schoolid;
  final String? Image;
  final String? subject_id;
  final String? subjectname;
  final String? teacherId;
  final String? HOS_id;
  final String? user_roleId;
  final String? username;
  final String? main_userId;
  final String? academicyear;
  var role_id;
  var loginname;
  var OB_ID;
  var teacherImage;
  final String? userid;
  final String? session_Id;
  final String? classname;
  List<dynamic>? teacherData;
  List<dynamic>? observationList;
  Map<String, dynamic>? learningData;
  learningwalkIndicators(
      {Key? key,
      this.session_Id,
      this.subjectname,
      this.username,
      this.role_id,
      this.user_roleId,
      this.loginname,
      this.main_userId,
      this.OB_ID,
      this.teacherImage,
      this.HOS_id,
      this.teacherData,
      required this.value,
      this.academicyear,
      this.schoolid,
      this.classname,
      this.subject_id,
      this.classId,
      this.curriculam_Id,
      this.image,
      this.teacherId,
      this.batchId,
      this.Image,
      this.userid,
      this.observationList,
      this.teacherName,
      this.teachername,
      this.subjectName,
      this.learningData,
      this.roleUnderLoginTeacher})
      : super(key: key);

  @override
  State<learningwalkIndicators> createState() => _learningwalkIndicatorsState();
}

class _learningwalkIndicatorsState extends State<learningwalkIndicators> {
  String? class_batchName;
  var count;
  String? schoolId;
  String? academicyear;
  String? userId;
  int val = -1;
  bool isSpinner = false;
  bool isChecked = false;
  bool isvalid = false;
  bool ischeck = false;
  Map<String, dynamic>? questionData;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? notificationResult;
  int Count = 0;
  Timer? timer;
  String? rollidpref;
  var rollidprefname;
  bool showMessage = false;


  getPreferenceData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      count = preferences.get("count");
      print('notification count---->${preferences.get("count")}');
    });
  }

  getNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    rollidpref = preferences.getString("role_ids");
    rollidprefname = preferences.getStringList("role_name");
    print('rollidpref---->$rollidpref');
    print('rollidpref---->$rollidprefname');
    print('rollidpref---->${rollidprefname}');
    print('rollidpref---->${rollidprefname.runtimeType}');
    print('rollidpref---->${rollidpref.runtimeType}');
    for (var i = 0; i < rollidprefname.length; i++) {
      // print('rollidprefname[i]${rollidprefname[0]}');
      // print('rollidprefname[i]${rollidprefname[1]}');
      print('rollidprefname[i]${rollidprefname[i]}');
    }
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',

        Uri.parse(
            '${ApiConstants.Notification}$userID${ApiConstants.NotificationEnd}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var responseJson = await response.stream.bytesToString();
      setState(() {
        notificationResult = json.decode(responseJson);
      });

      for (var index = 0;
          index <
              notificationResult!["data"]["details"]["recentNotifications"]
                  .length;
          index++) {
        if (notificationResult!["data"]["details"]["recentNotifications"][index]
                ["status"] ==
            "active") {
          Count += 1;
        }
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt("count", Count);

      print(Count);
    } else {
      print(response.reasonPhrase);
    }
  }

  void getlist() {
    print(widget.teacherData);
    questionData = widget.learningData;
    // questionData!.forEach((key, value) {
    //   print('questionnnnnnnnn$key - $value');
    //
    // });
    questionData!['list'].forEach((vall) {
      print(vall['values']);
      vall['values'] = null;
    });
    // for (int i = 0;
    // i < questionData!['list'].length;
    // i++)
    // questionData!['list'][i]['values'] = 0;
    // print('${questionData!.forEach((key, value) { })}');
    print('lengthof que------------>${questionData!.length}');
    print('-------------------------------------${widget.teacherName}');
  }

  getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    schoolId = preferences.getString('school_id');
    academicyear = preferences.getString("academic_year");
    userId = preferences.getString('userID');
    print('school data------------->${schoolId}');
    print('academic data------------->${academicyear}');
  }

  var areaforimprovTextController = new TextEditingController();
  var areaTextController = new TextEditingController();
  //var strengthTextController = new TextEditingController();
  var strenTextController = new TextEditingController();
  var _ebiTextController = new TextEditingController();
  List tempName = [];
  List tempNa = [];
  Future questionListData() async {
    tempName.clear();
    setState(() {
      ischeck = false;
    });
    for (int quest = 0; quest < this.questionData!['list'].length; quest++) {
      var remarkData;
      var db_key;
      var alias;
      if (questionData!['list'][quest]['values'] == 0) {
        remarkData = "NA";
        db_key = "NA";
        alias = "NA";
      } else if (questionData!['list'][quest]['values'] == 3) {
        remarkData = "Weak";
        db_key = "Weak";
        alias = "Weak";
      } else if (questionData!['list'][quest]['values'] == 5) {
        remarkData = "Acceptable";
        db_key = "Acceptable";
        alias = "Acceptable";
      } else if (questionData!['list'][quest]['values'] == 7) {
        remarkData = "Good";
        db_key = "Good";
        alias = "Good";
      } else if (questionData!['list'][quest]['values'] == 9) {
        remarkData = "Very Good";
        db_key = "Very_good";
        alias = "Very good";
      } else if (questionData!['list'][quest]['values'] == 10) {
        remarkData = "Outstanding";
        db_key = "Outstanding";
        alias = "Outstanding";
      } else {
        remarkData = null;
        db_key = null;
        alias = null;
      }
      tempName.add({
        "name": questionData!['list'][quest]['indicator'],
        "remark": remarkData,
        "point": questionData!['list'][quest]['values'],
        "db_key": db_key,
        "alias": alias,
      });
    }
  }
  Future checkingList() async{
    print('11111111111${tempName.length}');
    print('11111111111${tempName}');
    for (int i = 0; i < tempName.length; i++) {
      // print('tempName${tempName[i]['remark']}');
      print("for loop");
      if (tempName[i]['remark'] != null) {
        print('--tempnameee---${tempName[i]['remark']}');
        setState(() {
          ischeck = false;
        });
        break;
      }
      else{
        setState(() {
          ischeck = true;
        });
      }
    }
  }
  //Submit API
  SubmitRequest() async {
    // tempName.clear();
    await questionListData();
    await checkingList();

    print('ischekkkkkkk----------$ischeck');
    // print('ischekkkkkkk----------${questionData!['list'][quest]['values']}');
    if (!ischeck) {
      setState(() {
        isSpinner = true;
      });
      print('-----------qwert$tempName');
      var url = Uri.parse(ApiConstants.LearningWalkSUbmit);
      final bdy = {
        "school_id": schoolId,
        "teacher_id": widget.teacherId,
        "teacher_name": widget.teacherName,
        "observer_id": userId,
        "observer_name": widget.loginname,
        "class_id": widget.classId,
        "class_batch_name": widget.classname,
        "batch_id": widget.batchId,
        "topic": widget.value.isEmpty ? 'No data' : widget.value,
        "academic_year": academicyear,
        "batch_name": widget.classname!.split(" ")[1],
        "class_name": widget.classname!.split(" ")[0],
        "subject_name": widget.subjectName,
        "subject_id": widget.subject_id,
        "roll_ids": widget.role_id,
        "areas_for_improvement": [
          areaforimprovTextController.text.isEmpty
              ? "NO DATA"
              : areaforimprovTextController.text
        ],
        "strengths": [
          strenTextController.text.isEmpty
              ? "NO DATA"
              : strenTextController.text
        ],
        "remedial_measures": _ebiTextController.text.isEmpty
            ? 'NO DATA'
            : _ebiTextController.text,
        "upper_hierarchy": widget.HOS_id,
        "session_id": widget.session_Id,
        "curriculum_id": widget.curriculam_Id,
        "isJoin": isChecked,
        "remarks_data": [
          {"Indicators": tempName},
        ]
      };
      log("bbbbbooooddyyyyyyyy$bdy");
      var header = {
        "x-auth-token": "tq355lY3MJyd8Uj2ySzm",
        "Content-Type": "application/json",
      };
      var jsonresponse = await http.post(
        url,
        headers: header,
        body: jsonEncode(bdy),
      );
      log("boddyyy learningg submit${json.encode(bdy)}");
      print(jsonresponse);
      print(jsonresponse.statusCode);
      if (jsonresponse.statusCode == 200) {
        setState(() {
          isSpinner = false;
        });
        print('success');
        questionData!['list'].forEach((e) {
          print('------values--------${e['values']}');
        });
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) =>
                WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: AlertDialog(
                    title: Text('Learning Walk Submitted Successfully'),
                    // content: ListView.builder(itemBuilder: (ctx, index) {
                    //   return Text("${questionData!['list'][index]['values']}");
                    // },
                    //   itemCount: questionData!['list'].length,
                    // ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            for (var i = 0; i < rollidprefname.length; i++) {
                              // print('rollidprefname[i]${rollidprefname[0]}');
                              // print('rollidprefname[i]${rollidprefname[1]}');
                              print('rollidprefname[i]${rollidprefname[i]}');
                              if (rollidprefname[i] == 'Principal' ||
                                  rollidprefname[i] == 'Vice Principal'|| rollidprefname[i] == 'Academic Co-ordinator') {
                                NavigationUtils.goNextFinishAll(
                                    context,
                                    hoslisting(
                                      userID: userId,
                                      // loginedUserEmployeeNo: widget.loginEmployeeID,
                                      // designation: widget.designation,
                                      // schoolId: widget.schoolID,
                                      loginedUserName: widget.loginname,
                                      images: widget.image,
                                      loginname: widget.loginname,
                                      //academic_year: widget.academic_year,
                                      // roleUnderHos: employeeUnderHOS,
                                      //isAClassTeacher: newTeacherData,
                                    ));
                                break;
                              } else if (rollidprefname[i] == 'HOS' ||
                                  rollidprefname[i] == 'HOD' ||
                                  rollidprefname[i] == 'Supervisor') {
                                NavigationUtils.goNextFinishAll(
                                    context,
                                    DrawerPageForHos(
                                      userId: userId,
                                      roleUnderHos:
                                      widget.roleUnderLoginTeacher,
                                      // loginedUserEmployeeNo: widget.loginEmployeeID,
                                      // designation: widget.designation,
                                      // schoolId: widget.schoolID,
                                      loginedUserName: widget.loginname,
                                      images: widget.image,
                                      loginname: widget.loginname,
                                      //academic_year: widget.academic_year,
                                      // roleUnderHos: employeeUnderHOS,
                                      //isAClassTeacher: newTeacherData,
                                    ));
                                break;
                              }
                            }
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LeadershipListView(image: widget.image,roleUnderLoginTeacher: widget.roleUnderLoginTeacher,teachername: widget.teachername,usrId: userId,)));
                          },
                          child: Text('Go Back')),
                    ],
                  ),
                ));
      }
      else {
        setState(() {
          isSpinner = false;
        });
        print('submition failed');
      }
    } else {
      print("-----------object------------------");
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) =>
              AlertDialog(
                title: Text('Please fill atleast a indicators to continue'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              ));
    }
  }

  int charLengthsummary = 0;
  int charLengthwhatwentwell = 0;
  int charLengthevenbettrif = 0;

  _onChangedsummary(String value) {
    setState(() {
      charLengthsummary = value.length;
    });
  }

  _onChangedwhatwentwell(String value) {
    setState(() {
      charLengthwhatwentwell = value.length;
    });
  }

  _onChangedevenbetterif(String value) {
    setState(() {
      charLengthevenbettrif = value.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlist();
    getdata();
    getNotification();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    print('learning data--------------->${widget.learningData}');
    print('teacher name ------------->${widget.teacherName}');
    print('--------------rollid lw2------${widget.role_id}');
    print('--------------userid lw2------${widget.userid}');
    print('--------------userid lw2------${widget.roleUnderLoginTeacher}');
  }

  @override
  void didUpdateWidget(covariant learningwalkIndicators oldWidget) {
    // TODO: implement didUpdateWidget
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: true,
        backgroundColor: ColorUtils.BACKGROUND,
        body: Form(
          key: _formKey,
          child: LoadingOverlay(
            opacity: 0,
            isLoading: isSpinner,
            progressIndicator: CircularProgressIndicator(),
            child: ListView(physics: NeverScrollableScrollPhysics(), children: [
              Stack(children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/images/header.png",
                      fit: BoxFit.fill,
                    )),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 25,
                            color: Colors.white,
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
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
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.loginname.toString(),
                                style: TextStyle(
                                    fontFamily: "WorkSans",
                                    fontSize: 15.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                    GestureDetector(
                      onTap: () => NavigationUtils.goNext(
                          context,
                          NotificationPage(
                            name: widget.loginname,
                            image: widget.image,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: badges.Badge(
                            position: badges.BadgePosition.bottomEnd(end: -7, bottom: 12),
                            badgeContent: count == null
                                ? Text("")
                                : Text(
                                    count.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                            child: SvgPicture.asset("assets/images/bell.svg")),
                      ),
                    ),
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFD6E4FA)),
                        image: DecorationImage(
                            image: NetworkImage(widget.image == ""
                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                : ApiConstants.IMAGE_BASE_URL +
                                    "${widget.image}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    margin: EdgeInsets.only(
                      top: 100.h,
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ListView(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                            child: Text(
                              'Learning Walk',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 35.w, top: 20.h, right: 35.w, bottom: 20),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 20),
                              // height: 131.h,
                              width: 280.w,
                              decoration: BoxDecoration(
                                  color: Color(0xff18C7C7),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Color(0xFFD6E4FA)),
                                            color: Colors.white,
                                            // image: DecorationImage(
                                            //     image: NetworkImage(widget.teacherImage == ""
                                            //         ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                            //         : ApiConstants.IMAGE_BASE_URL +
                                            //         "${widget.teacherImage}"),
                                            //     fit: BoxFit.cover),
                                          ),
                                          child: Center(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  ApiConstants.IMAGE_BASE_URL +
                                                      "${widget.teacherImage}",
                                              placeholder: (context, url) =>
                                                  Text(
                                                '${widget.teacherName!.split(' ')[0].toString()[0]}${widget.teacherName!.split(' ')[1].toString()[0]}',
                                                style: TextStyle(
                                                    color: Color(0xFFB1BFFF),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              errorWidget:
                                                  (context, url, error) => Text(
                                                '${widget.teacherName!.split(' ')[0].toString()[0]}${widget.teacherName!.split(' ')[1].toString()[0]}',
                                                style: TextStyle(
                                                    color: Color(0xFFB1BFFF),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w),
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 170.w,
                                                  child: Text(
                                                    widget.teacherName
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Text(
                                                  widget.classname.toString(),
                                                  style: TextStyle(
                                                      color: Colors
                                                          .indigoAccent[100],
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Container(
                                                  width: 200.w,
                                                  child: Text(
                                                    widget.subjectName
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 65, top: 15),
                            child: Text(
                              'Criteria',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Column(
                            children: [
                              for (int i = 0;
                                  i < questionData!['list'].length;
                                  i++)
                                Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        35, 20, 30, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 1),
                                        ],
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                      child: FormField(
                                        // validator: (value) {
                                        //   //print(value);
                                        //   if (value != true) {
                                        //     isvalid = false;
                                        //     print('isvalid learning= false $isvalid');
                                        //     return null;
                                        //   } else {
                                        //     isvalid = true;
                                        //     print('isvalid learning= true $isvalid');
                                        //   }
                                        //   // return null;
                                        // },
                                        builder: (FormFieldState<bool> state) =>
                                            Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 30.w,
                                                top: 15.h,
                                                bottom: 20.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 20.h,
                                                    width: 20.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                      (i + 1).toString(),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                  ),
                                                  SizedBox(
                                                    width: 8.w,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          questionData!['list']
                                                                  [i]
                                                              ['indicator'])),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 12.w, right: 10.w),
                                                  child: Container(
                                                    // height: 170.h,
                                                    width: 135.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                      color: Color(0xffFEE68B)
                                                          .withOpacity(0.2),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15.h),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Theme(
                                                                data: ThemeData(
                                                                    unselectedWidgetColor:
                                                                        Colors.red[
                                                                            700]),
                                                                child: Radio(
                                                                  value: 0,
                                                                  groupValue:
                                                                      questionData!['list']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'values'],
                                                                  onChanged:
                                                                      (Object?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      print(
                                                                          'radio1--------------------->$value');
                                                                      questionData!['list'][i]
                                                                              [
                                                                              'values'] =
                                                                          value!;
                                                                    });
                                                                    state.setValue(
                                                                        true);
                                                                  },
                                                                  activeColor:
                                                                      Colors.red[
                                                                          700],
                                                                ),
                                                              ),
                                                              const Text("N/A"),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Theme(
                                                                data: ThemeData(
                                                                    unselectedWidgetColor:
                                                                        Colors.yellow[
                                                                            900]),
                                                                child: Radio(
                                                                  value: 3,
                                                                  groupValue:
                                                                      questionData!['list']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'values'],
                                                                  onChanged:
                                                                      (Object?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      print(
                                                                          'radio2--------------------->$value');
                                                                      questionData!['list'][i]
                                                                              [
                                                                              'values'] =
                                                                          value!;
                                                                      showMessage = true;
                                                                    });
                                                                    state.setValue(
                                                                        true);
                                                                  },
                                                                  activeColor:
                                                                      Colors.yellow[
                                                                          900],
                                                                ),
                                                              ),
                                                              const Text("Weak"),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Theme(
                                                                data: ThemeData(
                                                                    unselectedWidgetColor:
                                                                        Colors.yellow[
                                                                            700]),
                                                                child: Radio(
                                                                  value: 5,
                                                                  groupValue:
                                                                      questionData!['list']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'values'],
                                                                  onChanged:
                                                                      (Object?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      print(
                                                                          'radio3--------------------->$value');
                                                                      questionData!['list'][i]
                                                                              [
                                                                              'values'] =
                                                                          value!;
                                                                      showMessage = true;
                                                                    });
                                                                    state.setValue(
                                                                        true);
                                                                  },
                                                                  activeColor:
                                                                      Colors.yellow[
                                                                          700],
                                                                ),
                                                              ),
                                                              const Text(
                                                                  "Acceptable"),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // height: 170.h,
                                                  width: 135.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                    color: Color(0xff79CF62)
                                                        .withOpacity(0.2),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15.h),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                  unselectedWidgetColor:
                                                                      Colors
                                                                          .green),
                                                              child: Radio(
                                                                value: 7,
                                                                groupValue:
                                                                    questionData![
                                                                            'list'][i]
                                                                        [
                                                                        'values'],
                                                                onChanged:
                                                                    (Object?
                                                                        value) {
                                                                  setState(() {
                                                                    print(
                                                                        'radio4--------------------->$value');
                                                                    questionData!['list'][i]
                                                                            [
                                                                            'values'] =
                                                                        value!;
                                                                    showMessage = true;
                                                                  });
                                                                  state
                                                                      .setValue(
                                                                          true);
                                                                },
                                                                activeColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            ),
                                                            const Text("Good"),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                  unselectedWidgetColor:
                                                                      Colors.green[
                                                                          700]),
                                                              child: Radio(
                                                                value: 9,
                                                                groupValue:
                                                                    questionData![
                                                                            'list'][i]
                                                                        [
                                                                        'values'],
                                                                onChanged:
                                                                    (Object?
                                                                        value) {
                                                                  setState(() {
                                                                    print(
                                                                        'radio5--------------------->$value');
                                                                    questionData!['list'][i]
                                                                            [
                                                                            'values'] =
                                                                        value!;
                                                                    showMessage = true;
                                                                  });
                                                                  state
                                                                      .setValue(
                                                                          true);
                                                                },
                                                                activeColor:
                                                                    Colors.green[
                                                                        700],
                                                              ),
                                                            ),
                                                            const Text(
                                                                "Very good"),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                  unselectedWidgetColor:
                                                                      Colors.green[
                                                                          900]),
                                                              child: Radio(
                                                                value: 10,
                                                                groupValue:
                                                                    questionData![
                                                                            'list'][i]
                                                                        [
                                                                        'values'],
                                                                onChanged:
                                                                    (Object?
                                                                        value) {
                                                                  setState(() {
                                                                    print(
                                                                        'radio6--------------------->$value');
                                                                    questionData!['list'][i]
                                                                            [
                                                                            'values'] =
                                                                        value!;
                                                                    showMessage = true;
                                                                  });
                                                                  state
                                                                      .setValue(
                                                                          true);
                                                                },
                                                                activeColor:
                                                                    Colors.green[
                                                                        900],
                                                              ),
                                                            ),
                                                            const Text(
                                                                "Outstanding"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.w, top: 15.h),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.info_outline,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          rubrics(
                                                                            rubricslessonob:
                                                                                questionData!['list'][i]['rubrix'],
                                                                          ))),
                                                      child: Text(
                                                        'Rubrics',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          rubrics(
                                                                            rubricslessonob:
                                                                                questionData!['list'][i]['rubrix'],
                                                                          ))),
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 35.w, left: 35.w, top: 20.h),
                            child: TextFormField(
                              controller: strenTextController,
                              maxLength: 1000,
                              validator: (val) => val!.isEmpty
                                  ? '  *Fill the Field to Submit'
                                  : null,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black26),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  hintText: " Summary  ",
                                  counterText: "$charLengthsummary/1000",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(230, 236, 254, 8),
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(230, 236, 254, 8),
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  fillColor: Color.fromRGBO(230, 236, 254, 8),
                                  filled: true),
                              maxLines: 5,
                              onChanged: _onChangedsummary,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 35.w, left: 35.w, top: 20.h),
                            child: TextFormField(
                              controller: areaforimprovTextController,
                              maxLength: 1000,
                              validator: (val) => val!.isEmpty
                                  ? '  *Fill the Field to Submit'
                                  : null,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black26),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  hintText: " What went well   ",
                                  counterText: "$charLengthwhatwentwell/1000",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(230, 236, 254, 8),
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(230, 236, 254, 8),
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  fillColor: Color.fromRGBO(230, 236, 254, 8),
                                  filled: true),
                              maxLines: 5,
                              onChanged: _onChangedwhatwentwell,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 35.w, left: 35.w, top: 20.h),
                            child: TextFormField(
                              controller: _ebiTextController,
                              maxLength: 1000,
                              validator: (val) => val!.isEmpty
                                  ? '  *Fill the Field to Submit'
                                  : null,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black26),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  hintText: " Even better if   ",
                                  counterText: "$charLengthevenbettrif/1000",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(230, 236, 254, 8),
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(230, 236, 254, 8),
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  fillColor: Color.fromRGBO(230, 236, 254, 8),
                                  filled: true),
                              maxLines: 5,
                              onChanged: _onChangedevenbetterif,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
                                  },
                                ),
                                Text('Joined Observation',style: TextStyle(
                                  fontSize: 12,
                                ),)
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(35, 20, 35, 0),
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  print('function submit');
                                  // if (isvalid) {
                                    var connectivityResult =
                                        await (Connectivity()
                                            .checkConnectivity());
                                    if (connectivityResult ==
                                        ConnectivityResult.none) {
                                      {
                                        //getLessonData();
                                      await addNote();
                                        // _submitedSuccessfully(context);
                                        strenTextController.clear();
                                        tempNa.clear();
                                        areaforimprovTextController.clear();
                                        _ebiTextController.clear();
                                      }
                                    } else {
                                     SubmitRequest();
                                    }
                                } else {
                                  print('Validation not success');
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 55, right: 55),
                                child: Container(
                                  height: 60.h,
                                  // width: 180.w,
                                  decoration: BoxDecoration(
                                      color: Color(0xff42C614),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 180.h,
                          )
                        ]))
              ])
            ]),
          ),
        ));
  }

  //The given below variables are for adding datas to Sql Db**********************
  var QuestionDb = [];
  List fieldDB = [];
  //SQL Adding********************************************************************
  Future addnoteQuestionlist() async{
    setState(() {
      ischeck = false;
    });
    QuestionDb.clear();
    for (int quest = 0; quest < this.questionData!['list'].length; quest++) {
      // print("LEssndata");
      // print(quest);
      var remarkData;
      var db_key;
      var alias;
      if (questionData!['list'][quest]['values'] == 3) {
        remarkData = "Weak";
        db_key = "Weak";
        alias = "Weak";
      } else if (questionData!['list'][quest]['values'] == 5) {
        remarkData = "Acceptable";
        db_key = "Acceptable";
        alias = "Acceptable";
      } else if (questionData!['list'][quest]['values'] == 7) {
        remarkData = "Good";
        db_key = "Good";
        alias = "Good";
      } else if (questionData!['list'][quest]['values'] == 9) {
        remarkData = "Very Good";
        db_key = "Very_good";
        alias = "Very good";
      } else if (questionData!['list'][quest]['values'] == 10) {
        remarkData = "Outstanding";
        db_key = "Outstanding";
        alias = "Outstanding";
      } else if (questionData!['list'][quest]['values'] == 0) {
        remarkData = "NA";
        db_key = "NA";
        alias = "NA";
      } else {
        remarkData = null;
        db_key = null;
        alias = null;
      }
      QuestionDb.add({
        "name": questionData!['list'][quest]['indicator'],
        "remark": remarkData,
        "point": questionData!['list'][quest]['values'],
      });

      // print(QuestionSample!['list'][quest]['values']);
    }
  }
  Future addnoteischeck() async{
    for (int i = 0; i < QuestionDb.length; i++) {
      print("for loop");
      if (QuestionDb[i]['remark'] != null) {
        print('${QuestionDb[i]['remark']}');
        setState(() {
          ischeck = false;
        });
        break;
      }
      else{
        setState(() {
          ischeck = true;
        });
      }
    }
  }
  Future addNote() async {
   await addnoteQuestionlist();
   await addnoteischeck();
    print('ischekkkkkkk----------$ischeck');
    if (!ischeck) {
      setState(() {
        isSpinner = true;
      });
      print(QuestionDb);
      String jsonData = jsonEncode(QuestionDb);
      String roles = jsonEncode(widget.OB_ID);
      final note = Note(
          teachername: widget.teacherName,
          observername: widget.loginname,
          teacherid: widget.teacherId,
          observerid: userId,
          schoolid: schoolId,
          subjectid: widget.subject_id,
          subjectname: widget.subjectName,
          classname: widget.classname,
          classid: widget.classId,
          batchid: widget.batchId,
          academicyear: academicyear,
          area: areaforimprovTextController.text.isEmpty
              ? "NO DATA"
              : areaforimprovTextController.text,
          strength: strenTextController.text.isEmpty
              ? "NO DATA"
              : strenTextController.text,
          suggested: _ebiTextController.text.isEmpty
              ? "NO DATA"
              : _ebiTextController.text,
          rol_ids: widget.role_id.toString(),
          upper_hierrarchy: widget.HOS_id != null ? widget.HOS_id : "null",
          session_id: widget.session_Id,
          curriculum_id: widget.curriculam_Id,
          isJoin: isChecked.toString(),
          tempname: jsonData);
      await NotesDatabase.instance.create(note);
      if (note == null) {
        _submitedfailed(context);
      } else {
        setState(() {
          _submitedSuccessfully(context);
        });

        areaforimprovTextController.clear();
        strenTextController.clear();
        _ebiTextController.clear();
      }
    } else {
      print("-----------object------------------");
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Please fill atleast a indicators to continue'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              ));
    }
  }

//Alert Box for Submition success or fail***************************************
  _submitedSuccessfully(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              // return Future.value(false);
              return false;
            },
            child: AlertDialog(
              title: Text("Learning Walk Submitted Successfully"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      for (var i = 0; i < rollidprefname.length; i++) {
                        // print('rollidprefname[i]${rollidprefname[0]}');
                        // print('rollidprefname[i]${rollidprefname[1]}');
                        print('rollidprefname[i]${rollidprefname[i]}');
                        if (rollidprefname[i] == 'Principal' ||
                            rollidprefname[i] == 'Vice Principal') {
                          NavigationUtils.goNextFinishAll(
                              context,
                              hoslisting(
                                userID: userId,
                                // loginedUserEmployeeNo: widget.loginEmployeeID,
                                // designation: widget.designation,
                                // schoolId: widget.schoolID,
                                loginedUserName: widget.loginname,
                                images: widget.image,
                                loginname: widget.loginname,
                                //academic_year: widget.academic_year,
                                // roleUnderHos: employeeUnderHOS,
                                //isAClassTeacher: newTeacherData,
                              ));
                          break;
                        } else if (rollidprefname[i] == 'HOS' ||
                            rollidprefname[i] == 'HOD' ||
                            rollidprefname[i] == 'Supervisor') {
                          NavigationUtils.goNextFinishAll(
                              context,
                              DrawerPageForHos(
                                userId: userId,
                                roleUnderHos: widget.roleUnderLoginTeacher,
                                // loginedUserEmployeeNo: widget.loginEmployeeID,
                                // designation: widget.designation,
                                // schoolId: widget.schoolID,
                                loginedUserName: widget.loginname,
                                loginname: widget.loginname,
                                images: widget.image,
                                //academic_year: widget.academic_year,
                                // roleUnderHos: employeeUnderHOS,
                                //isAClassTeacher: newTeacherData,
                              ));
                          break;
                        }
                      }

                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LeadershipListView(image: widget.image,roleUnderLoginTeacher: widget.roleUnderLoginTeacher,teachername: widget.teachername,usrId: userId,)));
                    },
                    child: Text('Go Back')),
              ],
            ),
          );
        });
  }

  _submitedfailed(context) {
    return Alert(
      context: context,
      type: AlertType.error,
      title: "Failed to \nSubmit",
      style: AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          child: Text(
            "Retry",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            for (var i = 0; i < rollidprefname.length; i++) {
              // print('rollidprefname[i]${rollidprefname[0]}');
              // print('rollidprefname[i]${rollidprefname[1]}');
              print('rollidprefname[i]${rollidprefname[i]}');
              if (rollidprefname[i] == 'Principal' ||
                  rollidprefname[i] == 'Vice Principal'|| rollidprefname[i] == 'Academic Co-ordinator') {
                NavigationUtils.goNextFinishAll(
                    context,
                    hoslisting(
                      userID: userId,
                      // loginedUserEmployeeNo: widget.loginEmployeeID,
                      // designation: widget.designation,
                      // schoolId: widget.schoolID,
                      loginedUserName: widget.loginname,
                      images: widget.image,
                      loginname: widget.loginname,
                      //academic_year: widget.academic_year,
                      // roleUnderHos: employeeUnderHOS,
                      //isAClassTeacher: newTeacherData,
                    ));
                break;
              } else if (rollidprefname[i] == 'HOS' ||
                  rollidprefname[i] == 'HOD'||
                  rollidprefname[i] == 'Supervisor') {
                NavigationUtils.goNextFinishAll(
                    context,
                    DrawerPageForHos(
                      userId: userId,
                      // loginedUserEmployeeNo: widget.loginEmployeeID,
                      // designation: widget.designation,
                      // schoolId: widget.schoolID,
                      roleUnderHos: widget.roleUnderLoginTeacher,
                      loginedUserName: widget.loginname,
                      loginname: widget.loginname,
                      images: widget.image,
                      //academic_year: widget.academic_year,
                      // roleUnderHos: employeeUnderHOS,
                      //isAClassTeacher: newTeacherData,
                    ));
                break;
              }
            }

            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LeadershipListView(image: widget.image,roleUnderLoginTeacher: widget.roleUnderLoginTeacher,teachername: widget.teachername,usrId: userId,)));
          },
        )
      ],
    ).show();
  }

  bool validateandsave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
