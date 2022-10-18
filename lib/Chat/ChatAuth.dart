import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ChatAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  getDocId(String friendId) async {
    String currentUserId = _auth.currentUser!.uid;
    CollectionReference chats = _firestore.collection('Chats');
    var chatDocId;
    await chats
        .where('users', isEqualTo: {friendId: null, currentUserId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) async {
          if (snapshot.docs.isNotEmpty) {
            chatDocId = snapshot.docs.single.id;
          } else {
            addNewIdInRoom(friendId);
            addFriendNewIdInRoom(friendId);
            await chats.add({
              'users': {currentUserId: null, friendId: null},
            }).then((value) {
              chatDocId = value.id;
            });

          }
        })
        .catchError((e) {
          print(e);
        });

    return chatDocId;
  }
  void addNewIdInRoom(String id)async{
    final collection =await _firestore.collection('Rooms').doc(_auth.currentUser!.uid).get();
    if(collection.exists){
      List friends =await collection.data()!['Friends'];

      friends.add(id);
      await _firestore.collection('Rooms').doc(_auth.currentUser!.uid).set({
        'Friends': friends,
      }).catchError((e) {
        print("EERRoorr>> $e");
      });
    }
    else{
      List friends = [id];
      await _firestore.collection('Rooms').doc(_auth.currentUser!.uid).set({
        'Friends': friends,
      }).catchError((e) {
        print("EERRoorr>> $e");
      });
    }


  }


  void addFriendNewIdInRoom(String friendId)async{
    final collection =await _firestore.collection('Rooms').doc(friendId).get();
    if(collection.exists){
      List friends =await collection.data()!['Friends'];

      friends.add(_auth.currentUser!.uid);
      await _firestore.collection('Rooms').doc(friendId).set({
        'Friends': friends,
      }).catchError((e) {
        print("EERRoorr>> $e");
      });
    }
    else{
      List friends = [_auth.currentUser!.uid];
      await _firestore.collection('Rooms').doc(friendId).set({
        'Friends': friends,
      }).catchError((e) {
        print("EERRoorr>> $e");
      });
    }
  }
}
