import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/global.dart';
import 'package:next_hour/home.dart';
import 'package:dio/dio.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Dio dio = new Dio();
  FormData formdata = new FormData();
  TextEditingController _editEmailController = new TextEditingController();
  TextEditingController _editNameController = new TextEditingController();
  TextEditingController _editOldPasswordController = new TextEditingController();
  TextEditingController _editNewPasswordController = new TextEditingController();
  TextEditingController _editNewConfirmPasswordController = new TextEditingController();
  TextEditingController _editDOBController = new TextEditingController();
  TextEditingController _editMobileController = new TextEditingController();
  bool _isOldHidden = true;
  bool _isNewHidden = true;
  bool _isConfirmNewHidden = true;
  DateTime _dateTime= new DateTime.now();
  String pickedDate='';

  var files;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  var currentPassword, newPassword, newDob, newMobile, newName;
  bool isShowIndicator=false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

//  Show a dialog after updating password
    Future<void> _profileUpdated(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
            ),
            child: AlertDialog(
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Profile Saved!',style: TextStyle(color: Color.fromRGBO(34, 34, 34, 1.0)),),
              content: Container(
                height: 70.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 2.0,
                    ),
                    Icon(FontAwesomeIcons.checkCircle, size: 40.0, color: greenPrime),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('Login Again!',style: TextStyle(color: Color.fromRGBO(34, 34, 34, 1.0)),),
                  ],
                ) ,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok',style: TextStyle(fontSize: 16.0,color: greenPrime),),
                  onPressed: () {
                    deleteFile();
                    var router = new MaterialPageRoute(
                        builder: (BuildContext context) => new Home()
                    );
                    Navigator.of(context).push(router);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//  This future process the profile update and save details to the server.
    Future <String> updateProfile() async{
    newDob  = DateFormat("y-MM-dd").format(_dateTime);
    newMobile=_editMobileController.text;
    newName=_editNameController.text;
    String imagefileName = tmpFile != null ? tmpFile.path.split('/').last: '';
    try{
      if(imagefileName != ''){
        formdata.add(
            "image", new UploadFileInfo(tmpFile, imagefileName)
        );
      }
      formdata.add(
        "email", email
      );
      formdata.add(
          "current_password", currentPassword
      );
      formdata.add(
          "new_password", newPassword
      );
      formdata.add(
          "dob", newDob
      );
      formdata.add(
          "mobile", newMobile
      );
      formdata.add(
          "name", newName
      );

      await dio.post(APIData.userProfileUpdate, data: formdata, options: Options(
          method: 'POST',

          headers: {
            // ignore: deprecated_member_use
            HttpHeaders.AUTHORIZATION: fullData,
          }
      )).then(
              (response) {
                setState(() {
                  isShowIndicator = false;
                });
                _profileUpdated(context);
              }
      )
          .catchError((error) => print(error.toString()));

    }
    catch(e){
      setState(() {
        isShowIndicator = false;
      });
      print(e);
    }
    return null;
  }

//  For selecting image from camera
    chooseImageFromCamera() {
    setState(() {
      files = ImagePicker.pickImage(source: ImageSource.camera);
    });
  }

//  For selecting image from gallery
    chooseImageFromGallery() {
    setState(() {
      files = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

//  This Future picks date using material date picker
    Future<Null> _selectDate() async{
    final DateTime picked= await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: new DateTime(1970),
      lastDate: new DateTime.now(),
    );
    if(picked !=null)
    {
      setState(() {
        _editDOBController.text=pickedDate;
        _dateTime=picked;
      });
      // ignore: unrelated_type_equality_checks
      String formattedDate = _dateTime != '' ? DateFormat.yMMMd().format(_dateTime) : '';
      pickedDate= formattedDate;

    }
  }

//  This function delete the file that have login credentials.
    void deleteFile() {
    File file = new File(dir.path + "/" + fileName);
    file.delete();
    fileExists = false;
  }

//  Visibility toggle for old password
    void _toggleVisibility1() {
    setState(() {
      _isOldHidden = !_isOldHidden;
    });
  }

//  Visibility toggle for new password
    void _toggleVisibility2() {
    setState(() {
      _isNewHidden = !_isNewHidden;
    });
  }

//  Visibility toggle for confirm password
    void _toggleVisibility3() {
    setState(() {
      _isConfirmNewHidden = !_isConfirmNewHidden;
    });
  }

//  Appbar
    Widget appbar(){
    return AppBar(
      title: Text("Edit Profile",style: TextStyle(fontSize: 16.0),),
      centerTitle: true,
      backgroundColor: Color.fromRGBO(34, 34, 34, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    currentPassword=_editOldPasswordController.text;
    newPassword=_editNewPasswordController.text;
    newDob=_editDOBController.text;
    newMobile=_editMobileController.text;
    newName=_editNameController.text;
    _editEmailController.text=email;
    _editNameController.text= newName != '' ? newName : name == 'N/A' ? '' : name;
    _editDOBController.text= pickedDate != '' ? pickedDate : dob == 'N/A' ? '' : dob;
    _editMobileController.text=newMobile!=''? newMobile: mobile == 'N/A' ? '' : mobile;

    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: appbar(),
          body: scaffoldBody(),
      ),
    );
  }

//  Scaffold body
    Widget scaffoldBody(){
      return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  showImage(),
                  browseImageButton(),
                ],
              ),
              form(),
            ],
          )
      );
    }

