import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  SharedPreferences sharedPreferences;
  File image;
  double devWidth = 0;
  int selectedRadio;
  bool laporan = false;
  final String url = 'earthquake-report-api/request/getReport.php';
  final String urlSet = 'earthquake-report-api/request/setReport.php';
  final String urlDel = 'earthquake-report-api/request/deleteReport.php';
  String tingkatKerusakan = '';
  String status = '';

  @override
  initState() {
    super.initState();
    selectedRadio = 1;
    getReport();
  }

  setSelectedRadio(int val) {
    print(val);
    setState(() {
      selectedRadio = val;
    });
  }

  getReport() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();
    // print(id.toString());
    var response = await http.post(host + url, body: {
      'id': id,
    });
    var data = json.decode(response.body);
    if (data['status'] == 1) {
      setState(() {
        this.laporan = true;
        tingkatKerusakan = data['report']['tingkat_kerusakan'];
        status = data['report']['status'];
      });
    } else {
      setState(() {
        this.laporan = false;
      });
    }
  }

  deleteReport() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();
    // print(id.toString());
    var response = await http.post(host + urlDel, body: {
      'id': id,
    });
    var data = json.decode(response.body);
    _showToast(data['message']);
    getReport();
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
      // print(image.path);
    });
  }

  uploadImage() async {
    if (image == null) {
      _showToast('Gambar Kerusakan tidak boleh kosong!');
      return;
    }
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();
    String nama = sharedPreferences.getString('nik');
    print(nama);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    img.Image _img = img.decodeImage(image.readAsBytesSync());
    img.Image smallerImage = img.copyResize(_img, width: 500);

    var compressImg = new File("$path/$nama.jpg")
      ..writeAsBytesSync(img.encodeJpg(smallerImage, quality: 85));

    setState(() {
      image = compressImg;
    });

    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse(host + urlSet);

    var request = new http.MultipartRequest("POST", uri);
    String fileName = image.path.split('/').last;
    var multipartFile =
        new http.MultipartFile('image', stream, length, filename: fileName);

    request.fields['id_victim'] = id;
    request.fields['tingkat_kerusakan'] = selectedRadio.toString();
    // request.fields['gambar'] = '$nama.jpg';
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("image Uploaded");
      response.stream.transform(utf8.decoder).listen((value) {
        var data = json.decode(value);
        _showToast(data['mesage']);
        getReport();
      });
    } else {
      print("image Unuploaded");
    }
  }

  _showToast(String msg) {
    Fluttertoast.showToast(
      msg: '$msg',
      toastLength: Toast.LENGTH_LONG,
    );
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
                    radio('Ringan', 1),
                    radio('Sedang', 2),
                    radio('Berat', 3),
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
                      onPressed: () {
                        uploadImage();
                      },
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  height: 50,
                ),
                (!laporan)
                    ? Center(
                        child: Text(
                          'Belum ada Laporan',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      )
                    : Column(
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
                                top: BorderSide(
                                    width: 1.0, color: Color(0xff707070)),
                                left: BorderSide(
                                    width: 1.0, color: Color(0xff707070)),
                                right: BorderSide(
                                    width: 1.0, color: Color(0xff707070)),
                                bottom: BorderSide(
                                    width: 1.0, color: Color(0xff707070)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '$tingkatKerusakan',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      '$status',
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
                                    onPressed: () {
                                      deleteReport();
                                      getReport();
                                    },
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
