import 'dart:io';

import 'package:billapp/models/bill_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBAdmin {
  Database? _myDataBase;

  //PATRÓN SINGLETON
  static final DBAdmin _instance = DBAdmin._();
  DBAdmin._();
  factory DBAdmin() {
    return _instance;
  }

  Future<Database?> _checkDataBase() async {
    //TERCERA FORMA
    if (_myDataBase == null) {
      print("LA BD ES NULA");
      _myDataBase = await _initDatabase();
    }
    print("LA BD YA EXISTE");
    return _myDataBase;

    // //PRIMERA FORMA
    // //No ha sido creada
    // if (myDataBase == null) {
    //   myDataBase = await initDatabase();
    // }
    // //Si ha sido creada
    // else {
    //   return myDataBase;
    // }
    // return myDataBase;

    //SEGUNDA FORMA
    // myDataBase ??= await initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String pathDatabase = join(directory.path, "BillsDB.db");
    print(pathDatabase);
    return await openDatabase(
      pathDatabase,
      version: 1,
      onCreate: (Database db, int version) {
        db.execute("""CREATE TABLE BILL(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  product TEXT,
                  price INT,
                  datetime TEXT,
                  type TEXT,
                  monto REAL,
                  cantidad REAL
               )""");
      },
    );
  }

  //CRUD
  //OBTENER GASTOS
  Future<List<Map>> obtenerGastos() async {
    Database? db = await _checkDataBase();

    //OBTENER TODA LA BD POR FUNCIÓN
    List<Map<String, dynamic>> data = await db!.query(
      'BILL',
      columns: [
        "id",
        "product",
        "price",
        "type",
      ],
    );
    print(data);

    return data;

    //OBTENER DATA Y FILTRAR POR FUNCION
    // List data = await db!.query(
    //   "BILL",
    //   columns: [
    //     "id",
    //     "product",
    //     "price",
    //     "type",
    //   ],
    //   where: "type='Kg.'",
    // );

    //OBTENER DATA Y FILTRAR POR SENTENCIA SQL
    // List data = await db!
    //     .rawQuery("SELECT id, product, price, type FROM BILL WHERE type='Kg.'");
  }

  Future<List<BillModel>> getBills() async {
    Database? db = await _checkDataBase();
    List<Map<String, dynamic>> data = await db!.query(
      'BILL',
      columns: [
        "id",
        "product",
        "price",
        "type",
      ],
    );
    List<BillModel> bills = data.map((e) => BillModel.fromJson(e)).toList();
    return bills;
  }

  //INSERTAR GASTO
  Future<int> insertarGasto(BillModel data) async {
    Database? db = await _checkDataBase();
    int res = await db!.insert(
      "BILL",
      data.toJson(),
      // {
      //   "product": data.product,
      //   "type": data.type,
      //   "price": data.price,
      // },
    );
    print(res);
    return res;
  }

  //ACTUALIZAR GASTO
  Future<void> updBill(BillModel bill) async {
    Database? db = await _checkDataBase();
    await db!.update(
        "BILL",
        {
          "product": bill.product,
          "price": bill.price.toString(),
          "type": bill.type,
        },
        where: "id = ${bill.id}");
  }

  //ELIMINAR GASTO
  Future<void> delBill(int id) async {
    Database? db = await _checkDataBase();
    await db!
        .delete(
      'BILL',
      where: 'id = $id',
    )
        .then((value) {
      print("------------------------");
      print(value);
    });
  }
}
