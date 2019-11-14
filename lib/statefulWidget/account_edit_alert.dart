import 'package:flutter/material.dart';

class AccountEditAlert extends StatefulWidget {
  final String title;
  final TextInputType textInputType;

  const AccountEditAlert({Key key, this.title, this.textInputType})
      : super(key: key);

  @override
  _AccountEditAlertState createState() => _AccountEditAlertState();
}

class _AccountEditAlertState extends State<AccountEditAlert> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  int statusValidator = 0;
  @override
  Widget build(BuildContext context) {
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
