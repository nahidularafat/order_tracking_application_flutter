import 'package:car_track/model/my_order.dart' show MyOrder;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//import '../model/my_order.dart';

class OrderListController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  List<MyOrder> orders = [];

  @override
  void onInit() {
    orderCollection = firestore.collection('orders'); 
    getAllOrder();
    super.onInit();
  }

 
  getAllOrder() async {
    try {
      QuerySnapshot querySnapshot = await orderCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        MyOrder order = MyOrder.fromJson(data);
        orders.add(order);
      }
      update();
    } catch (e) {
      rethrow;
    }
  }
}
