import 'package:flutter/material.dart';

class RegisterSuccess extends StatefulWidget {
  @override
  _RegisterSuccessState createState() => _RegisterSuccessState();
}

class _RegisterSuccessState extends State<RegisterSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 150,
              color: Theme.of(context).accentColor,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            Center(
              child: Text(
                'Sukses',
                // style: TextStyle(color: Colors.green),
              ),
            ),
            Center(
                child: Text(
              'Akun berhasil dibuat',
              // style: TextStyle(color: Colors.green),
            )),
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 14),
              color: Theme.of(context).primaryColor,
              child: Text(
                'MASUK',
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(Navigator.defaultRouteName));
              },
            ),
          ],
        ),
      ),
    );
  }
}
