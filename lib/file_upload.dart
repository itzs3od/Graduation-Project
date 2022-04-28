import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cti_app/api/firebase_api.dart';
import 'consts.dart';
import 'widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

final _auth = FirebaseAuth.instance;
final loggedInUser = _auth.currentUser!.uid;
final _firestore = FirebaseFirestore.instance;
var urlDownload;
var newUrlDownload;

class FileUpload extends StatefulWidget {

  final taskID;

  const FileUpload({Key? key, this.taskID}) : super(key: key);

  @override
  _FileUploadState createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  UploadTask? task;
  File? file;

  Future getDocs() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Tasks")
        .where('taskID', isEqualTo: widget.taskID.toString())
        .get();
    var documentsTasks = querySnapshot.docs.first;
    setState(() {
      newUrlDownload = documentsTasks['taskAttachment'].toString();
      // newUrlDownload = "https://google.com";
    });
  }

  @override
  void initState() {
    super.initState();
    //print(widget.taskID);
    getDocs();
  }

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;
    final fileName = file != null ? basename(file!.path) : 'لم يتم تحديد اي ملف';

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text("المرفقات"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            //padding: const EdgeInsets.symmetric(horizontal: 32,),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Image.asset('assets/images/cti.png'),
                  ),
                  TextButton(onPressed: newUrlDownload.toString().isNotEmpty ?_launchURL : null, child: Text("مشاهدة المرفق",style: kTitleTextStyleSMregular,),),
                  const SizedBox(height: 22,),
                  SizedBox(
                    width: widthOfScreen / 1.7,
                    child: ButtonWidget(
                      text: 'حدد الملف',
                      icon: Icons.attach_file,
                      onClicked: selectFile,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fileName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: widthOfScreen / 1.7,
                    child: ButtonWidget(
                      text: 'تحميل',
                      icon: Icons.cloud_upload_outlined,
                      onClicked: uploadFile,
                    ),
                  ),
                  const SizedBox(height: 20),
                  task != null ? buildUploadStatus(task!) : Container(),

                  // Button to go to attachments
                  // Container(
                  //   width: widthOfScreen / 1.7,
                  //   height: heightOfScreen / 14,
                  //   decoration: BoxDecoration(
                  //     color: kColorButtonStyle,
                  //     borderRadius: BorderRadius.circular(15),
                  //   ),
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //     },
                  //     child: const Text(
                  //       "العودة لتفاصيل المهمة",
                  //       style: kTextButtonStyle,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    _updateData(widget.taskID);

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );
}

Future<dynamic> _updateData(taskID) {
  Future<void> result;
    result = _firestore.collection('Tasks').doc(taskID).update({
      'taskAttachment': urlDownload.toString(),
    });
    print("Done");
  return result;
}

void _launchURL() async {
  print(newUrlDownload);
  await canLaunch(newUrlDownload) ? await launch(newUrlDownload) : throw 'حدث خطأ ما.';
}
