import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanvenger_hunt_2/app/data/models/game_status.dart';
import 'package:scanvenger_hunt_2/app/data/models/submission.dart';
import 'package:scanvenger_hunt_2/app/data/models/team.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<Team> getTeamStream(String uid) {
    return _db
        .collection('teams')
        .doc(uid)
        .snapshots()
        .map((snapshot) => Team.fromJson(snapshot.data()!));
  }

  Stream<Submission?> getLastSubmissionStream({
    required String teamId,
    required int mysteryIndex,
    required MysteryPart part,
  }) {
    return _db
        .collection('submissions')
        .where('teamId', isEqualTo: teamId)
        .where('mysteryIndex', isEqualTo: mysteryIndex)
        .where('part', isEqualTo: part.name)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return Submission.fromJson(snapshot.docs.first.data());
    });
  }

  Stream<Submission?> getSingleSubmissionStream(String submissionId) {
    return _db
        .collection('submissions')
        .doc(submissionId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return Submission.fromJson(snapshot.data()!);
      } else {
        return null;
      }
    });
  }

  Future<String> addSubmission(Submission submission) async {
    final docRef = await _db.collection('submissions').add(submission.toJson());
    return docRef.id;
  }

  Future<Submission?> getSingleSubmission(String submissionId) async {
    final doc = await _db.collection('submissions').doc(submissionId).get();
    if (doc.exists && doc.data() != null) {
      return Submission.fromJson(doc.data()!);
    }
    return null;
  }

  Stream<List<Team>> getAllTeamsStream() {
    return _db
        .collection('teams')
        .orderBy('currentMysteryIndex', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Team.fromJson(doc.data())).toList());
  }

  Stream<GameStatus?> getGameStatusStream() {
    return _db
        .collection('game_status')
        .doc('status')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return GameStatus.fromJson(snapshot.data()!);
      }
      return null;
    });
  }

  Future<void> updateTeamProgress(
      String teamId, int newMysteryIndex, MysteryPart newPart) async {
    await _db.collection('teams').doc(teamId).update({
      'currentMysteryIndex': newMysteryIndex,
      'currentPart': newPart.name,
    });
  }
}
