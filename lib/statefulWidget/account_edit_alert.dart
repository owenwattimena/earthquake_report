import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountEditAlert extends StatefulWidget {
  final String title;
  final TextInputType textInputType;
  final String value;
  final void Function(String field) callback;

  const AccountEditAlert(
      {Key key, this.title, this.textInputType, this.callback, this.value})
      : super(key: key);

  @override
  _AccountEditAlertState createState() => _AccountEditAlertState();
}

class _AccountEditAlertState extends State<AccountEditAlert> {
  final _formKey = GlobalKey<FormState>();
  // static String value = widget.value;
  SharedPreferences sharedPreferences;
  int statusValidator = 0;

  @override
  Widget build(BuildContext context) {
    TextEditingController myController =
        TextEditingController(text: widget.value);

    return AlertDialog(
      title: Center(
        child: Text(widget.title),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: myController,
                    keyboardType: widget.textInputType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukan ${widget.title}',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Mohon masukan ${widget.title}';
                      }
                      return null;
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Ubah',
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              widget.callback(myController.text);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // getUser() async {
  //   sharedPreferences = await SharedPreferences.getInstance();

  //   // nama = snama.getString('email') ?? null;
  //   // alamat = salamat.getString('email') ?? null;
  //   // no_hp = sanoH_noHp.getString('email') ?? null;
  //   String email = sharedPreferences.getString('email') ?? null;
  //   String nik = sharedPreferences.getString('nik') ?? null;
  //   String nama = sharedPreferences.getString('nama') ?? null;
  //   String alamat = sharedPreferences.getString('alamat') ?? null;
  //   String noHp = sharedPreferences.getString('noHp') ?? null;

  //   setState(() {
  //     _email = email;
  //     _nik = nik;
  //     _nama = nama;
  //     _alamat = alamat;
  //     _noHp = noHp;
  //   });
  // }
}
