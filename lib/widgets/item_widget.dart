import 'package:billapp/models/bill_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ItemWidget extends StatelessWidget {
  BillModel billProduct;
  ItemWidget({
    required this.billProduct,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          Icons.shopping_cart,
        ),
        title: Text(billProduct.product),
        subtitle: Text(billProduct.type),
        trailing: Text("S/ ${billProduct.price}"),
      ),
    );
  }
}