//  Browse button container
    Widget browseImageButton(){
      return Container(
        height: 45.0,
        width:45.0,
        margin: EdgeInsets.fromLTRB(125.0, 170.0, 0.0, 0.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(125,183,91, 1.0),
        ),
        child: IconButton(icon: Icon(Icons.add_a_photo),
          onPressed: _onButtonPressed,
        ),
      );
    }

//  Form that containing text fields to update profile
    Widget form(){
      return Container(
        padding: EdgeInsets.only(
            top: 10.0, right: 20.0, left: 20.0, bottom: 20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),

              buildNameTextField("Name"),
              SizedBox(
                height: 20.0,
              ),
              buildOldPasswordTextField("Old Password"),
              SizedBox(
                height: 20.0,
              ),
              buildNewPasswordTextField("New Password"),
              SizedBox(
                height: 20.0,
              ),
              buildNewConfirmPasswordTextField("Confirm New Password"),
              SizedBox(
                height: 20.0,
              ),
              buildDOBTextField("Date of Birth"),
              SizedBox(
                height: 20.0,
              ),
              buildMobileTextField("Mobile Number"),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(height: 20.0),
              updateButtonContainer(),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      );
    }

//  Name TextField to update name
    Widget buildNameTextField(String hintText) {
    return TextFormField(
      controller: _editNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.account_box),
      ),
      validator: (val) {
        if (val.length == 0) {
          return 'Name can not be empty';
        } else {
          if (val.length < 4) {
            return 'Name required at least 5 characters.';
          } else {
            return null;
          }
        }
      },
      onSaved: (val) => _editNameController.text = val,
    );
  }

//  Old password TextField to update name
    Widget buildOldPasswordTextField(String hintText) {
    return TextFormField(
      controller: _editOldPasswordController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.lock_outline),
        suffixIcon: hintText == "Old Password" ?
        IconButton(
          onPressed: _toggleVisibility1,
          icon: _isOldHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),) : null,
      ),
      validator: (val) {
        if (val.length < 6) {
          if (val.length == 0) {
            return 'Old password can not be empty';
          } else {
            return 'Password too short';
          }
        } else {
          return null;
        }
      },
      onSaved: (val) => _editOldPasswordController.text = val,
      obscureText: hintText == "Old Password" ? _isOldHidden : false,
    );
  }

//  TextField for new password
    Widget buildNewPasswordTextField(String hintText) {
    return TextFormField(
      controller: _editNewPasswordController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: hintText == "New Password" ?
        IconButton(
                onPressed: _toggleVisibility2,
                icon: _isNewHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),) : null,),

      obscureText: hintText == "New Password" ? _isNewHidden : false,

      validator: (val) {
        if (val.length < 6) {
          if(val.length==0){
            return null;
          }else{
            return 'New Password too short';
          }

        } else {
          if(_editOldPasswordController.text == val){
            return 'New password should be different from old password.';
          }else{
            return null;
          }

        }
      },
      onSaved: (val) => _editNewPasswordController.text = val,
    );
  }

//  Confirmation of new password field
    Widget buildNewConfirmPasswordTextField(String hintText) {
    return TextFormField(
      controller: _editNewConfirmPasswordController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: hintText == "Confirm New Password" ?
        IconButton(
          onPressed: _toggleVisibility3,
          icon: _isConfirmNewHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),) : null,
      ),
      obscureText: hintText == "Confirm New Password" ? _isConfirmNewHidden : false,
/*
      Validation for password
*/
      validator: (val) {
        if (val.length < 6) {
          if(val.length==0){
            return null;
          }else{
            return 'New Password too short';
          }
        } else {
          if(_editNewPasswordController.text == val){
            return null;
          }else{
            return 'New Password & Confirm new password does not match.';
          }

        }
      },
      onSaved: (val) => _editNewConfirmPasswordController.text = val,
    );
  }

