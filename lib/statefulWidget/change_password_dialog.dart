import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordBaruController = new TextEditingController();
  TextEditingController _ulangPasswordBaruController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text("Ubah Password"),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukan Password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Mohon masukan Password';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  TextFormField(
                    controller: _passwordBaruController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukan Password Baru',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Mohon masukan Baru';
                      } else {
                        if (_passwordBaruController.text !=
                            _ulangPasswordBaruController.text) {
                          return "Password baru tidak sama dengan Ulang Password";
                        }
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  TextFormField(
                    controller: _ulangPasswordBaruController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukan Ulang Password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Mohon masukan Ulang Password';
                      } else {
                        if (_passwordBaruController.text !=
                            _ulangPasswordBaruController.text) {
                          return "Ulang Password tidak sama dengan Password baru";
                        }
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
                            print(_passwordBaruController.text);
                            if (_formKey.currentState.validate()) {}
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
}
