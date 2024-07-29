// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:simple_news_client/helpers/database_helper.dart' as _i1056;
import 'package:simple_news_client/providers/news_provider.dart' as _i707;
import 'package:simple_news_client/repositories/news_repository.dart' as _i625;
import 'package:simple_news_client/repositories/news_repository_interface.dart'
    as _i847;
import 'package:simple_news_client/services/news_service.dart' as _i952;
import 'package:simple_news_client/services/news_service_interface.dart'
    as _i360;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i847.INewsRepository>(() => _i625.NewsRepository(
          apiKey: gh<String>(instanceName: 'apiKey'),
          baseUrl: gh<String>(instanceName: 'baseUrl'),
        ));
    gh.factory<_i360.INewsService>(() => _i952.NewsService(
          newsRepository: gh<_i847.INewsRepository>(),
          databaseHelper: gh<_i1056.DatabaseHelper>(),
        ));
    gh.factory<_i707.NewsProvider>(
        () => _i707.NewsProvider(newsService: gh<_i360.INewsService>()));
    return this;
  }
}
