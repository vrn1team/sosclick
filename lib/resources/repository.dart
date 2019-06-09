import 'dart:async';
import 'users_api_provider.dart';
import 'users_db_provider.dart';
import '../models/user.dart';
import '../models/currentuser.dart';

class Repository {
  List<Source> sources = <Source>[
    usersDbProvider,
    UsersApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    usersDbProvider,
  ];

  Future<CurrentUser> fetchCurrentUserFromCache(String hash) async {
    CurrentUser user;
    for (var cache in caches) {
      user = await cache.fetchCurrentUser(hash);
      if (user != null) {
        break;
      }
    }
    return user;
  }

  Future<User> fetchUser(int id) async {
    User user;
    var source;

    for (source in sources) {
      user = await source.fetchUser(id);
      if (user != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) {
        cache.addUser(user);
      }
    }
    return user;
  }

  clearCache() async {
    for (var cache in caches) {
      await cache.clearUsers();
      await cache.clearCurrentUsers();
    }
  }
}

abstract class Source {
  Future<CurrentUser> fetchCurrentUser(String hash);

  Future<User> fetchUser(int id);

  Future<int> addCurrentUser(CurrentUser currentuser);

  Future<int> addUser(User user);
}

abstract class Cache {
  Future<CurrentUser> fetchCurrentUser(String hash);
  Future<int> addUser(User user);
  Future<int> addCurrentUser(CurrentUser currentuser);
  Future<int> clearUsers();
  Future<int> clearCurrentUsers();
}
