import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:photo_view/photo_view.dart';
import '../../../Network/api_constants.dart';
import '../../../Utils/color_utils.dart';
import '../../../exports.dart';
import '../../History/constant.dart';
import '../../Leadership/Leadership.dart';
import 'package:http/http.dart' as http;
import 'all_leave.dart';
import 'approved_leave.dart';
import 'image_viewer.dart';
import 'leave_approvall.dart';

class leaveApproval extends StatefulWidget {
  String? images;
  String? name;
  String? timeString;
  String? selectedDate;
  var loginname;
  var roleUnderLoginTeacher;
  var usrId;
  bool? drawer;
  leaveApproval(
      {this.images,this.usrId,this.drawer,this.roleUnderLoginTeacher, this.selectedDate, this.timeString,this.loginname, this.name, Key? key, })
      : super(key: key);

  @override
  State<leaveApproval> createState() => _leaveApprovalState();
}

class _leaveApprovalState extends State<leaveApproval> {
  int Count = 0;
  int _selectedIndex = 0;
  bool isSpinner = false;
  bool widgetLoader = false;
  Map<String, dynamic>? notificationResult;
  Timer? timer;
  var studentDataasforleave = [];
  var leaveapprovelist = [];
  var academicYEAR;
  var leaveId;
  var _reasontextController = new TextEditingController();
  var approve;
  var approved;
  var reject;
  var rejected;
  bool leaveapproval = false;
  List<Map> leaveapproallist = [];
  List<Map> _pages = [];
  bool _isListening = false;
  // bool _drawer = false;
  List newResult = [];
  var _searchController = TextEditingController();
  //for adding data in leaveapprovallist
  var nAME;
  var fromDATE;
  var toDATE;
  var totalDAYS;
  var cLASSES;
  var bATCHES;
  var leaveREASON;
  var appliedDATE;
  var adMISSIONnO;
  var lEAVEiD;
  var aCADEMICyEAR;
  var sTUDiMAGE;
  var nodata = ' ';
  String? rollidpref;
  bool keyboardEnabled = false;
  var rollidprefname;
  DateFormat _examformatter = DateFormat('dd/MM/yyyy');
  getPreferenceData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    count = preferences.get("count");
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
    for(var i = 0; i<rollidprefname.length; i++){
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
        print('....notificationResult$notificationResult');
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

  Map<String, dynamic>? leaveData;

  Future getleavedata() async {
    print('callingdetdata');
    setState(() {
      leaveapprovelist = [];
      isSpinner = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var schoolID = preferences.getString('school_id');
    var academicyear = preferences.getString('academic_year');
    print("____---shared$schoolID");
    print("____---user$userID");
    print("____---academic$academicyear");
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "school_id": schoolID,
      "academic_year": academicyear,
      "user_id": userID,
    };
    print('-b_b-o_o-d_d-y_y$body');
    var request = await http.post(Uri.parse(ApiConstants.LeaveApproval),
        headers: headers, body: json.encode(body));
    var response = json.decode(request.body);
    // print('------------api response---------------$response');
    leaveData = response;
    print('------------api response---------------$leaveData');
    studentDataasforleave = leaveData!['data']['pendings'];
    _pages = [
      {
        "page": LeaveApprovall(studentDataasforleave: leaveData!['data']['pendings'])
      },
      {
        "page": ApprovedLeave(studentDataasforleave: leaveData!['data']['apprved_or_rejected'])
      },
      {
        "page": All_Leave(studentDataasforleave: leaveData!['data']['allLeaves'])
      },
    ];
    if (studentDataasforleave.isEmpty ) {
    setState(() {
      widgetLoader = true;
        isSpinner = false;
      });
      nodata = 'No Data';
    }

    // academicYEAR = studentDataasforleave[0]['academic_year'];
    // leaveId = studentDataasforleave[i]['academic_year'];
    print(
        '------------studentDataasforleave---------------${studentDataasforleave}');
    setState(() {
      newResult = studentDataasforleave;
    });
    // newResult = leaveapprovelist;
    print('studentDataasforleave-----------$studentDataasforleave');
    if (newResult.isEmpty) {
      nodata = 'No Data';
    }
    setState(() {
      widgetLoader = true;
      isSpinner = false;
    });
  }

  Future submitleavedata(
      {String? acadYEAR,
      String? leaveIds,
      String? apprve,
      String? approved}) async {
    setState(() {
      isSpinner = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var schoolID = preferences.getString('school_id');
    var academicyear = preferences.getString('academic_year');
    print("____---shared$schoolID");
    print("____---user$userID");
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "user_id": userID,
      "school_id": schoolID,
      "academic_year": acadYEAR,
      "leaveID": leaveIds,
      "approvedBy": userID,
      "actionItem": {
        "actionItem": apprve,
        // "actionItem": "Reject / Approve",
        // "actionstatus": "Rejected / Approved",
        "actionstatus": approved,
        "commentItem": _reasontextController.text
      },
      "commentItem": _reasontextController.text
    };
    print('---b-o-d-y-lleeaavve--${body}');
    var request = await http.post(Uri.parse(ApiConstants.LeaveApprovalRequest),
        headers: headers, body: json.encode(body));
    var response = json.decode(request.body);
    if (response['status']['code'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response['data']['message']}'),
      ));
    }
    log('----------rsssssbdyy${response}');
    setState(() {
      isSpinner = false;
    });
  }

  // _navigator() {
  //   for(var i = 0; i<rollidprefname.length; i++){
  //     // print('rollidprefname[i]${rollidprefname[0]}');
  //     // print('rollidprefname[i]${rollidprefname[1]}');
  //     print('rollidprefname[i]${rollidprefname[i]}');
  //     if(rollidprefname[i] == 'Principal' || rollidprefname[i] == 'Vice Principal' || rollidprefname[i] == 'HOS' || rollidprefname[i] == 'HOD'){
  //       setState(() {
  //         _drawer = true;
  //       });
  //       // ZoomDrawer.of(context)!.toggle();
  //       break;
  //     }else if( rollidprefname[i] == 'Teacher'){
  //       setState(() {
  //         _drawer = false;
  //       });
  //       // Navigator.of(context).pop();
  //       break;
  //     }};
  // }

  void initState() {
    _initialize();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    super.initState();
  }

  Future<void> _initialize() async {
    // await getleavedata();
    await getNotification();
    // _navigator();
  }

  Future<dynamic> _checkKeyboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? data = prefs.getBool("keyboard");
    if (data != null) {
      setState(() {
        keyboardEnabled = true;
      });
    } else {
      setState(() {
        keyboardEnabled = false;
      });
    }
  }

