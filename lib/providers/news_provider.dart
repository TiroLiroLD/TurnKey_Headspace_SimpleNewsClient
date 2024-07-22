import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../models/source.dart';
import '../services/news_service_interface.dart';

@injectable
class NewsProvider with ChangeNotifier {
  final INewsService newsService;
  List<Source> _sources = [];

  NewsProvider({required this.newsService});

  List<Source> get sources => _sources;

  Future<void> fetchSources() async {
    try {
      _sources = await newsService.getSources();
      notifyListeners();
    } catch (e) {
      print('Error fetching sources: $e');
    }
  }
}
