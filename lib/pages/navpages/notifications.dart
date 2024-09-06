import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/AdminPanel/components/adminHorizontalCard.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import 'package:mealmate/components/CustomLoading.dart';
import 'package:provider/provider.dart';

class Notice extends StatefulWidget {
  const Notice({super.key});

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {

  Future<List<Notification>> getNotifications() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Notifications')
          //.orderBy('timestamp', descending: true)
          .get();

      List<Notification> notifications = snapshot.docs
          .map((doc) => Notification.fromFirestore(doc))
          .toList();

   Provider.of<LocalStorageProvider>(context, listen: false).notificationLength = notifications.length;

      return notifications;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios, color: Colors.blueGrey,)),
         title: Text('Notifications', style: TextStyle(fontSize: 20.sp, color: Colors.blueGrey, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: FutureBuilder(future: getNotifications(),
          builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CustomLoGoLoading());
        }
            else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final notice = snapshot.data![index];
                  return ListTile(
                    leading: Text('message:', style: TextStyle(color: Colors.black, fontSize: 10.sp,fontWeight: FontWeight.bold)),
                    title: RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "Meal", style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.bold)),
                          TextSpan(text: "Mate", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.sp, fontWeight: FontWeight.bold)),


                        ]
                    )),
                    subtitle: Text(notice.message, style: TextStyle(color: Colors.black, fontSize: 15.sp)),
                  );
                },
              );
            }
else{
  return Center(child: Text('No Notifications Available',style: TextStyle(color: Colors.black, fontSize: 10.spMin, fontWeight: FontWeight.bold) ));
            }
      }
      ),
    );
  }
}


class Notification {
  final String message;
  //final DateTime timestamp;

  Notification({required this.message,
    //required this.timestamp
  });

  factory Notification.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Notification(
      message: data['notification'] ?? '',
      //timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}