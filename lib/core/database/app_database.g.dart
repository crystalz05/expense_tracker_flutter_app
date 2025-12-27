// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ExpenseDao? _expenseDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `expenses` (`id` TEXT NOT NULL, `amount` REAL NOT NULL, `category` TEXT NOT NULL, `description` TEXT, `created_at` INTEGER NOT NULL, `updated_at` INTEGER NOT NULL, `payment_method` TEXT NOT NULL, `is_deleted` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }
}

class _$ExpenseDao extends ExpenseDao {
  _$ExpenseDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _expenseModelInsertionAdapter = InsertionAdapter(
            database,
            'expenses',
            (ExpenseModel item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'description': item.description,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt),
                  'payment_method': item.paymentMethod,
                  'is_deleted': item.isDeleted ? 1 : 0
                }),
        _expenseModelUpdateAdapter = UpdateAdapter(
            database,
            'expenses',
            ['id'],
            (ExpenseModel item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'description': item.description,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt),
                  'payment_method': item.paymentMethod,
                  'is_deleted': item.isDeleted ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ExpenseModel> _expenseModelInsertionAdapter;

  final UpdateAdapter<ExpenseModel> _expenseModelUpdateAdapter;

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    return _queryAdapter.queryList(
        'SELECT * FROM expenses WHERE is_deleted = 0 ORDER BY updated_at DESC',
        mapper: (Map<String, Object?> row) => ExpenseModel(
            id: row['id'] as String,
            amount: row['amount'] as double,
            category: row['category'] as String,
            description: row['description'] as String?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as int),
            paymentMethod: row['payment_method'] as String,
            isDeleted: (row['is_deleted'] as int) != 0));
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM expenses WHERE WHERE is_deleted = 0 AND updated_at BETWEEN ?1 AND ?2 ORDER BY updated_at DESC',
        mapper: (Map<String, Object?> row) => ExpenseModel(id: row['id'] as String, amount: row['amount'] as double, category: row['category'] as String, description: row['description'] as String?, createdAt: _dateTimeConverter.decode(row['created_at'] as int), updatedAt: _dateTimeConverter.decode(row['updated_at'] as int), paymentMethod: row['payment_method'] as String, isDeleted: (row['is_deleted'] as int) != 0),
        arguments: [
          _dateTimeConverter.encode(start),
          _dateTimeConverter.encode(end)
        ]);
  }

  @override
  Future<List<ExpenseModel>> getExpenseByCategory(String category) async {
    return _queryAdapter.queryList(
        'SELECT * FROM expenses WHERE WHERE is_deleted = 0 AND category = ?1 ORDER BY updated_at DESC',
        mapper: (Map<String, Object?> row) => ExpenseModel(id: row['id'] as String, amount: row['amount'] as double, category: row['category'] as String, description: row['description'] as String?, createdAt: _dateTimeConverter.decode(row['created_at'] as int), updatedAt: _dateTimeConverter.decode(row['updated_at'] as int), paymentMethod: row['payment_method'] as String, isDeleted: (row['is_deleted'] as int) != 0),
        arguments: [category]);
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM expenses WHERE id = ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => ExpenseModel(
            id: row['id'] as String,
            amount: row['amount'] as double,
            category: row['category'] as String,
            description: row['description'] as String?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as int),
            paymentMethod: row['payment_method'] as String,
            isDeleted: (row['is_deleted'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM expenses WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> softDeleteExpense(
    String id,
    DateTime updatedAt,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE expenses SET is_deleted = 1, updated_at = ?2 WHERE id = ?1',
        arguments: [id, _dateTimeConverter.encode(updatedAt)]);
  }

  @override
  Future<double?> getTotalByCategory(String category) async {
    return _queryAdapter.query(
        'SELECT SUM(amount) FROM expenses WHERE is_deleted = 0 AND category = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [category]);
  }

  @override
  Future<double?> getTotalExpense() async {
    return _queryAdapter.query(
        'SELECT SUM(amount) FROM expenses WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as double);
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _expenseModelInsertionAdapter.insert(
        expense, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _expenseModelUpdateAdapter.update(expense, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
