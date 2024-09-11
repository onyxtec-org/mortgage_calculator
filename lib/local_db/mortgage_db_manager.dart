import 'package:mortgage_calculator/local_db/database_helper.dart';
import 'package:mortgage_calculator/models/mortgage_loan_model.dart';
import 'package:sqflite/sqflite.dart';

class MortgageDbManager {
  static Future<int> insertMortgage(MortgageLoanModel mortgageLoanModel) async {
    final db = await DatabaseHelper.getDB();
    return db.insert(
      DatabaseHelper.mortgageLoanTable,
      mortgageLoanModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<MortgageLoanModel>> fetchMortgage() async {
    final db = await DatabaseHelper.getDB();
    final List<Map<String, dynamic>> maps = await db.query(
    DatabaseHelper.mortgageLoanTable,
      orderBy: "createdAt DESC",
    );
    var list = List.generate(maps.length,(index)=>MortgageLoanModel.fromJson(maps[index]));
    return list;
  }

  static Future<int> updateMortgage(MortgageLoanModel mortgage) async {
    final db = await DatabaseHelper.getDB();
    return await db.update(
      DatabaseHelper.mortgageLoanTable,
      mortgage.toJson(),
      where: 'id =?',
      whereArgs: [mortgage.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deleteMortgage(MortgageLoanModel mortgage) async {
    final db = await DatabaseHelper.getDB();
    return await db.delete(
      DatabaseHelper.mortgageLoanTable,
      where: 'id =?',
      whereArgs: [mortgage.id],
    );
  }

  static Future<int> deleteAllMortgage() async {
    final db = await DatabaseHelper.getDB();
    return await db.delete(DatabaseHelper.mortgageLoanTable);
  }
}
