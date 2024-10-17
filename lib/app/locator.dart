import 'package:chatapp_project/service/api_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<ApiService>(() => ApiService());
  //burada get it metodu apiService classini singleton ediyor
}
