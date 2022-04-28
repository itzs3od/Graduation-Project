import 'package:flutter/material.dart';
import 'login.dart';
import 'consts.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/cti.png'),
              const Text(
                "برنامج متابعة مهام\n مدققي الجودة الداخليين",
                textAlign: TextAlign.center,
                style: kTitleTextStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: widthOfScreen / 2,
                height: heightOfScreen / 10,
                decoration: BoxDecoration(
                  color: kColorButtonStyle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () => {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Login())),
                  },
                  child: const Text("تسجيل الدخول", style: kTextButtonStyle,),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                width: widthOfScreen / 2,
                height: heightOfScreen / 10,
                decoration: BoxDecoration(
                  color: kColorButtonStyle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const TextButton(
                  onPressed: null,
                  child: Text("التقارير", style: kTextButtonStyle,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

