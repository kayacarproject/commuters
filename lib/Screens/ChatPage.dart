import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../Constant/MySharedPreferences.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../Model/chatModel.dart';
import 'SignUpPage.dart';

String? uId;
String? uName;
String? lUid;
String? lName;
bool isExist = false;
String? messageId;

class ChatPage extends StatefulWidget {
  ChatPage(String userId, name, BuildContext context, String loginId, msgId,
      {Key? key})
      : super(key: key) {
    uId = userId;
    uName = name;
    lName = uName;
    lUid = loginId;
    messageId = msgId;
    final bool? isFromSender;
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _message = new TextEditingController();

  final dbRef = FirebaseDatabase.instance.ref("Message");
  final dbRef1 = FirebaseDatabase.instance.ref("User");
  final _auth = FirebaseAuth.instance.currentUser?.email;

  String? inputedAmount = "";
  var loginWalletData = "";
  var userWalletData = "";
  TextEditingController amountController = new TextEditingController();

  bool isFromSender = false;
  String? senderId;
  String? LoginName;
  File? imagePath, videoPath;

  bool isFromSelection = false;

  int i = 1;
  ScrollController _scrollController = ScrollController();

  FirebaseStorage storage = FirebaseStorage.instance;

  final Email = FirebaseAuth.instance.currentUser!.email;
  //.........................................


  String? prefDate;

  String? prefImageUrl;

  SharedPreferences? myPrefs;

  List<chatModel> chatModelList = [];


  /* get index => null;*/

  getIds() {
    if (isExist) {
      insertData(_message.text.toString());
      insertAmount(amountController.text.toString());
    } else {
      insertData(_message.text.toString());
      insertAmount(amountController.text.toString());
    }
  }

  insertData(String description) async {
    String? key = dbRef.child(userId.toString()).push().key;

    myPrefs = await SharedPreferences.getInstance();

    print("messageId_______________" + messageId.toString());
    print("Key________________" + key.toString());

    LoginName =
        MySharedPreferences.instance.getStringValue("name", "", myPrefs!);
    print("Login Name_________" +
        MySharedPreferences.instance
            .getStringValue("name", "", myPrefs!)
            .toString());

    print("LoginName__________" + LoginName.toString());

    dbRef.child(messageId.toString()).push().set({
      'id': key,
      'imageURL': "",
      'videoURL': "",
      'Description': description,
      'timeStamp': ServerValue.timestamp,
      'senderId': lUid,
      'recieverId': uId,
      'to': uName,
      'type': "text",
      'from': Email,
      'group': date.toString().split(" ")[0].toString(),
      'amount': "",
      isFromSender: senderId
    }).then((snapshot) {
      Fluttertoast.showToast(
          msg: "sent...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      getChatList();
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
  insertAmount(String description) async {
    String? key = dbRef.child(userId.toString()).push().key;

    myPrefs = await SharedPreferences.getInstance();

    print("messageId_______________" + messageId.toString());
    print("Key________________" + key.toString());

    LoginName =
        MySharedPreferences.instance.getStringValue("name", "", myPrefs!);
    print("Login Name_________" +
        MySharedPreferences.instance
            .getStringValue("name", "", myPrefs!)
            .toString());

    print("LoginName__________" + LoginName.toString());

    dbRef.child(messageId.toString()).push().set({
      'id': key,
      'imageURL': "",
      'videoURL': "",
      'Description': "",
      'timeStamp': ServerValue.timestamp,
      'senderId': lUid,
      'recieverId': uId,
      'to': uName,
      'type': "text",
      'from': Email,
      'group': date.toString().split(" ")[0].toString(),
      'amount': amountController.text.toString(),
      isFromSender: senderId
    }).then((snapshot) {
      Fluttertoast.showToast(
          msg: "sent...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      getChatList();
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }


  String readTimestamp(var timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('hh:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date); // Doesn't get called when it should be
    } else {
      time =
          diff.inDays.toString() + 'DAYS AGO'; // Gets call and it's wrong date
    }
    return time;
  }

  String? date = DateTime.now().toString();
  String? beforeDay = DateTime.now().subtract(Duration(days: 1)).toString();
  String? futureDay = DateTime.now().add(Duration(days: 1)).toString();

  /*Future<void> _upload(String inputSource) async {
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      imagePath = File(pickedImage!.path);

      File? imageFile = imagePath;

      final ref = storage
          .ref()
          .child(messageId.toString())
          .child(imagePath.toString() + DateTime.now().toString());

      try {
        await ref.putFile(
            imageFile!,
            SettableMetadata(customMetadata: {
              'uploaded_by': _auth.toString(),
              'description': fileName
            }));
        String imageUrl = await ref.getDownloadURL();

        // prefImageUrl = MySharedPreferences.instance.setStringValue("imageURL", imageUrl.toString());

        print("prefImageUrl______________" + prefImageUrl.toString());

        print(">>>>>>>>>>>>>>>>>>>>>>>>>" + imageUrl.toString());

        String? key = dbRef.child(userId.toString()).push().key;

        dbRef.child(messageId.toString()).push().set({
          'id': key,
          'Description': "",
          'imageURL': imageUrl,
          'videoURL': "",
          'timeStamp': ServerValue.timestamp,
          'senderId': lUid,
          'recieverId': uId,
          'type': "image",
          'to': uName,
          'from': userData?.email,
          'group': DateTime.now().toString().split(" ")[0],
          isFromSender: senderId
        });

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  Future<void> _videoUpload(String inputSource) async {
    try {
      pickedVideo = await picker.pickVideo(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
      );

      final String fileName = path.basename(pickedVideo!.path);
      videoPath = File(pickedVideo!.path);

      File? videoFile = videoPath;

      final ref = storage
          .ref()
          .child(messageId.toString())
          .child(videoPath.toString() + DateTime.now().toString());

      try {
        await ref.putFile(
            videoFile!,
            SettableMetadata(customMetadata: {
              'uploaded_by': _auth.toString(),
              'description': fileName
            }));
        String videoUrl = await ref.getDownloadURL();

        videoPlayerController1 = VideoPlayerController.network(videoUrl.toString());

        print(">>>>>>>>>>>>>>>>>>>>>>>>>" + videoUrl.toString());

        String? key = dbRef.child(userId.toString()).push().key;

        dbRef.child(messageId.toString()).push().set({
          'id': key,
          'Description': "",
          'imageURL': "",
          'videoURL': videoUrl,
          'timeStamp': ServerValue.timestamp.toString(),
          'senderId': lUid,
          'recieverId': uId,
          'type': "video",
          'to': uName,
          'from': userData?.email,
          'group': DateTime.now().toString().split(" ")[0],
          isFromSender: senderId
        });

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }*/

  String? fileName;
  String? Path;
  Map<String, String>? paths;
  List<String>? extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;
  // FileType? fileType;

  /*void _openFileExplorer() async {
    setState(() => isLoadingPath = true);
    try {
      if (isMultiPick) {
        videoPath = null;
        FilePickerResult? videoPicker = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'pdf', 'doc'],
            allowMultiple: true);
      } else {
        FilePickerResult? videoPicker = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'pdf', 'doc'],
            allowMultiple: true);
        videoPath = null;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoadingPath = false;
      fileName = Path != null
          ? path.split('/').last
          : paths != null
              ? paths?.keys.toString()
              : '...';
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("MessageId___________" + messageId.toString());
    dbRef.child(messageId.toString()).onChildAdded.listen((data) {
      // TODO: get message from snapshot and add to list
      print("set onChildAdded initState=-=-=-=-=-=-");
      getChatList();
    });
  }

  Timer scheduleTimeout([int milliseconds = 3000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  void handleTimeout() {
    // callback function
    print("time_________");
    getChatList();
  }

  getChatList() {
    // print("getChatList");
    dbRef.child(messageId.toString()).get().then((snapshot) async {
      chatModelList.clear();
      snapshot.children.forEach((element1) {
        chatModel model = chatModel.fromSnapshot(element1);
        setState(() {
          chatModelList.add(model);
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
          _scrollController.animateTo(
            _scrollController.position.extentAfter,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 200),
          );
        });
      });
      // print(">>>>>>>>>>>" + chatModelList.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(uName.toString()),
                /*Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.video_call,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      *//*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => videoCallScreen(),
                          ));*//*
                    },
                  ),
                )*/
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: <Color>[Colors.blue, Colors.purple]),
              ),
            ),

          ),
          body: Stack(children: <Widget>[
            SingleChildScrollView(
              reverse: true,
              controller: _scrollController,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 160,
                    child: GroupedListView<chatModel, String>(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      elements: chatModelList,
                      groupBy: (chatModel element) {
                        return element.group.toString();
                      },
                      order: GroupedListOrder.ASC,
                      useStickyGroupSeparators: true,
                      groupSeparatorBuilder: (value) => value ==
                              DateTime.now().toString().split(" ")[0]
                          ? Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                gradient:LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Colors.pink,
                                      Colors.blue,
                                    ],
                                  )
                              ),
                              child: Text(
                                "Today",
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 18, color: Colors.white),
                              ))
                          : Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                gradient:LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.pink,
                                    Colors.blue,
                                  ],
                                ),
                              ),
                              child: Text(
                                value.toString(),
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 18, color: Colors.white),
                              )),
                      itemBuilder: (context, chatModel) {
                        return Column(
                          children: [
                            Container(
                              padding: chatModel.senderId.toString() == lUid
                                  ? EdgeInsets.only(
                                      left: 50, right: 10, top: 10, bottom: 20)
                                  : EdgeInsets.only(
                                      left: 10, right: 50, top: 10, bottom: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        chatModel.senderId.toString() == lUid
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius: chatModel.senderId ==
                                                      lUid
                                                  ? BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20))
                                                  : BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20)),
                                              /*color: chatModel.senderId == lUid
                                                  ? Colors.blue
                                                  : Colors.blue[800],*/

                                              gradient:chatModel.senderId == lUid? LinearGradient(begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  Colors.pink,
                                                  Colors.blue,

                                                ],):LinearGradient(begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  Colors.blue,
                                                  Colors.green,

                                                ],)
                                            ),
                                            child: InkWell(
                                              onLongPress: () {
                                                Widget cancelButton = TextButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                );
                                                Widget deleteButton = TextButton(
                                                  child: Text("Delete"),
                                                  onPressed: () async {
                                                    setState(() {
                                                      dbRef
                                                          .child(messageId
                                                              .toString())
                                                          .child(chatModel.key
                                                              .toString())
                                                          .remove();
                                                      Navigator.pop(context);
                                                      print("______" +
                                                          chatModel.key
                                                              .toString());
                                                      getChatList();
                                                    });
                                                  },
                                                );
                                                AlertDialog alert = AlertDialog(
                                                  title: Text("AlertDialog"),
                                                  content: Text(
                                                      "Are you sure you want to delete this data?"),
                                                  actions: [
                                                    cancelButton,
                                                    deleteButton,
                                                  ],
                                                );
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      chatModel.Description
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                          Colors.white),
                                                      softWrap: false,
                                                      maxLines: i++,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  /*Container(
                                                    child: Text(chatModel.timeStamp.toString(),
                                                       // readTimestamp("${chatModel.timeStamp}"),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white70,
                                                          fontWeight:
                                                          FontWeight.w600),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),*/
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      // height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.attach_money),
                              onPressed: () {
                                print("click");
                                _displayTextInputDialog(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey)),
                              child: TextFormField(
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                controller: _message,
                                maxLines: 1000,
                                minLines: 1,
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                keyboardAppearance: Brightness.light,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                    hintText: "write here",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [Colors.pink, Colors.blue])
                            ),
                            padding: EdgeInsets.only(right: 10),
                            child: FloatingActionButton(
                              heroTag: "type",
                              onPressed: () {
                                // isFromSender = true;
                                if (_message.text.toString().isEmpty) {
                                  // webViewMethod();
                                  Fluttertoast.showToast(
                                      msg: "Type Something.......",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  getIds();
                                  _message.clear();
                                  getChatList();
                                }
                              },
                              child: Container(
                                 padding: EdgeInsets.only(left: 10),
                                child:Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                               backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Your Amount'),
            content: Column(
              children: [
                Container(child: Text("Amount"),),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(hintText: "Text Field in Dialog"),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.blue,
                            Colors.red,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text('Pay')),
                onPressed: () {
                  print("Update");
                  print("loginId__" + lUid.toString());
                  print("loginId__" + uId.toString());
                  // dbRef1.child(lUid.toString()).get();

                  dbRef1.child(lUid.toString()).once().then((value) {
                    print("loginID WALLET____" +
                        value.snapshot.child("wallet").value.toString());
                    loginWalletData =
                        value.snapshot.child("wallet").value.toString();

                    dbRef1.child(uId.toString()).once().then((value) {
                      print("userID WALLET____" +
                          value.snapshot.child("wallet").value.toString());
                      userWalletData =
                          value.snapshot.child("wallet").value.toString();

                      if (double.parse(loginWalletData) >=
                          double.parse(amountController.text.toString()/*inputedAmount.toString()*/)) {
                        double loginW = double.parse(loginWalletData) -
                            double.parse(amountController.text.toString()/*inputedAmount.toString()*/);
                        double userW = double.parse(userWalletData) +
                            double.parse(amountController.text.toString()/*inputedAmount.toString()*/);
                        dbRef1.child(lUid.toString()).update(
                            {"wallet": loginW.toString()}).then((value) {
                          dbRef1.child(uId.toString()).update(
                              {"wallet": userW.toString()}).then((value) {
                            Fluttertoast.showToast(
                                msg: "Transfered SuccessFully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            amountController.clear();
                            Navigator.pop(context);
                          }).catchError((error) {
                            Fluttertoast.showToast(
                                msg: error.toString(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          });
                        }).catchError((error) {
                          Fluttertoast.showToast(
                              msg: error.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });

                      } else {
                        Fluttertoast.showToast(
                            msg: "you have insufficient balance",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }).catchError((error) {
                      Fluttertoast.showToast(
                          msg: error.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
                  }).catchError((error) {
                    Fluttertoast.showToast(
                        msg: error.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                  if (_message.text.toString().isEmpty) {
                    // webViewMethod();
                    Fluttertoast.showToast(
                        msg: "Please Enter Amount.......",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    getIds();
                    amountController.clear();
                    getChatList();
                  }

                },
              ),
            ],
          );
        });
  }
}

/*
class FullImagePageRoute extends StatelessWidget {
  String imageDownloadUrl;

  FullImagePageRoute(this.imageDownloadUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.red,
            ],
          )
        ),
          child: PhotoView(
        imageProvider: NetworkImage(imageDownloadUrl),
      )),
    );
  }
}

String videoDownloadUrl = "";
// VideoPlayerController? videoPlayerController;
Future<void>? videoPlayerFuture;
// ChewieController? chewieController;

class FullVideoPageRoute extends StatefulWidget {
  FullVideoPageRoute(String videoDownloadUrl1) {
    videoDownloadUrl = videoDownloadUrl1;
  }

  @override
  _MyVideoPlayerPageState createState() => _MyVideoPlayerPageState();
}

class _MyVideoPlayerPageState extends State<FullVideoPageRoute> {

  */
/*final playerWidget = Chewie(
    controller: chewieController!,
  );*//*

 */
/* @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
    print("videoURL_____________"+videoDownloadUrl.toString());
  }*//*

  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(videoDownloadUrl),
      aspectRatio:5/8,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    setState(() {
      chewieController?.dispose();
      videoPlayerController?.dispose();
    });
    super.dispose();
  }

  */
/*initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(videoDownloadUrl);
    await Future.wait([videoPlayerController!.initialize()]);
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: true, showControlsOnInitialize: true);
  }*//*


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body:
       Container(
         child: Center(
           child: Chewie(
             controller: chewieController!,
           ),
         ),
       ),
       */
/*  FutureBuilder(
        future: videoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                AspectRatio(
                  aspectRatio: videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController!),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          fixedSize: MaterialStateProperty.all(Size(70, 70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)))),
                      onPressed: () {
                        videoPlayerController?.seekTo(Duration(
                            seconds: videoPlayerController!
                                    .value.position.inSeconds +
                                10));
                      },
                      child: Icon(Icons.fast_forward)),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  alignment: Alignment.topCenter,
                  child: VideoProgressIndicator(
                    videoPlayerController!,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                        backgroundColor: Colors.red,
                        bufferedColor: Colors.black,
                        playedColor: Colors.lightGreenAccent),
                  ),
                )
              ],
            );
          } else {
            return Center(
                child: Text("No Video Found"));
          }
        },
      ),*//*

       */
/*floatingActionButton: FloatingActionButton(
          heroTag: "video",
          onPressed: () {
            setState(() {
              videoPlayerController!.value.isPlaying
                  ? videoPlayerController!.pause()
                  : videoPlayerController!.play();
            });
          },
          child: Icon(
            videoPlayerController!.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
        )*//*

    );
  }
}

class VCaption extends StatefulWidget {
  VCaption(
    this.videoPlayerController,
  );

  final VideoPlayerController videoPlayerController;

  @override
  _VCaptionState createState() => _VCaptionState();
}

class _VCaptionState extends State<VCaption> {
  String? selectedCaption = "";
  Map<int, String> captions = {5: "First subtitle", 20: "Second subtitle"};

  @override
  void initState() {
    widget.videoPlayerController.addListener(() {
      if (widget.videoPlayerController.value.isPlaying) {
        print("Time ${widget.videoPlayerController.value.position.inSeconds}");
        setState(() {
          if (captions.containsKey(
              widget.videoPlayerController.value.position.inSeconds)) {
            selectedCaption =
                captions[widget.videoPlayerController.value.position.inSeconds];
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClosedCaption(
      text: selectedCaption,
      textStyle: TextStyle(fontSize: 15, color: Colors.white),
    );
  }
}
*/
