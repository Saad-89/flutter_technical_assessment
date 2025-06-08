import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/reel_model.dart';

abstract class ReelsRemoteDataSource {
  Future<List<ReelModel>> getReels({required int page, required int limit});
}

class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final http.Client client;

  ReelsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ReelModel>> getReels({
    required int page,
    required int limit,
  }) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.reelsEndpoint}?page=$page&limit=$limit',
      );

      final response = await client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: AppConstants.connectionTimeout));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['statusCode'] == 200) {
          final List<dynamic> reelsJson =
              jsonResponse['data']['data'] as List<dynamic>;

          return reelsJson.map((reelJson) {
            try {
              return ReelModel.fromJson(reelJson as Map<String, dynamic>);
            } catch (e) {
              throw ParseException(message: 'Failed to parse reel data: $e');
            }
          }).toList();
        } else {
          throw ServerException(
            message: jsonResponse['message'] ?? 'Unknown server error',
            statusCode: jsonResponse['statusCode'],
          );
        }
      } else {
        throw ServerException(
          message: 'Server returned status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw const NetworkException(message: 'No internet connection available');
    } on FormatException catch (e) {
      throw ParseException(message: 'Invalid response format: $e');
    } on http.ClientException catch (e) {
      throw NetworkException(message: 'Network error occurred: $e');
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is ParseException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }
}
