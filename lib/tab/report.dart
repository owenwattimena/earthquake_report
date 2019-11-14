import 'dart:io';

import 'package:flutter/material.dart';
// import 'dart:async';
import 'package:image_picker/image_picker.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  File image;
  double devWidth = 0;
  int selectedRadio;

  @override
  initState() {
    super.initState();
    selectedRadio = 0;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  pickImage(bool option) async {
    var _image;
    if (option) {
      _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } else {
      _image = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    setState(() {
      image = _image;
      print(image.path);
    });
  }

  Future<void> imagePickerDialog() async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pilih',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.panorama,
                        size: 50,
                      ),
                      onPressed: () {
                        pickImage(true);
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.camera_enhance,
                          size: 50,
                        ),
                        onPressed: () {
                          pickImage(false);
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    devWidth = (70 / 100) * MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Eartquake Report'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: devWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Color(0xff707070)),
                          left:
                              BorderSide(width: 1.0, color: Color(0xff707070)),
                          right:
                              BorderSide(width: 1.0, color: Color(0xff707070)),
                          bottom:
                              BorderSide(width: 1.0, color: Color(0xff707070)),
                        ),
                      ),
                      // child:

                      child: image == null
                          ? IconButton(
                              icon: Icon(
                                Icons.add_a_photo,
                                color: Theme.of(context).accentColor,
                                size: 100,
                              ),
                              onPressed: () => imagePickerDialog(),
                            )
                          : Stack(
                              children: <Widget>[
                                Center(
                                  child: Image.file(image),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(right: 10, top: 10),
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.add_a_photo,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 16,
                                          ),
                                          onPressed: () => imagePickerDialog(),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                ),
                Text('Tingkat Kerusakan',
                    style: Theme.of(context).textTheme.title),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    radio('Kecil', 1),
                    radio('Sedang', 2),
                    radio('Besar', 3),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.all(18),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'LAPOR',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  height: 50,
                ),
                Center(
                  child: Text(
                    'Belum ada Laporan',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Laporan',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Color(0xff707070)),
                          left:
                              BorderSide(width: 1.0, color: Color(0xff707070)),
                          right:
                              BorderSide(width: 1.0, color: Color(0xff707070)),
                          bottom:
                              BorderSide(width: 1.0, color: Color(0xff707070)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Rusak Berat',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Terkirim',
                                // style: Theme.of(context).textTheme.overline,
                                style: TextStyle(
                                  // color: Color(0xff65679F),
                                  color: Colors.green[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.red[300],
                                size: 32,
                              ),
                              onPressed: null,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget radio(String jenis, int value) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: selectedRadio,
          onChanged: (val) {
            setSelectedRadio(val);
          },
          activeColor: Color(0xff707070),
        ),
        GestureDetector(
          child: Text(
            '$jenis',
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {
            setSelectedRadio(value);
          },
        ),
      ],
    );
  }
}
