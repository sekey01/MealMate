import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import '../../components/Notify.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});


  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),
            title: Text('edit Profile', style: TextStyle(color: Colors.blueGrey, letterSpacing: 3, fontWeight: FontWeight.bold),), centerTitle: true,
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: Icon(Icons.qr_code_2_outlined, color: Colors.deepOrangeAccent,),
              )
            ],
          ),
        body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8),
                child: Image(image: AssetImage('assets/images/logo.png'), height: 150, width: 150,),
              ),
              SizedBox(height: 50.h,),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                                  children: [

                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Form(
                key: _formKey,

                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(8),
                      child: TextField(

                        style: TextStyle(color: Colors.black),
                        controller: _usernameController,
                        decoration: InputDecoration(
                            hintText: 'Change Username',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                                borderSide: BorderSide(color: Colors.grey)),
                            fillColor: Colors.deepOrange.shade50,
                            filled: true),
                        onSubmitted: (value) {
                          setState(() {
                            Provider.of<LocalStorageProvider>(context,
                                listen: false)
                                .storeUsername(_usernameController.text);
                          });
                          _usernameController.clear();

                          setState(() {
                            Notify(context, 'username saved', Colors.green);

                          });

                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onFieldSubmitted: (value){
                          if (_formKey.currentState?.validate() ?? false) {

                            Provider.of<LocalStorageProvider>(context,listen: false).storePhoneNumber(value);
                            Notify(context, 'phone Number changed successfully', Colors.green);

                          }

                        },
                        maxLength: 10,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20.sp),
                        keyboardType: TextInputType.numberWithOptions(),

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(color: Colors.deepOrangeAccent)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(color: Colors.deepOrangeAccent),
                            ),
                            label: Text('Enter number: 0542169225 '),
                            labelStyle: TextStyle(color: Colors.black,fontSize: 15.sp,)),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '   This field cannot be empty';
                          }
                          //if phone number is not up to 10 digits
                          if (value.length < 10 || value.length > 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null; // return null if the input is valid
                        },

                      ),
                    ),
                  ],
                ),

                                  ),
                                ),
                                  ],
                                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
