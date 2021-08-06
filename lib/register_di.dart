import 'package:flutter_sandbox/config/app_config.dart';
import 'package:flutter_sandbox/di/register_di_services.dart';
import 'package:flutter_sandbox/di/register_di_stores.dart';
import 'package:flutter_sandbox/services/connection_service.dart';
import 'package:flutter_sandbox/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void registerDIServices(AppConfig appConfig) {
  getIt.registerSingleton<AppConfig>(appConfig);
  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );

  getIt.registerSingleton<ConnectionService>(
    ConnectionService(appConfig),
  );

  registerServices();
  registerStores();
}
