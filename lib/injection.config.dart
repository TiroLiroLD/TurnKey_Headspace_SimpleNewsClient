// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:simple_news_client/helpers/database_helper.dart' as _i7;
import 'package:simple_news_client/presentation/providers/news_provider.dart'
    as _i8;
import 'package:simple_news_client/repositories/news_repository.dart' as _i4;
import 'package:simple_news_client/repositories/news_repository_interface.dart'
    as _i3;
import 'package:simple_news_client/services/news_service.dart' as _i6;
import 'package:simple_news_client/services/news_service_interface.dart' as _i5;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.INewsRepository>(() => _i4.NewsRepository(
          apiKey: gh<String>(instanceName: 'apiKey'),
          baseUrl: gh<String>(instanceName: 'baseUrl'),
        ));
    gh.factory<_i5.INewsService>(() => _i6.NewsService(
          newsRepository: gh<_i3.INewsRepository>(),
          databaseHelper: gh<_i7.DatabaseHelper>(),
        ));
    gh.factory<_i8.NewsProvider>(
        () => _i8.NewsProvider(newsService: gh<_i5.INewsService>()));
    return this;
  }
}
