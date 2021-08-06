import 'package:flutter_sandbox/store/call/call_store.dart';
import 'package:flutter_sandbox/store/home/home_store.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void registerStores() {
  registerStoresSingleton();
}

void registerStoresSingleton() {
  getIt.registerLazySingleton<HomeStore>(
    () => HomeStore(),
  );

  getIt.registerLazySingleton<CallStore>(
    () => CallStore(),
  );
}
