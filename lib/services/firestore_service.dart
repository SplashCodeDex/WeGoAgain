import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addQuotes(List<Map<String, String>> quotes) async {
    final quotesCollection = _db.collection('quotes');
    for (final quote in quotes) {
      await quotesCollection.add(quote);
    }
  }

  Future<DocumentSnapshot> getRandomQuote() async {
    final quotesCollection = _db.collection('quotes');
    final querySnapshot = await quotesCollection.get();
    final randomIndex =
        querySnapshot.docs.isNotEmpty ? (querySnapshot.docs..shuffle()).first.id : null;
    if (randomIndex != null) {
      return await quotesCollection.doc(randomIndex).get();
    } else {
      throw Exception('No quotes found in the database.');
    }
  }
}
