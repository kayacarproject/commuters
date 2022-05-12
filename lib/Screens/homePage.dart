
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Constant/MySharedPreferences.dart';
import '../Model/homePageModel.dart';
import 'ChatPage.dart';
import 'LoginPage.dart';
import 'MessagePage.dart';
import 'SignUpPage.dart';

/*
String? uId;
BuildContext? rContext;
*/
BuildContext? ctx;
bool isFromMSG = true;
String? loginId;
String? loigEmail;

class homePage extends StatefulWidget {
  homePage(
      bool? isFromMessage, BuildContext? context, String lUid, String uEmail) {
    isFromMSG = isFromMessage!;
    ctx = context!;
    loginId = lUid;
    loigEmail = uEmail;
  }

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final dbRef = FirebaseDatabase.instance.ref("User");
  Query? _ref;
  // DataSnapshot? snapshot;

  final _auth = FirebaseAuth.instance.currentUser?.uid;
  final email = FirebaseAuth.instance.currentUser?.email;

  List<homePageModel> homepageModelList = [];

  /* getData() {
    dbRef.get().then((snapshot) async {
     snapshot.children.forEach((element) {

       homePageModel model = homePageModel.fromSnapshot(element);

       if(loginId != _auth){
        homepageModelList.add(model);
        print("name___"+model.name.toString());
        print("name___"+model.birthdate.toString());
        print("name___"+model.email.toString());
        print("name___"+model.password.toString());
        print("name___"+model.mobile.toString());
        print("name___"+model.gender.toString());
        print("name___"+model.city.toString());

       }else{
         print("no data found");
       }


       */
  /*if(loginId == _auth){
       print(element.value.toString());
       print(element.child("name").value.toString());
       print(element.child("email").value.toString());}else{
         print("no data found");
       }*/
  /*
     });

     */
  /*snapshot.children.forEach((element) {
       if(loginId == _auth){
         filterlist.add(homeData(
           key: element.key.toString(),
           name: element.child("name").value.toString(),
           email: element.child("email").value.toString(),
           mobile: element.child("mobile").value.toString(),
           city: element.child("city").value.toString(),
           gender: element.child("gender").value.toString(),
           password: element.child("password").value.toString(),
           birthdate: element.child("birthdate").value.toString(),
         ));
       }
     });

    return filterlist;*/ /*
     */
  /* snapshot.children.forEach((element) {if(loginId != _auth){
        print("*******************************"+element.toString());
        filterlist.add(snapshot.child("name").value.toString());
        filterlist.add(snapshot.child("email").value.toString());
        filterlist.add(snapshot.child("password").value.toString());
        filterlist.add(snapshot.child("mobile").value.toString());
        filterlist.add(snapshot.child("city").value.toString());
        filterlist.add(snapshot.child("gender").value.toString());
        filterlist.add(snapshot.child("birthdate").value.toString());


      } });*/ /*
    });

  }*/

  getData() {
    // print("getChatList");

    dbRef.get().then((snapshot) async {
      homepageModelList.clear();
      snapshot.children.forEach((element1) {
        homePageModel model = homePageModel.fromSnapshot(element1);
        if(email != element1.child("email").value.toString() && model.type == "driver"){
          setState(() {
            homepageModelList.add(model);
            print("name____" + model.name.toString());
            print(element1.value.toString());
          });
        }
      });
      // print(">>>>>>>>>>>" + chatModelList.length.toString());
    });
    return homepageModelList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = dbRef;

    print("---------------" + loginId.toString());
    print("---------------" + _auth.toString());
    getData();
    print("welcome to home page");
    print("////////////////" + email.toString());
    print("////////////////" + loigEmail.toString());
  }

  bool isFromMessage = true;

