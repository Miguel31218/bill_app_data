import 'package:billapp/db/db_admin.dart';
import 'package:billapp/models/bill_model.dart';
import 'package:billapp/pages/modals/register_modal.dart';
import 'package:billapp/widgets/item_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> gastosList = [];
  List<BillModel> gastosBill = [];

  get bill => bill;

  showRegisterModal(BillModel? bill) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // height: 200,
          // color: Colors.white,
          child: RegisterModal(
            bill: bill,
          ),
        );
      },
    ).then((value) {
      getDataGeneralBillModel();
    });
  }

  Future<void> getDataGeneral() async {
    gastosList = await DBAdmin().obtenerGastos();
    print(gastosList);
    setState(() {});
  }

  Future<void> getDataGeneralBillModel() async {
    gastosBill = await DBAdmin().getBills();
    print(gastosBill);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getDataGeneral();
    getDataGeneralBillModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  showRegisterModal(null);
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Agregar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(34),
                      bottomRight: Radius.circular(34),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Resumen de gastos",
                            style: TextStyle(
                              // color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text("Gestiona tus gastos de la mejor forma"),
                          Divider(
                            height: 24,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: gastosBill.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Dismissible(
                                  key: Key(index.toString()),
                                  child: ItemWidget(
                                    billProduct: gastosBill[index],
                                  ),
                                  background: Container(
                                      padding: EdgeInsets.only(left: 20.0),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.delete),
                                      )),
                                  secondaryBackground: Container(
                                      padding: EdgeInsets.only(right: 20.0),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.edit),
                                      )),
                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      print("Se elimina elemento");
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: Text("Confirmación"),
                                              content: Text(
                                                  "¿Desea Eliminar el elemento?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    DBAdmin()
                                                        .delBill(
                                                            gastosBill[index]
                                                                .id!)
                                                        .then((value) {
                                                      getDataGeneralBillModel();
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Si"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("No"),
                                                ),
                                              ]);
                                        },
                                      );
                                      return false;
                                    } else {
                                      showRegisterModal(gastosBill[index]);
                                      return false;
                                    }
                                  },
                                );
                                // GestureDetector(
                                //   onTap: () {
                                //     // eliminar gasto

                                //     // DBAdmin()
                                //     //     .delBill(gastosBill[index].id!)
                                //     //     .then((value) {
                                //     //   getDataGeneralBillModel();
                                //     // });

                                //     // actualizar gasto
                                //     BillModel bill = BillModel(
                                //         id: gastosBill[index].id,
                                //         product: "actualizado",
                                //         price: 99.99,
                                //         type: "lt");
                                //     DBAdmin()
                                //         .updBill(bill)
                                //         .then((value) {
                                //       getDataGeneralBillModel();
                                //     });
                                //   },
                                //   child: ItemWidget(
                                //     billProduct: gastosBill[index],
                                //     /*product: gastosList[index]["product"],
                                //     type: gastosList[index]["type"],
                                //     price: double.parse(
                                //         gastosList[index]["price"].toString()),*/
                                //   ),
                                // );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              )
            ],
          ),
        ],
      ),
    );
  }
}
