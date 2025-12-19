import 'package:floor/floor.dart';

final migration1to2 = Migration(1, 2, (database) async {
  await database.execute(
      'ALTER TABLE expenses ADD COLUMN is_deleted INTEGER NOT NULL DEFAULT 0'
  );

  await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_expenses_updated_at ON expenses(updated_at)'
  );

  await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_expenses_is_deleted ON expenses(is_deleted)'
  );
});