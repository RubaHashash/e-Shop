import 'package:animations/animations.dart';
import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/Authentication/SignInForm.dart';
import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/Authentication/SignUpPage.dart';
import 'file:///C:/Users/rubah/AndroidStudioProjects/e_shop_app/lib/Authentication/background_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CustomPaint(
              painter: BackgroundPainter(
                  animation: _controller.view
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: ValueListenableBuilder<bool>(
                  valueListenable: showSignInPage,
                  builder: (context, value, child) {
                    return PageTransitionSwitcher(
                      reverse: !value,
                      duration: Duration(milliseconds: 1000),
                      transitionBuilder: (child, animation, secondaryAnimation){
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.vertical,
                          fillColor: Colors.transparent,
                          child: child,
                        );
                      },
                      child: value ? SignInForm(
                        key: ValueKey('Sign In'),
                      onRegisterClicked: (){
                        showSignInPage.value = false;
                        _controller.forward();
                      },
                    ) :
                      SignUpPage(
                        key: ValueKey('Sign In'),
                        onSignInClicked: (){
                        showSignInPage.value = true;
                        _controller.reverse();
                      },
                    )
                    );
                  }
              ),
            ),
          )
        ],
      ),
    );
  }

}
