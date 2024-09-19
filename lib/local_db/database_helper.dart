import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'MortgageCalculator.db';
  static const _databaseVersion = 2; // Increment the version number
  static const mortgageLoanTable = 'MORTGAGE_LOAN_TABLE';

  static getDB() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Ole version: $oldVersion, New version: $newVersion}');
    if (oldVersion < 2) {
      // Add new column 'startedAt' if the database version is less than 2
      await db.execute('''
        ALTER TABLE $mortgageLoanTable
        ADD COLUMN startedAt INTEGER
      ''');
    }
  }

  static Future _onCreate(Database db, int version) async {
    await createChatBotsTable(db);
  }

  static const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

  static Future createChatBotsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $mortgageLoanTable (
        id $idType,
        createdAt INTEGER,
        updatedAt INTEGER,
        title TEXT NOT NULL,
        homePrice REAL NOT NULL,
        propertyTax REAL NOT NULL,
        downPayment REAL NOT NULL,
        pmi REAL NOT NULL,
        loanTerm INTEGER NOT NULL,
        homeOwnerInsurance REAL NOT NULL,
        interestRate REAL NOT NULL,
        hoaFees REAL NOT NULL,
        monthlyMortgage REAL
      )
    ''');
  }
}
