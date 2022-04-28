import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'consts.dart';

final _auth = FirebaseAuth.instance;
final loggedInUser = _auth.currentUser!.uid;
final _firestore = FirebaseFirestore.instance;

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final weeks = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
  int? value;
  String ?depID;
  String ?semesterID;
  String thisYear = DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    // Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getData () async {
    //   final departmentData = await FirebaseFirestore.instance
    //       .collection('Departments')
    //       .where('UID', isEqualTo: loggedInUser)
    //       .snapshots();
    //   return departmentData.single.;
    // }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/cti.png'),
              const Text(
                "الرجاء اختيار رقم الأسبوع",
                textAlign: TextAlign.center,
                style: kTitleTextStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: widthOfScreen / 4,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      iconSize: 36,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      isExpanded: true,
                      value: value,
                      items: weeks.map(buildMenuItem).toList(),
                      onChanged: (value) {
                        setState(() => this.value = value);
                       // print(value);
                        //print(getData);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              // Get Department Data
              SizedBox(
                width: 0,
                height: 0,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Departments')
                      .where('UID', isEqualTo: loggedInUser)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No Department.'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        depID = documents[index].id;
                       // final userID = documents[index]['UID'];
                       // final depName = documents[index]['depName'];

                        return Container();
                      },
                    );
                  },
                ),
              ),

              //Text(depID.toString()),

              Container(
                width: widthOfScreen / 2,
                height: heightOfScreen / 10,
                decoration: BoxDecoration(
                  color: kColorButtonStyle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const TextButton(
                  onPressed: null,
                  child: Text(
                    "حفظ",
                    style: kTextButtonStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

DropdownMenuItem<int> buildMenuItem(int item) => DropdownMenuItem(
      value: item,
      child: Text(
        item.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );


//_firestore
//           .collection('MedicineInfo')
//           .where('createdBy', isEqualTo: loggedInUser)
//           .snapshots(),