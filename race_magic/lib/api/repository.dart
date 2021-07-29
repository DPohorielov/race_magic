import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:race_magic/model/entity/race_entity.dart';
import 'package:race_magic/model/entity/result_entity.dart';

class Repository {
  Repository();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference<Map<String, dynamic>> _races =
  _firestore.collection('races');

  static CollectionReference<Map<String, dynamic>> _results(String raceId) =>
      _races.doc(raceId).collection('results');

  static Stream<List<RaceEntity>> getRaces() {
    return _races.snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        final Map<String, dynamic> json = document.data();
        json['id'] = document.id;
        return RaceEntity.fromJson(json);
      }).toList();
    });
  }

  static Future<RaceEntity> getRace(String id) async {
    final document = await _races.doc(id).get();
    final Map<String, dynamic> json = document.data()!;
    json['id'] = document.id;
    return RaceEntity.fromJson(json);
  }

  static Future<void> deleteRace(String id) async {
    final snapshots = await _results(id).get();
    for (final doc in snapshots.docs) {
      await doc.reference.delete();
    }
    _races.doc(id).delete();
  }

  static Future<DocumentReference> addRace(RaceEntity raceEntity) {
    final Map<String, dynamic> json = raceEntity.toJson();
    json.remove('id');
    return _races.add(json);
  }

  static Future<void> addResult(ResultEntity resultEntity,
      String raceId) async {
    final Map<String, dynamic> json = resultEntity.toJson();

    await _results(raceId)
        .where('number', isEqualTo: resultEntity.number)
        .where('stage', isEqualTo: resultEntity.stage)
        .where('isStart', isEqualTo: resultEntity.isStart)
        .get()
        .then((event) async {
      if (event.docs.isNotEmpty) {
        final String id = event.docs.single.id;
        final DocumentReference documentReferencer = _results(raceId).doc(id);
        await documentReferencer.update(json);
      } else {
        _results(raceId).add(json);
      }
    });
  }

  static Stream<List<ResultEntity>> getResults(String raceId) {
    return _results(raceId).snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        final Map<String, dynamic> json = document.data();
        return ResultEntity.fromJson(json);
      }).toList();
    });
  }

  static Stream<Set<int>> getNumbers(String raceId) {
    return _results(raceId).snapshots().map((snapshot) {
      return SplayTreeSet.from(
        snapshot.docs.map((document) {
          final Map<String, dynamic> json = document.data();
          return ResultEntity
              .fromJson(json)
              .number;
        }).toSet(),
            (a, b) => a.compareTo(b),
      );
    });
  }
}
