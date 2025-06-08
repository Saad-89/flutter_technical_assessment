import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/reels/data/datasources/reels_local_data_source.dart';
import 'features/reels/data/datasources/reels_remote_data_source.dart';
import 'features/reels/data/repositories/reels_repository_impl.dart';
import 'features/reels/domain/repositories/reels_repository.dart';
import 'features/reels/domain/usecases/get_reels.dart';
import 'features/reels/presentation/bloc/reels_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Reels
  // Bloc
  sl.registerFactory(() => ReelsBloc(getReels: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetReels(sl()));

  // Repository
  sl.registerLazySingleton<ReelsRepository>(
    () => ReelsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ReelsRemoteDataSource>(
    () => ReelsRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ReelsLocalDataSource>(
    () => ReelsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
