import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultScreen extends StatefulWidget {
  final String word;

  const ResultScreen({super.key, required this.word});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<Map<String, dynamic>>? _futureWordData;

  @override
  void initState() {
    super.initState();
    _futureWordData = _fetchWordData(widget.word);
  }

  Future<Map<String, dynamic>> _fetchWordData(String word) async {
    final response = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)[0];
    } else {
      throw Exception("Failed to load word data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureWordData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Nothing Found"));
          } else if (snapshot.hasData) {
            final wordData = snapshot.data!;
            final List meanings = wordData['meanings'] ?? [];
            return ListView.builder(
              itemCount: meanings.length,
              itemBuilder: (context, index) {
                final meaning = meanings[index];
                final String partOfSpeech = meaning['partOfSpeech'] ?? '';
                final List definitions = meaning['definitions'] ?? [];
                final List synonyms = meaning['synonyms'] ?? [];
                final List antonyms = meaning['antonyms'] ?? [];

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Part of Speech: $partOfSpeech', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          ...definitions.map((def) => Text('Definition: ${def['definition']}')).toList(),
                          if (synonyms.isNotEmpty) ...[
                            SizedBox(height: 8),
                            Text('Synonyms: ${synonyms.join(', ')}')
                          ],
                          if (antonyms.isNotEmpty) ...[
                            SizedBox(height: 8),
                            Text('Antonyms: ${antonyms.join(', ')}')
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
