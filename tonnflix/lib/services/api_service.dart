import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tonnflix/models/webtoon_detail_model.dart';
import 'package:tonnflix/models/webtoon_episode_model.dart';
import 'package:tonnflix/models/webtoon_model.dart';

class ApiService {
  // state가 없어서 static으로 만들어 준다.
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = "today";

  // state가 없어서 static으로 만들어 준다.
  //  오늘의 웹툰 리스트를 가져오는 함수
  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url); // await를 사용하면 Future가 아닌 실제 데이터를 받는다.
    if (response.statusCode == 200) {
      // 200 OK
      final List<dynamic> webtoons =
          jsonDecode(response.body); // jsonDecode는 json을 Map으로 변환한다.
      for (var webtoon in webtoons) {
        final toon = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(toon);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  // 웹툰 정보를 가져오는 함수
  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  // 웹툰 에피소드를 가져오는 함수
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodeInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodeInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodeInstances;
    }
    throw Error();
  }
}
