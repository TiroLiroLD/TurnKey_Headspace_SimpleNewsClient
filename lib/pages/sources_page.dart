import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/source.dart';
import '../services/news_service_interface.dart';
import 'articles_by_source_page.dart';

class SourcesPage extends StatefulWidget {
  @override
  _SourcesPageState createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
  late INewsService newsService;
  List<Source> sources = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    newsService = GetIt.instance<INewsService>();
    fetchSources();
  }

  Future<void> fetchSources() async {
    try {
      List<Source> fetchedSources = await newsService.getSources();
      setState(() {
        sources = fetchedSources;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print('Error fetching sources: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Sources'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: sources.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(sources[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticlesBySourcePage(source: sources[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