  String? abc;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Home Page'),
                    InkWell(
                      onTap: () {
                        Widget cancelButton = TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );
                        Widget continueButton = TextButton(
                          child: Text("Continue"),
                          onPressed: () async {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil<void>(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) => LoginPage()),
                              ModalRoute.withName('/'),
                            );
                            MySharedPreferences.instance.removeAll();
                          },
                        );
                        // set up the AlertDialog
                        AlertDialog alert = AlertDialog(
                          title: Text("AlertDialog"),
                          content:
                              Text("Are you sure you want to Logout?"),
                          actions: [
                            cancelButton,
                            continueButton,
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      },
                      child: Text('Logout'),
                    )
                    // IconButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=> MessagePage())); }, icon: Icon(Icons.arrow_forward),)
                  ],
                ),
              ),
              body: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.separated(
                    itemCount: homepageModelList.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (BuildContext context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              print("key______"+ homepageModelList[index].key.toString());
                              String? name =
                                  homepageModelList[index].name.toString();
                              print("+++++++++++" + name);
                              print("name+++" + homepageModelList[index].name.toString());
                              userId = homepageModelList[index].key.toString();
                              FirebaseDatabase.instance
                                  .ref("Message")
                                  .get()
                                  .then((snapshot) {

                                    if(snapshot.child(homepageModelList[index].key.toString() + loginId.toString()).exists){
                                      isExist = true;
                                      print(">>>>>>>>>>>>" + isExist.toString());
                                      print(">>>>>>>>>>>>" +
                                          userId.toString() +
                                          loginId.toString());

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                userId.toString(),
                                                name,
                                                context,
                                                loginId.toString(),
                                                userId.toString() +
                                                    loginId.toString(),
                                              )));
                                    }
                                    else{
                                      isExist = false;
                                      print(">>>>>>>>>>>>" + isExist.toString());
                                      print(">>>>>>>>>>>>" +
                                          userId.toString() +
                                          loginId.toString());

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                userId.toString(),
                                                name,
                                                context,
                                                loginId.toString(),
                                                loginId.toString()+userId.toString() ,
                                              )));
                                    }
                                /*if (snapshot
                                    .child(homepageModelList[index].key.toString() + loginId.toString())
                                    .exists) {
                                  isExist = true;
                                  print(">>>>>>>>>>>>" + isExist.toString());
                                  print(">>>>>>>>>>>>" +
                                      userId.toString() +
                                      loginId.toString());

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                                userId.toString(),
                                                name,
                                                context,
                                                loginId.toString(),
                                                userId.toString() +
                                                    loginId.toString(),
                                              )));
                                }
                                else {
                                  if (snapshot
                                      .child(
                                          loginId.toString() + homepageModelList[index].key.toString()+userId.toString())
                                      .exists) {
                                    isExist = true;
                                    print(">>>>>>>>>>>>a" + isExist.toString());
                                    print(">>>>>>>>>>>>a" +
                                        userId.toString() +
                                        loginId.toString());
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                userId.toString(),
                                                name,
                                                context,
                                                loginId.toString(),
                                                loginId.toString() +
                                                    userId.toString())));
                                  } else {
                                    isExist = false;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                userId.toString(),
                                                name,
                                                context,
                                                loginId.toString(),
                                                userId.toString() +
                                                    loginId.toString())));
                                    print(">>>>>>>>>>>>b" + isExist.toString());
                                    print(">>>>>>>>>>>>b" +
                                        userId.toString() +
                                        loginId.toString());
                                  }
                                }*/
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.only(top: 10, bottom: 20),
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        homepageModelList[index].name.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone_iphone,
                                        color: Theme.of(context).accentColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        homepageModelList[index].email.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.group_work,
                                        color: Theme.of(context).accentColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        homepageModelList[index].password.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        homepageModelList[index].mobile.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_city,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        homepageModelList[index].city.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        homepageModelList[index].gender.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        homepageModelList[index].birthdate.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: IconButton(
                              onPressed: () {
                                Widget cancelButton = TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                                Widget continueButton = TextButton(
                                  child: Text("Continue"),
                                  onPressed: () async {
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('User')
                                        .child(userId.toString())
                                        .remove();
                                    Navigator.pop(context);

                                    User user =
                                        await FirebaseAuth.instance.currentUser!;
                                    user.delete();
                                  },
                                );

                                // set up the AlertDialog
                                AlertDialog alert = AlertDialog(
                                  title: Text("AlertDialog"),
                                  content: Text(
                                      "Are you sure you want to delete this data?"),
                                  actions: [
                                    cancelButton,
                                    continueButton,
                                  ],
                                );

                                // show the dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                          )
                        ],
                      );
                    },
                  )
                  /*FirebaseAnimatedList(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    query: dbRef.orderByChild("email").equalTo(this.email)
            ,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation animation, int index) {

                      return
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              String? name =
                              snapshot.child("name").value.toString();
                              print("+++++++++++"+name);
                                print("name+++" + snapshot.key.toString());
                                String? userId = snapshot.key.toString();

                              FirebaseDatabase.instance.ref("Message").get().then((snapshot) {
                                if (snapshot.child(userId.toString() + loginId.toString()).exists) {
                                  isExist = true;
                                  print(">>>>>>>>>>>>"+isExist.toString());
                                  print(">>>>>>>>>>>>"+userId.toString() + loginId.toString());

                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(userId,name, context,loginId.toString(),userId.toString() + loginId.toString(),)));

                                } else {
                                  if (snapshot.child(loginId.toString() + userId.toString()).exists) {

                                    isExist = true;
                                    print(">>>>>>>>>>>>a"+isExist.toString());
                                    print(">>>>>>>>>>>>a"+userId.toString() + loginId.toString());
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(userId,name, context,loginId.toString(), loginId.toString() + userId.toString())));
                                  } else {
                                    isExist = false;
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(userId,name, context,loginId.toString(),userId.toString() + loginId.toString() )));
                                    print(">>>>>>>>>>>>b"+isExist.toString());
                                    print(">>>>>>>>>>>>b"+userId.toString() + loginId.toString());
                                  }
                                }
                              });


                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.only(top: 10, bottom: 20),
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                         snapshot.child("name").value.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone_iphone,
                                        color: Theme.of(context).accentColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(

                                        snapshot.child("email").value.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.group_work,
                                        color: Theme.of(context).accentColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(

                                        snapshot
                                            .child("password")
                                            .value
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        snapshot.child("mobile").value.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_city,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(

                                        snapshot.child("city").value.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(

                                        snapshot.child("gender").value.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(

                                        snapshot
                                            .child("birthdate")
                                            .value
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: IconButton(
                              onPressed: () {
                                Widget cancelButton = TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                                Widget continueButton = TextButton(
                                  child: Text("Continue"),
                                  onPressed: () async {
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('User')
                                        .child(snapshot.key.toString())
                                        .remove();
                                    Navigator.pop(context);

                                    User user = await FirebaseAuth.instance.currentUser!;
                                    user.delete();

                                    },
                                );

                                // set up the AlertDialog
                                AlertDialog alert = AlertDialog(
                                  title: Text("AlertDialog"),
                                  content: Text("Are you sure you want to delete this data?"),
                                  actions: [
                                    cancelButton,
                                    continueButton,
                                  ],
                                );

                                // show the dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                          )
                        ],
                      );
                    },
                  )*/

                  ))),
    );
  }
}
