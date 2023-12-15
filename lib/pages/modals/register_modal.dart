import 'package:billapp/db/db_admin.dart';
import 'package:billapp/models/bill_model.dart';
import 'package:billapp/widgets/textfield_normal_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RegisterModal extends StatefulWidget {
  BillModel? bill;

  RegisterModal({this.bill});

  @override
  State<RegisterModal> createState() => _RegisterModalState(bill: bill);
}

class _RegisterModalState extends State<RegisterModal> {
  BillModel? bill;
  _RegisterModalState({this.bill});
  Map<String?, String> listType = {"lt": "Lt.", "kg": "Kg.", "lata": "Lata"};

  TextEditingController _productController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _typeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (bill != null) {
      _productController.text = bill!.product;
      _priceController.text = bill!.price.toString();
      _typeController.text = bill!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34.0),
          topRight: Radius.circular(34.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text((bill == null ? "Registra" : "Actualiza") + " el gasto"),
          SizedBox(
            height: 16,
          ),
          TextFieldNormalWidget(
              hintText: "Ingresa el título", controller: _productController),
          SizedBox(
            height: 16,
          ),
          TextFieldNormalWidget(
            hintText: "Ingresa el monto",
            controller: _priceController,
            isNumber: true,
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.19),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Seleccione el tipo"),
                SizedBox(
                  width: 8,
                ),
                DropdownButton(
                  hint: Text(_typeController.text == ""
                      ? "Seleccione"
                      : listType[_typeController.text]!),
                  items: [
                    DropdownMenuItem(
                      value: "kg",
                      child: Text(listType["kg"]!),
                    ),
                    DropdownMenuItem(
                      value: "lt",
                      child: Text(listType["lt"]!),
                    ),
                    DropdownMenuItem(
                      value: "lata",
                      child: Text(listType["lata"]!),
                    ),
                  ],
                  onChanged: (seleccionActual) {
                    _typeController.text = seleccionActual!;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // sin patron singleton
                //DBAdmin dbAdmin = DBAdmin();
                //dbAdmin.checkDatabase();
                //dbAdmin.insertarGasto();
                //dbAdmin.obtenerGastos();
                //DBAdmin().insertarGasto("Arroz",2.5,"Kg.");

                // Map<String, dynamic> value = {
                //   "product": _productController.text,
                //   "type": _typeController.text,
                //   "price": double.parse(_priceController.text),
                // };

                // DBAdmin().insertarGasto(value);
                if (_productController.text.isNotEmpty &&
                    _typeController.text.isNotEmpty &&
                    _priceController.text.isNotEmpty) {
                  BillModel model = BillModel(
                    product: _productController.text,
                    price: double.parse(_priceController.text),
                    type: _typeController.text,
                  );
                  if (bill == null) {
                    DBAdmin().insertarGasto(model).then((value) {
                      if (value > 0) {
                        // se ha insertado correctamente
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content:
                                Text("Se realizó el registro correctamente"),
                          ),
                        );
                        Navigator.pop(context);
                      } else {}
                    }).catchError((error) {
                      print(error);
                    });
                  } else {
                    BillModel billUpdate = BillModel(
                      id: bill!.id,
                      product: _productController.text,
                      price: double.parse(_priceController.text),
                      type: _typeController.text,
                    );
                    DBAdmin().updBill(billUpdate).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          content:
                              Text("Se realizó la actualización correctamente"),
                        ),
                      );
                      Navigator.pop(context);
                    });
                  }
                }
              },
              child: Text(
                (bill == null ? "Agregar" : "Actualizar"),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff101321),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
