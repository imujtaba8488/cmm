import 'package:cloud_firestore/cloud_firestore.dart';

import 'transaction.dart' as app;

/// A collection is represented by a user i.e. saved by username. Each collection contains documents i.e. transactions performed by the user.

class Cloud {
  final Firestore _firestore = Firestore.instance;

  Future<String> addTransaction(
      String username, app.Transaction transaction) async {
    DocumentReference docReference =
        await _firestore.collection(username).add(transaction.asMap());

    return docReference.documentID;
  }

  void updateTransaction(String username, app.Transaction transaction) {
    _firestore.collection(username).document(transaction.id).setData(
          transaction.asMap(),
        );
  }

  void deleteTransaction(String accountName, app.Transaction transaction) {
    _firestore.collection(accountName).document(transaction.id).delete();
  }

  Future<List<app.Transaction>> readAllTransaction(String username) async {
    List<app.Transaction> allTransactions = [];

    var snapshot = await _firestore.collection(username).getDocuments();

    snapshot.documents.forEach((document) {
      allTransactions.add(app.Transaction.fromMap(document.data));
    });

    return allTransactions;
  }
}
