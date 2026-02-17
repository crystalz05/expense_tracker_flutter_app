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

  BudgetDao? _budgetDaoInstance;

  MonthlyBudgetDao? _monthlyBudgetDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
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
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `budgets` (`id` TEXT NOT NULL, `user_id` TEXT NOT NULL, `category` TEXT NOT NULL, `description` TEXT NOT NULL, `amount` REAL NOT NULL, `start_date` INTEGER NOT NULL, `end_date` INTEGER NOT NULL, `period` TEXT NOT NULL, `is_recurring` INTEGER NOT NULL, `alert_threshold` REAL, `created_at` INTEGER NOT NULL, `updated_at` INTEGER, `is_deleted` INTEGER NOT NULL, `needs_sync` INTEGER NOT NULL, `last_synced_at` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `monthly_budgets` (`id` TEXT NOT NULL, `user_id` TEXT NOT NULL, `month` INTEGER NOT NULL, `year` INTEGER NOT NULL, `amount` REAL NOT NULL, `created_at` INTEGER NOT NULL, `updated_at` INTEGER, `is_deleted` INTEGER NOT NULL, `needs_sync` INTEGER NOT NULL, `last_synced_at` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExpenseDao get expenseDao {
    return _expenseDaoInstance ??= _$ExpenseDao(database, changeListener);
  }

  @override
  BudgetDao get budgetDao {
    return _budgetDaoInstance ??= _$BudgetDao(database, changeListener);
  }

  @override
  MonthlyBudgetDao get monthlyBudgetDao {
    return _monthlyBudgetDaoInstance ??=
        _$MonthlyBudgetDao(database, changeListener);
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
        'SELECT * FROM expenses WHERE is_deleted = 0 AND updated_at BETWEEN ?1 AND ?2 ORDER BY updated_at DESC',
        mapper: (Map<String, Object?> row) => ExpenseModel(id: row['id'] as String, amount: row['amount'] as double, category: row['category'] as String, description: row['description'] as String?, createdAt: _dateTimeConverter.decode(row['created_at'] as int), updatedAt: _dateTimeConverter.decode(row['updated_at'] as int), paymentMethod: row['payment_method'] as String, isDeleted: (row['is_deleted'] as int) != 0),
        arguments: [
          _dateTimeConverter.encode(start),
          _dateTimeConverter.encode(end)
        ]);
  }

  @override
  Future<List<ExpenseModel>> getExpensesByCategoryAndPeriod(
    String category,
    DateTime start,
    DateTime end,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM expenses WHERE is_deleted = 0 AND category = ?1 AND updated_at BETWEEN ?2 AND ?3 ORDER BY updated_at DESC',
        mapper: (Map<String, Object?> row) => ExpenseModel(id: row['id'] as String, amount: row['amount'] as double, category: row['category'] as String, description: row['description'] as String?, createdAt: _dateTimeConverter.decode(row['created_at'] as int), updatedAt: _dateTimeConverter.decode(row['updated_at'] as int), paymentMethod: row['payment_method'] as String, isDeleted: (row['is_deleted'] as int) != 0),
        arguments: [
          category,
          _dateTimeConverter.encode(start),
          _dateTimeConverter.encode(end)
        ]);
  }

  @override
  Future<List<ExpenseModel>> getExpenseByCategory(String category) async {
    return _queryAdapter.queryList(
        'SELECT * FROM expenses WHERE is_deleted = 0 AND category = ?1 ORDER BY updated_at DESC',
        mapper: (Map<String, Object?> row) => ExpenseModel(id: row['id'] as String, amount: row['amount'] as double, category: row['category'] as String, description: row['description'] as String?, createdAt: _dateTimeConverter.decode(row['created_at'] as int), updatedAt: _dateTimeConverter.decode(row['updated_at'] as int), paymentMethod: row['payment_method'] as String, isDeleted: (row['is_deleted'] as int) != 0),
        arguments: [category]);
  }

  @override
  Future<double?> getTotalByCategory(String category) async {
    return _queryAdapter.query(
        'SELECT SUM(amount) FROM expenses WHERE is_deleted = 0 AND category = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
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
  Future<double?> getTotalExpense() async {
    return _queryAdapter.query(
        'SELECT SUM(amount) FROM expenses WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as double);
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
  Future<List<ExpenseModel>> getAllExpensesIncludingDeleted() async {
    return _queryAdapter.queryList(
        'SELECT * FROM expenses ORDER BY updated_at DESC',
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
  Future<void> purgeSoftDeleted() async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM expenses WHERE is_deleted = 1');
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

class _$BudgetDao extends BudgetDao {
  _$BudgetDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _budgetModelInsertionAdapter = InsertionAdapter(
            database,
            'budgets',
            (BudgetModel item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'category': item.category,
                  'description': item.description,
                  'amount': item.amount,
                  'start_date': _dateTimeConverter.encode(item.startDate),
                  'end_date': _dateTimeConverter.encode(item.endDate),
                  'period': item.period,
                  'is_recurring': item.isRecurring ? 1 : 0,
                  'alert_threshold': item.alertThreshold,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at':
                      _nullableDateTimeConverter.encode(item.updatedAt),
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'needs_sync': item.needsSync ? 1 : 0,
                  'last_synced_at':
                      _nullableDateTimeConverter.encode(item.lastSyncedAt)
                }),
        _budgetModelUpdateAdapter = UpdateAdapter(
            database,
            'budgets',
            ['id'],
            (BudgetModel item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'category': item.category,
                  'description': item.description,
                  'amount': item.amount,
                  'start_date': _dateTimeConverter.encode(item.startDate),
                  'end_date': _dateTimeConverter.encode(item.endDate),
                  'period': item.period,
                  'is_recurring': item.isRecurring ? 1 : 0,
                  'alert_threshold': item.alertThreshold,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at':
                      _nullableDateTimeConverter.encode(item.updatedAt),
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'needs_sync': item.needsSync ? 1 : 0,
                  'last_synced_at':
                      _nullableDateTimeConverter.encode(item.lastSyncedAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BudgetModel> _budgetModelInsertionAdapter;

  final UpdateAdapter<BudgetModel> _budgetModelUpdateAdapter;

  @override
  Future<List<BudgetModel>> getAllBudgets(String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM budgets WHERE is_deleted = 0 AND user_id = ?1',
        mapper: (Map<String, Object?> row) => BudgetModel(
            id: row['id'] as String,
            userId: row['user_id'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            amount: row['amount'] as double,
            startDate: _dateTimeConverter.decode(row['start_date'] as int),
            endDate: _dateTimeConverter.decode(row['end_date'] as int),
            period: row['period'] as String,
            isRecurring: (row['is_recurring'] as int) != 0,
            alertThreshold: row['alert_threshold'] as double?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt:
                _nullableDateTimeConverter.decode(row['updated_at'] as int?),
            isDeleted: (row['is_deleted'] as int) != 0,
            needsSync: (row['needs_sync'] as int) != 0,
            lastSyncedAt: _nullableDateTimeConverter
                .decode(row['last_synced_at'] as int?)),
        arguments: [userId]);
  }

  @override
  Future<BudgetModel?> getBudgetById(String id) async {
    return _queryAdapter.query('SELECT * FROM budgets WHERE id = ?1',
        mapper: (Map<String, Object?> row) => BudgetModel(
            id: row['id'] as String,
            userId: row['user_id'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            amount: row['amount'] as double,
            startDate: _dateTimeConverter.decode(row['start_date'] as int),
            endDate: _dateTimeConverter.decode(row['end_date'] as int),
            period: row['period'] as String,
            isRecurring: (row['is_recurring'] as int) != 0,
            alertThreshold: row['alert_threshold'] as double?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt:
                _nullableDateTimeConverter.decode(row['updated_at'] as int?),
            isDeleted: (row['is_deleted'] as int) != 0,
            needsSync: (row['needs_sync'] as int) != 0,
            lastSyncedAt: _nullableDateTimeConverter
                .decode(row['last_synced_at'] as int?)),
        arguments: [id]);
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM budgets WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<List<BudgetModel>> getBudgetsNeedingSync(String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM budgets WHERE needs_sync = 1 AND user_id = ?1',
        mapper: (Map<String, Object?> row) => BudgetModel(
            id: row['id'] as String,
            userId: row['user_id'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            amount: row['amount'] as double,
            startDate: _dateTimeConverter.decode(row['start_date'] as int),
            endDate: _dateTimeConverter.decode(row['end_date'] as int),
            period: row['period'] as String,
            isRecurring: (row['is_recurring'] as int) != 0,
            alertThreshold: row['alert_threshold'] as double?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt:
                _nullableDateTimeConverter.decode(row['updated_at'] as int?),
            isDeleted: (row['is_deleted'] as int) != 0,
            needsSync: (row['needs_sync'] as int) != 0,
            lastSyncedAt: _nullableDateTimeConverter
                .decode(row['last_synced_at'] as int?)),
        arguments: [userId]);
  }

  @override
  Future<List<BudgetModel>> getDeletedBudgets(String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM budgets WHERE is_deleted = 1 AND user_id = ?1',
        mapper: (Map<String, Object?> row) => BudgetModel(
            id: row['id'] as String,
            userId: row['user_id'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            amount: row['amount'] as double,
            startDate: _dateTimeConverter.decode(row['start_date'] as int),
            endDate: _dateTimeConverter.decode(row['end_date'] as int),
            period: row['period'] as String,
            isRecurring: (row['is_recurring'] as int) != 0,
            alertThreshold: row['alert_threshold'] as double?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt:
                _nullableDateTimeConverter.decode(row['updated_at'] as int?),
            isDeleted: (row['is_deleted'] as int) != 0,
            needsSync: (row['needs_sync'] as int) != 0,
            lastSyncedAt: _nullableDateTimeConverter
                .decode(row['last_synced_at'] as int?)),
        arguments: [userId]);
  }

  @override
  Future<void> permanentlyDeleteBudgets(List<String> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM budgets WHERE is_deleted = 1 AND id IN (' +
            _sqliteVariablesForIds +
            ')',
        arguments: [...ids]);
  }

  @override
  Future<void> markAsSynced(
    String id,
    DateTime syncTime,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE budgets SET needs_sync = 0, last_synced_at = ?2 WHERE id = ?1',
        arguments: [id, _dateTimeConverter.encode(syncTime)]);
  }

  @override
  Future<List<BudgetModel>> getBudgetsModifiedAfter(
    String userId,
    DateTime timestamp,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM budgets WHERE user_id = ?1 AND (updated_at > ?2 OR (updated_at IS NULL AND created_at > ?2))',
        mapper: (Map<String, Object?> row) => BudgetModel(id: row['id'] as String, userId: row['user_id'] as String, category: row['category'] as String, description: row['description'] as String, amount: row['amount'] as double, startDate: _dateTimeConverter.decode(row['start_date'] as int), endDate: _dateTimeConverter.decode(row['end_date'] as int), period: row['period'] as String, isRecurring: (row['is_recurring'] as int) != 0, alertThreshold: row['alert_threshold'] as double?, createdAt: _dateTimeConverter.decode(row['created_at'] as int), updatedAt: _nullableDateTimeConverter.decode(row['updated_at'] as int?), isDeleted: (row['is_deleted'] as int) != 0, needsSync: (row['needs_sync'] as int) != 0, lastSyncedAt: _nullableDateTimeConverter.decode(row['last_synced_at'] as int?)),
        arguments: [userId, _dateTimeConverter.encode(timestamp)]);
  }

  @override
  Future<void> cleanupOldDeletedBudgets(DateTime cutoffTime) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM budgets WHERE is_deleted = 1 AND updated_at < ?1',
        arguments: [_dateTimeConverter.encode(cutoffTime)]);
  }

  @override
  Future<void> clearUserData(String userId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM budgets WHERE user_id = ?1',
        arguments: [userId]);
  }

  @override
  Future<void> insertBudget(BudgetModel budget) async {
    await _budgetModelInsertionAdapter.insert(budget, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertBudgets(List<BudgetModel> budgets) async {
    await _budgetModelInsertionAdapter.insertList(
        budgets, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    await _budgetModelUpdateAdapter.update(budget, OnConflictStrategy.abort);
  }
}

class _$MonthlyBudgetDao extends MonthlyBudgetDao {
  _$MonthlyBudgetDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _monthlyBudgetModelInsertionAdapter = InsertionAdapter(
            database,
            'monthly_budgets',
            (MonthlyBudgetModel item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'month': item.month,
                  'year': item.year,
                  'amount': item.amount,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at':
                      _nullableDateTimeConverter.encode(item.updatedAt),
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'needs_sync': item.needsSync ? 1 : 0,
                  'last_synced_at':
                      _nullableDateTimeConverter.encode(item.lastSyncedAt)
                }),
        _monthlyBudgetModelUpdateAdapter = UpdateAdapter(
            database,
            'monthly_budgets',
            ['id'],
            (MonthlyBudgetModel item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'month': item.month,
                  'year': item.year,
                  'amount': item.amount,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at':
                      _nullableDateTimeConverter.encode(item.updatedAt),
                  'is_deleted': item.isDeleted ? 1 : 0,
                  'needs_sync': item.needsSync ? 1 : 0,
                  'last_synced_at':
                      _nullableDateTimeConverter.encode(item.lastSyncedAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MonthlyBudgetModel>
      _monthlyBudgetModelInsertionAdapter;

  final UpdateAdapter<MonthlyBudgetModel> _monthlyBudgetModelUpdateAdapter;

  @override
  Future<List<MonthlyBudgetModel>> getAllMonthlyBudgets(String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM monthly_budgets WHERE is_deleted = 0 AND user_id = ?1 ORDER BY year DESC, month DESC',
        mapper: (Map<String, Object?> row) => MonthlyBudgetModel(id: row['id'] as String, userId: row['user_id'] as String, month: row['month'] as int, year: row['year'] as int, amount: row['amount'] as double, createdAt: _dateTimeConverter.decode(row['created_at'] as int), updatedAt: _nullableDateTimeConverter.decode(row['updated_at'] as int?), isDeleted: (row['is_deleted'] as int) != 0, needsSync: (row['needs_sync'] as int) != 0, lastSyncedAt: _nullableDateTimeConverter.decode(row['last_synced_at'] as int?)),
        arguments: [userId]);
  }

  @override
  Future<MonthlyBudgetModel?> getMonthlyBudgetById(String id) async {
    return _queryAdapter.query('SELECT * FROM monthly_budgets WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MonthlyBudgetModel(
            id: row['id'] as String,
            userId: row['user_id'] as String,
            month: row['month'] as int,
            year: row['year'] as int,
            amount: row['amount'] as double,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt:
                _nullableDateTimeConverter.decode(row['updated_at'] as int?),
            isDeleted: (row['is_deleted'] as int) != 0,
            needsSync: (row['needs_sync'] as int) != 0,
            lastSyncedAt: _nullableDateTimeConverter
                .decode(row['last_synced_at'] as int?)),
        arguments: [id]);
  }

  @override
  Future<MonthlyBudgetModel?> getMonthlyBudgetByMonthYear(
    String userId,
    int month,
    int year,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM monthly_budgets WHERE user_id = ?1 AND month = ?2 AND year = ?3 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => MonthlyBudgetModel(id: row['id'] as String, userId: row['user_id'] as String, month: row['month'] as int, year: row['year'] as int, amount: row['amount'] as double, createdAt: _dateTimeConverter.decode(row['created_at'] as int), updatedAt: _nullableDateTimeConverter.decode(row['updated_at'] as int?), isDeleted: (row['is_deleted'] as int) != 0, needsSync: (row['needs_sync'] as int) != 0, lastSyncedAt: _nullableDateTimeConverter.decode(row['last_synced_at'] as int?)),
        arguments: [userId, month, year]);
  }

  @override
  Future<List<MonthlyBudgetModel>> getMonthlyBudgetsByYear(
    String userId,
    int year,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM monthly_budgets WHERE user_id = ?1 AND year = ?2 AND is_deleted = 0 ORDER BY month ASC',
        mapper: (Map<String, Object?> row) => MonthlyBudgetModel(id: row['id'] as String, userId: row['user_id'] as String, month: row['month'] as int, year: row['year'] as int, amount: row['amount'] as double, createdAt: _dateTimeConverter.decode(row['created_at'] as int), updatedAt: _nullableDateTimeConverter.decode(row['updated_at'] as int?), isDeleted: (row['is_deleted'] as int) != 0, needsSync: (row['needs_sync'] as int) != 0, lastSyncedAt: _nullableDateTimeConverter.decode(row['last_synced_at'] as int?)),
        arguments: [userId, year]);
  }

  @override
  Future<void> deleteMonthlyBudget(String id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM monthly_budgets WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<MonthlyBudgetModel>> getMonthlyBudgetsNeedingSync(
      String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM monthly_budgets WHERE needs_sync = 1 AND user_id = ?1',
        mapper: (Map<String, Object?> row) => MonthlyBudgetModel(
            id: row['id'] as String,
            userId: row['user_id'] as String,
            month: row['month'] as int,
            year: row['year'] as int,
            amount: row['amount'] as double,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt:
                _nullableDateTimeConverter.decode(row['updated_at'] as int?),
            isDeleted: (row['is_deleted'] as int) != 0,
            needsSync: (row['needs_sync'] as int) != 0,
            lastSyncedAt: _nullableDateTimeConverter
                .decode(row['last_synced_at'] as int?)),
        arguments: [userId]);
  }

  @override
  Future<List<MonthlyBudgetModel>> getDeletedMonthlyBudgets(
      String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM monthly_budgets WHERE is_deleted = 1 AND user_id = ?1',
        mapper: (Map<String, Object?> row) => MonthlyBudgetModel(
            id: row['id'] as String,
            userId: row['user_id'] as String,
            month: row['month'] as int,
            year: row['year'] as int,
            amount: row['amount'] as double,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt:
                _nullableDateTimeConverter.decode(row['updated_at'] as int?),
            isDeleted: (row['is_deleted'] as int) != 0,
            needsSync: (row['needs_sync'] as int) != 0,
            lastSyncedAt: _nullableDateTimeConverter
                .decode(row['last_synced_at'] as int?)),
        arguments: [userId]);
  }

  @override
  Future<void> permanentlyDeleteMonthlyBudgets(List<String> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM monthly_budgets WHERE is_deleted = 1 AND id IN (' +
            _sqliteVariablesForIds +
            ')',
        arguments: [...ids]);
  }

  @override
  Future<void> markAsSynced(
    String id,
    DateTime syncTime,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE monthly_budgets SET needs_sync = 0, last_synced_at = ?2 WHERE id = ?1',
        arguments: [id, _dateTimeConverter.encode(syncTime)]);
  }

  @override
  Future<void> clearUserData(String userId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM monthly_budgets WHERE user_id = ?1',
        arguments: [userId]);
  }

  @override
  Future<void> insertMonthlyBudget(MonthlyBudgetModel monthlyBudget) async {
    await _monthlyBudgetModelInsertionAdapter.insert(
        monthlyBudget, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertMonthlyBudgets(List<MonthlyBudgetModel> budgets) async {
    await _monthlyBudgetModelInsertionAdapter.insertList(
        budgets, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateMonthlyBudget(MonthlyBudgetModel monthlyBudget) async {
    await _monthlyBudgetModelUpdateAdapter.update(
        monthlyBudget, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _nullableDateTimeConverter = NullableDateTimeConverter();
