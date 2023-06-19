// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
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

  PersonDao? _personDaoInstance;

  FavoriteDao? _favoriteDaoInstance;

  PersonFavoriteDao? _personFavoriteDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
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
            'CREATE TABLE IF NOT EXISTS `Person` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Favorite` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, `city` TEXT NOT NULL, `lat` REAL NOT NULL, `lng` REAL NOT NULL, `address` TEXT, `type` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PersonFavorite` (`personId` INTEGER NOT NULL, `favoriteId` TEXT NOT NULL, FOREIGN KEY (`personId`) REFERENCES `Person` (`id`) ON UPDATE CASCADE ON DELETE CASCADE, FOREIGN KEY (`favoriteId`) REFERENCES `Favorite` (`id`) ON UPDATE CASCADE ON DELETE CASCADE, PRIMARY KEY (`personId`, `favoriteId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PersonDao get personDao {
    return _personDaoInstance ??= _$PersonDao(database, changeListener);
  }

  @override
  FavoriteDao get favoriteDao {
    return _favoriteDaoInstance ??= _$FavoriteDao(database, changeListener);
  }

  @override
  PersonFavoriteDao get personFavoriteDao {
    return _personFavoriteDaoInstance ??=
        _$PersonFavoriteDao(database, changeListener);
  }
}

class _$PersonDao extends PersonDao {
  _$PersonDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _personInsertionAdapter = InsertionAdapter(
            database,
            'Person',
            (Person item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Person> _personInsertionAdapter;

  @override
  Future<Person?> findPersonById(int id) async {
    return _queryAdapter.query('SELECT * FROM Person WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Person(row['id'] as int, row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertPerson(Person person) async {
    await _personInsertionAdapter.insert(person, OnConflictStrategy.abort);
  }
}

class _$FavoriteDao extends FavoriteDao {
  _$FavoriteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _favoriteInsertionAdapter = InsertionAdapter(
            database,
            'Favorite',
            (Favorite item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'city': item.city,
                  'lat': item.lat,
                  'lng': item.lng,
                  'address': item.address,
                  'type': item.type
                }),
        _favoriteDeletionAdapter = DeletionAdapter(
            database,
            'Favorite',
            ['id'],
            (Favorite item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'city': item.city,
                  'lat': item.lat,
                  'lng': item.lng,
                  'address': item.address,
                  'type': item.type
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Favorite> _favoriteInsertionAdapter;

  final DeletionAdapter<Favorite> _favoriteDeletionAdapter;

  @override
  Future<Favorite?> findFavoriteByName(String name) async {
    return _queryAdapter.query('SELECT * FROM Favorite WHERE name = ?1',
        mapper: (Map<String, Object?> row) => Favorite(
            row['id'] as String,
            row['name'] as String,
            row['city'] as String,
            row['lat'] as double,
            row['lng'] as double,
            row['address'] as String?,
            row['type'] as String),
        arguments: [name]);
  }

  @override
  Future<void> insertFavorite(Favorite favorite) async {
    await _favoriteInsertionAdapter.insert(favorite, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFavorite(Favorite favorite) async {
    await _favoriteDeletionAdapter.delete(favorite);
  }
}

class _$PersonFavoriteDao extends PersonFavoriteDao {
  _$PersonFavoriteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _personFavoriteInsertionAdapter = InsertionAdapter(
            database,
            'PersonFavorite',
            (PersonFavorite item) => <String, Object?>{
                  'personId': item.personId,
                  'favoriteId': item.favoriteId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PersonFavorite> _personFavoriteInsertionAdapter;

  @override
  Future<List<Favorite>> findFavoritesByPersonId(int id) async {
    return _queryAdapter.queryList(
        'SELECT Favorite.*     FROM PersonFavorite     INNER JOIN Favorite ON Favorite.id = PersonFavorite.favoriteId     WHERE personId = ?1',
        mapper: (Map<String, Object?> row) => Favorite(row['id'] as String, row['name'] as String, row['city'] as String, row['lat'] as double, row['lng'] as double, row['address'] as String?, row['type'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertPersonFavorite(PersonFavorite personFavorite) async {
    await _personFavoriteInsertionAdapter.insert(
        personFavorite, OnConflictStrategy.abort);
  }
}
