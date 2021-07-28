import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:race_magic/model/entity/race_entity.dart';
import 'package:race_magic/model/entity/result_entity.dart';

class Repository {
  Repository();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference<Map<String, dynamic>> _races =
      _firestore.collection('races');
  static final CollectionReference<Map<String, dynamic>> _results =
      _firestore.collection('results');

  static Stream<List<RaceEntity>> getRaces() {
    return _races.snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        final Map<String, dynamic> json = document.data();
        json['id'] = document.id;
        return RaceEntity.fromJson(json);
      }).toList();
    });
  }

  static Future<DocumentReference> addRace(RaceEntity raceEntity) {
    final Map<String, dynamic> json = raceEntity.toJson();
    json.remove('id');
    return _races.add(json);
  }

  static Future<DocumentReference> addResult(ResultEntity resultEntity) {
    final Map<String, dynamic> json = resultEntity.toJson();
    return _results.add(json);
  }

  static Stream<List<ResultEntity>> getResults(String raceId) {
    return _results
        .where('raceId', isEqualTo: raceId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) {
        final Map<String, dynamic> json = document.data();
        return ResultEntity.fromJson(json);
      }).toList();
    });
  }

  static Stream<Set<int>> getNumbers(String raceId) {
    return _results
        .where('raceId', isEqualTo: raceId)
        .snapshots()
        .map((snapshot) {
      return SplayTreeSet.from(
        snapshot.docs.map((document) {
          final Map<String, dynamic> json = document.data();
          return ResultEntity.fromJson(json).number;
        }).toSet(),
        (a, b) => a.compareTo(b),
      );
    });
  }
}
