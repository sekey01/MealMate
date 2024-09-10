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
              Padding(padding: EdgeInsets.all(8),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      hintText: 'Change Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          borderSide: BorderSide(color: Colors.grey)),
                      fillColor: Colors.grey,
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
              Padding(padding: EdgeInsets.all(8),
                child: TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                      hintText: 'Change Telephone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                          borderSide: BorderSide(color: Colors.grey)),
                      fillColor: Colors.grey,
                      filled: true),
                  onSubmitted: (value) {
                    setState(() {
                      Provider.of<LocalStorageProvider>(context,
                          listen: false)
                          .storeNumber(_phoneNumberController.text);
                    });
                    _phoneNumberController.clear();
setState(() {
  Notify(context, 'phone number saved', Colors.green);
});
                  },
                ),
              ),
              SizedBox(height: 80.h,)
            ],
          ),
        ),
      ),
    );
  }
}
