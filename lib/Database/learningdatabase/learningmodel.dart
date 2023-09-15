final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, teachername, observername,teacherid,schoolid,observerid,subjectname,subjectid,classid,batchid,classname,
    academicyear,area,strength,suggested,rol_ids,upper_hierrarchy,session_id,curriculum_id,isJoin,tempname
  ];

  static final String id = '_id';
  static final String teachername = 'teachername';
  static final String observername = 'observername';
  static final String teacherid = 'teacherid';
  static final String schoolid = 'schoolid';
  static final String observerid = 'observerid';
  static final String subjectname = 'subjectname';
  static final String subjectid = 'subjectid';
  static final String classid = 'classid';
  static final String batchid = 'batchid';
  static final String classname = 'classname';
  static  var area = 'area';
  static final String academicyear = 'academicyear';
  static  var strength = 'strength';
  static final String suggested = 'suggested';
  static final String rol_ids = 'rol_ids';
  static final String upper_hierrarchy = 'upper_hierrarchy';
  static final String session_id = 'session_id';
  static final String curriculum_id = 'curriculum_id';
  static final String isJoin = "isJoin";
  static final String tempname = 'tempname';
}

class Note {
  final int? id;
  final String? teachername;
  final String? teacherid;
  final String? observername;
  final String? schoolid;
  final String? observerid;
  final String? subjectname;
  final String? subjectid;
  final String? classid;
  final String? batchid;
  final String? classname;
  var area;
  final String? academicyear;
  var strength;
  final String? suggested;
  final String? rol_ids;
  final String? upper_hierrarchy;
  final String? session_id;
  final String? curriculum_id;
  final String? tempname;
  final String? isJoin;


  Note({
    this.id,
    required this.teachername,
    required this.observername,
    this.teacherid,
    this.schoolid,
    this.observerid,
    this.subjectname,
    this.subjectid,
    this.classid,
    this.batchid,
    this.classname,
    this.area,
    this.academicyear,
    this.strength,
    this.suggested,
    this.rol_ids,
    this.upper_hierrarchy,
    this.session_id,
    this.curriculum_id,
    this.tempname,
    this.isJoin
  });

  Note copy({
    int? id,
    String? teachername,
    String? observername,
    String? teacherid,
    String? schoolid,
    String? observerid,
    String? subjectname,
    String? subjectid,
    String? classid,
    String? batchid,
    String? classname,
    var area,
    String? academicyear,
    var strength,
    String? suggested,
    String? rol_ids,
    String? upper_hierrarchy,
    String? session_id,
    String? curriculum_id,
    String? isJoin,
    String? tempname
  }) =>
      Note(
          id: id ?? this.id,
          teachername: teachername ?? this.teachername,
          observername: observername ?? this.observername,
          teacherid: teacherid ?? this.teacherid,
          observerid: observerid ?? this.observerid,
          schoolid: schoolid ?? this.schoolid,
          subjectname: subjectname ?? this.subjectname,
          classid: classid ?? this.classid,
          batchid: batchid ?? this.batchid,
          area:  area ?? this.area,
          academicyear:  academicyear ?? this.academicyear,
          strength: strength ?? this.strength,
          suggested: strength ?? this.suggested,
          rol_ids:  rol_ids ?? this.rol_ids,
          upper_hierrarchy: upper_hierrarchy ?? this.upper_hierrarchy,
          session_id: session_id ?? this.session_id,
          curriculum_id: curriculum_id ?? this.curriculum_id,
          isJoin: isJoin ?? this.isJoin,
          tempname: tempname ?? this.tempname
      );

  static Note fromJson(Map<String, Object?> json) => Note(
      id: json[NoteFields.id] as int?,
      teachername: json[NoteFields.teachername] as String,
      observername: json[NoteFields.observername] as String,
      teacherid: json[NoteFields.teacherid] as String,
      observerid: json[NoteFields.observerid] as String,
      schoolid: json[NoteFields.schoolid] as String,
      subjectname: json[NoteFields.subjectname] as String,
      subjectid: json[NoteFields.subjectid] as String,
      classid: json[NoteFields.classid] as String,
      batchid: json[NoteFields.batchid] as String,
      classname: json[NoteFields.classname] as String,
      area: json[NoteFields.area] ,
      academicyear: json[NoteFields.academicyear] as String,
      strength: json[NoteFields.strength],
      suggested: json[NoteFields.suggested] as String,
      rol_ids: json[NoteFields.rol_ids] as String,
      upper_hierrarchy: json[NoteFields.upper_hierrarchy] as String,
      session_id: json[NoteFields.session_id] as String,
      curriculum_id: json[NoteFields.curriculum_id] as String,
      isJoin: json[NoteFields.isJoin] as String,
      tempname: json[NoteFields.tempname] as String
  );

  Map<String, Object?> toJson() => {
    NoteFields.id: id,
    NoteFields.teachername: teachername,
    NoteFields.observername: observername,
    NoteFields.teacherid: teacherid,
    NoteFields.observerid: observerid,
    NoteFields.subjectname: subjectname,
    NoteFields.subjectid: subjectid,
    NoteFields.schoolid: schoolid,
    NoteFields.classname: classname,
    NoteFields.classid: classid,
    NoteFields.batchid: batchid,
    NoteFields.area: area,
    NoteFields.academicyear: academicyear,
    NoteFields.strength: strength,
    NoteFields.suggested: suggested,
    NoteFields.rol_ids: rol_ids,
    NoteFields.upper_hierrarchy: upper_hierrarchy,
    NoteFields.session_id: session_id,
    NoteFields.curriculum_id:  curriculum_id,
    NoteFields.isJoin:  isJoin,
    NoteFields.tempname: tempname
  };
}