  Future<void> _pageInit() async {
    await _checkKeyboard();
    if (!keyboardEnabled) {
      await getleavedata();
    }
  }

  var count;

  @override
  void didUpdateWidget(covariant leaveApproval oldWidget) {
    _pageInit();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _pageInit();
    super.didChangeDependencies();
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
      backgroundColor: ColorUtils.BACKGROUND,
      body: LoadingOverlay(
        opacity: 0,
        isLoading: isSpinner,
        progressIndicator: CircularProgressIndicator(),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/images/header.png",
                      fit: BoxFit.fill,
                    )),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.drawer! ? ZoomDrawer.of(context)!.toggle() : Navigator.of(context).pop();
  },
                        child:
                    Container(
                          margin: const EdgeInsets.all(6),
                          child:
                          widget.drawer! ? Image.asset("assets/images/newmenu.png") : Image.asset("assets/images/goback.png")   )
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
                            height: 40.h,
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
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                    GestureDetector(
                      onTap: () => NavigationUtils.goNext(
                          context,
                          NotificationPage(
                            name: widget.name,
                            image: widget.images,
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
                            image: NetworkImage(widget.images == ""
                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                : ApiConstants.IMAGE_BASE_URL +
                                    "${widget.images}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() => _selectedIndex = 0);
                                  },
                                child: Container(
                                    height: 40.h,
                                    width: 90.w,
                                    decoration: BoxDecoration(
                                        color: _selectedIndex == 0 ? Colors.red[500] : Colors.grey[500],
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                          'Approval',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                              color: ColorUtils.WHITE),
                                        ))),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _selectedIndex = 1);

                                },
                                child: Container(
                                  height: 40.h,
                                  width: 150.w,
                                  decoration: BoxDecoration(
                                      color: _selectedIndex == 1 ? Colors.red[500] : Colors.grey[500],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Approved/Rejected",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: ColorUtils.WHITE),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _selectedIndex = 2);

                                },
                                child: Container(
                                  height: 40.h,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                      color: _selectedIndex == 2 ? Colors.red[500] : Colors.grey[500],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "All",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: ColorUtils.WHITE),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        isSpinner
                            ? Container()
                            : widgetLoader
                            ? _pages[_selectedIndex]['page'] as Widget
                            : Container(),

                        SizedBox(
                          height: 150.h,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }


}
