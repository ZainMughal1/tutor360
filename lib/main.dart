import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'AboutUs.dart';
import 'Admin/AddNewAdmin.dart';
import 'Admin/AdminDashboard.dart';
import 'Admin/AdminLogin.dart';
import 'Admin/BlockStudents.dart';
import 'Admin/BlockTutors.dart';
import 'Admin/ChangePassword.dart';
import 'Admin/ShowAppFeedback.dart';
import 'Admin/StudentDetail.dart';
import 'Admin/StudentReportsList.dart';
import 'Admin/StudentsLists.dart';
import 'Admin/TutorCancel.dart';
import 'Admin/TutorDetail.dart';
import 'Admin/TutorReportsList.dart';
import 'Admin/TutorRequestList.dart';
import 'Admin/TutorsLists.dart';
import 'AppFeedback/AppFeedback.dart';
import 'Chat/Chat.dart';
import 'Cloud Messaging/NotificationServices.dart';
import 'Map/MapScreen.dart';
import 'OTPMODULE/OTP.dart';
import 'Splashes/AskRoll.dart';
import 'Splashes/WellcomeParent.dart';
import 'Splashes/WellcomeSearch.dart';
import 'Splashes/WellcomeSelect.dart';
import 'Splashes/WellcomeStudy.dart';
import 'Student/FeedbackRatingToTutor.dart';
import 'Student/Payment.dart';
import 'Student/RecommendedTutor.dart';
import 'Student/StudentBlock.dart';
import 'Student/StudentChatRoom.dart';
import 'Student/StudentEditProfile.dart';
import 'Student/StudentProfile.dart';
import 'Student/TutorDetailForStudent.dart';
import 'Student/TutorNearest.dart';
import 'Student/TutorSearch.dart';
import 'Tutor/PayedStudentsRoom.dart';
import 'Tutor/StudentDetailForTutor.dart';
import 'Tutor/TutorBlock.dart';
import 'Tutor/TutorChatRoom.dart';
import 'Tutor/TutorEditProfile.dart';
import 'Tutor/TutorHome.dart';
import 'Tutor/TutorProfile.dart';
import 'Tutor/TutorRating.dart';
import 'TutorReports/TutorReportForm.dart';

String role = "null";
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
User? user;
getRole() async {
  user = _auth.currentUser;
  if (user != null) {
    final adminsnapshot =
    await _firestore.collection('AdminData').doc(user!.uid).get();
    if (adminsnapshot.exists) {
      role = 'admin';
    }
    final tutorsnapshot =
    await _firestore.collection('TutorData').doc(user!.uid).get();
    if (tutorsnapshot.exists) {
      Map<String, dynamic> data = tutorsnapshot.data() as Map<String, dynamic>;
      bool status = await data['status'];
      bool report = await data['Report'];
      String localRole = GetStorage().read('role');
      if (localRole == 'tutor') {
        if (status == false) {
          role = 'tutorfalse';
        } else if (report == true) {
          role = 'reportTrue';
        } else {
          role = 'tutor';
        }
      }
    }
    final studentSnapshot =
    await _firestore.collection('StudentData').doc(user!.uid).get();
    if (studentSnapshot.exists) {
      Map<String, dynamic> data =
      studentSnapshot.data() as Map<String, dynamic>;
      bool status = data['status'];
      bool report = data['Report'];
      String localRole = GetStorage().read('role');
      if (localRole == 'student') {
        if (status == false) {
          role = 'studentfalse';
        } else if (report == true) {
          role = 'studentreporttrue';
        } else {
          role = 'student';
        }
      }
    }
  }
  print("********RRrOOOLLEE $role");
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  NotificationServices().initBackgroundMessaging();
}

_forgroundListner(){
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print("new Message listen onMessageOpendApp.");
  });
}
void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _forgroundListner();
  await Firebase.initializeApp();
  await GetStorage.init();
  Get.put(Initializer(), permanent: true);
  await getRole();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tutor 360",
      routes: {
        '/Initializer': (context) => const Initializer(),
        '/AskRoll': (context) => const AskRoll(),
        '/AdminLogin': (context) => const AdminLogin(),
        '/StudentProfile': (context) => const StudentProfile(),
        '/OTPVerification': (context) => const OTPVerification(),
        '/TutorProfile': (context) => const TutorProfile(),
        '/AdminDashboard': (context) => const AdminDashboard(),
        '/TutorsList': (context) => const TutorsList(),
        '/StudentList': (context) => const StudentList(),
        '/AddNewAdmin': (context) => const AddNewAdmin(),
        '/TutorDetail': (context) => const TutorDetail(),
        '/TutorDetailForStudent': (context) => const TutorDetailForStudent(),
        '/TutorRequestList': (context) => const TutorRequestList(),
        '/TutorSearch': (context) => const TutorSearch(),
        '/TutorHome': (context) => const TutorHome(),
        '/StudentDetail': (context) => const StudentDetail(),
        '/BlockStudents': (context) => const BlockStudents(),
        '/ChangePassword': (context) => const ChangePassword(),
        '/Chat': (context) => Chat(),
        '/StudentChatRoom': (context) => StudentChatRoom(),
        '/TutorBlock': (context) => TutorBlock(),
        '/BlockTutors': (context) => BlockTutors(),
        '/TutorChatRoom': (context) => TutorChatRoom(),
        '/StudentDetailForTutor': (context) => StudentDetailForTutor(),
        '/TutorReportForm': (context) => TutorReportForm(),
        '/StudentReportsList': (context) => StudentReportsList(),
        '/TutorReportsList': (context) => TutorReportsList(),
        '/FeedbackRatingToTutor': (context) => FeedbackRatingToTutor(),
        '/StudentEditProfile': (context) => StudentEditProfile(),
        '/TutorEditProfile': (context) => TutorEditProfile(),
        '/StudentBlock': (context) => StudentBlock(),
        '/TutorRating': (context) => TutorRating(),
        '/Payment': (context) => Payment(),
        '/TutorNearest': (context) => TutorNearest(),
        '/PayedStudentsRoom': (context) => PayedStudentsRoom(),
        '/MapScreen': (context) => MapScreen(),
        '/RecommendedTutor': (context) => RecommendedTutor(),
        '/WellcomeParent': (context) => WellcomeParent(),
        '/WellcomeSearch': (context) => WellcomeSearch(),
        '/WellcomeSelect': (context) => WellcomeSelect(),
        '/WellcomeStudy': (context) => WellcomeStudy(),
        '/AboutUs': (context) => AboutUs(),
        '/TutorCancel': (context) => TutorCancel(),
        '/AppFeedback': (context) => AppFeedback(),
        '/ShowAppFeedback': (context) => ShowAppFeedback(),

      },
      initialRoute: '/Initializer',
    );
  }
}

class Initializer extends StatefulWidget {
  const Initializer({Key? key}) : super(key: key);

  @override
  State<Initializer> createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("*********Init function callllll**************");
  }

  @override
  Widget build(BuildContext context) {
    print("****************return widget************");
    return role == null
        ? const WellcomeParent()
        : role == 'admin'
        ? const AdminDashboard()
        : role == 'student'
        ? const TutorSearch()
        : role == 'tutor'
        ? const TutorHome()
        : role == 'tutorfalse'
        ? TutorBlock()
        : role == 'reportTrue'
        ? const TutorBlock()
        : role == 'studentfalse'
        ? const StudentBlock()
        : role == 'studentreporttrue'
        ? const StudentBlock()
        : const WellcomeParent();
  }
}