//  TextField Date of birth field
    Widget buildDOBTextField(String hintText) {
    return TextField(
      controller: _editDOBController,
      focusNode: AlwaysDisabledFocusNode(),
      onTap: _selectDate,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.calendar_today),
      ),
    );
  }

//  TextField to update mobile number
    Widget buildMobileTextField(String hintText) {
    return TextField(
      controller: _editMobileController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.phone),
      ),
    );
  }

//  Update button container
    Widget updateButtonContainer() {
    return InkWell(
      child: Container(
        height: 56.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23.0),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(72, 163, 198, 0.4).withOpacity(0.4),
            Color.fromRGBO(72, 163, 198, 0.3).withOpacity(0.5),
            Color.fromRGBO(72, 163, 198, 0.2).withOpacity(0.6),
            Color.fromRGBO(72, 163, 198, 0.1).withOpacity(0.7),
          ], begin: Alignment.centerRight, end: Alignment.centerLeft),
        ),
        child: Center(
          child: isShowIndicator==true? CircularProgressIndicator(
            backgroundColor: Colors.white,
          ) : Text(
            "Update Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
          onTap: (){
//     To remove keypad on tapping button
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              setState(() {
                isShowIndicator = true;
              });
                final form = formKey.currentState;
                form.save();
                if (form.validate() == true) {
                  updateProfile();
                  }else{
                  setState(() {
                    isShowIndicator = false;
                  });
                }
              },
    );
  }

//  Preview of selected image
    Widget showImage() {
    return FutureBuilder<File>(
      future: files,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
            alignment: Alignment.center,
              height: 210.0,
              width: 170.0,
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0)),
                  ),
                  child: Container(

                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      height: 190.0,
                      width: 150.0,
                      decoration:new BoxDecoration(
                          color:  Colors.white.withOpacity(0.2),
                          border: new Border.all(color: Colors.white.withOpacity(0.0), width: 10.0),
                          borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0))

                      ),
                      child: Card(
                        margin: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0)),
                        ),
                        child:   ClipRRect(
                          borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0)),
                          child: tmpFile == null ? userImage == null ? Image.asset(
                            "assets/avatar.png",
                            fit: BoxFit.cover,
                            scale: 1.7,
                          ): Image.network(
                            "${APIData.profileImageUri}"+"$userImage",
                            fit: BoxFit.cover,
                            scale: 1.7,
                          ) : Image.file(
                            tmpFile,
                            fit: BoxFit.cover,
                            scale: 1.7,
                          ),
                        ),
                      )
                  )
              )
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Container(
              height: 210.0,
              width: 170.0,
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0)),
                ),
              child:Container(

                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  height: 190.0,
                  width: 150.0,
                  decoration:new BoxDecoration(
                      color:  Colors.white.withOpacity(0.2),
                      border: new Border.all(color: Colors.white.withOpacity(0.0), width: 10.0),
                      borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0))

                  ),
                  child: Card(
                    margin: EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0)),
                    ),
                    child:   ClipRRect(
                      borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0)),
                      child: tmpFile == null ? userImage == null ? Image.asset(
                        "assets/avatar.png",
                        fit: BoxFit.cover,
                        scale: 1.7,
                      ): Image.network(
                          "${APIData.profileImageUri}"+"$userImage",
                        fit: BoxFit.cover,
                        scale: 1.7,
                      ) : Image.file(
                        tmpFile,
                        fit: BoxFit.cover,
                        scale: 1.7,
                      ),
                    ),
                  )
              )
            )
          );
        }
      },
    );
  }

//  Creating bottom sheet for selecting profile picture
    Widget bottomSheet() {
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
              onTap: (){
                chooseImageFromCamera();
              },
            child: Padding(padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.camera, color: Color.fromRGBO(34,34,34,1.0), size: 35,),
                Container(
                  width: 250.0,
//                  height: 15.0,
                  child:  ListTile(
                    title: Text('Camera',style: TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),),
                    subtitle: Text("Click profile picture from camera.",style: TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),),
                  ),
                )
              ],
            ),
            )
          ),
          InkWell(
              onTap: (){
                chooseImageFromGallery();
                Navigator.pop(context);
              },
              child: Padding(padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.photo, color: Color.fromRGBO(34,34,34,1.0), size: 35,),
                    Container(
                      width: 260.0,
                      child:  ListTile(
                        title: Text('Gallery',style: TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),),
                        subtitle: Text("Choose profile picture from gallery.",style: TextStyle(color: Color.fromRGBO(20, 20, 20, 1.0)),),
                      ),
                    )

                  ],
                ),
              )
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0),
        ),
      ),
    );
  }

//  Show bottom sheet
    void _onButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 190.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            child: new Container(
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(34, 34, 34, 1.0),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: bottomSheet()),
          );
        });
  }
}
  class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
