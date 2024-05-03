 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> functionDBCall(String fun_method,String fun_result) async {
  print("FunctionDBCall starting");
  User? user = FirebaseAuth.instance.currentUser;
  final uid = user!.uid;
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final pointsRef = FirebaseFirestore.instance
        .collection('function')
        .doc(uid)
        .collection('methods');
  
  final documentRef = pointsRef.doc(timestamp.toString());
    await documentRef.set({
      'method': fun_method,
      'result': fun_result,
      'scanningTime': FieldValue.serverTimestamp(),
    });
    
  print("FunctionDBCall ending");
  }