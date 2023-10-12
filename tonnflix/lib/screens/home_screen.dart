import 'package:flutter/material.dart';
import 'package:tonnflix/models/webtoon_model.dart';
import 'package:tonnflix/services/api_service.dart';
import 'package:tonnflix/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // FutureBuilder가 자동으로 await를 해준다.
      body: FutureBuilder(
        future: webtoons,
        // context는 BuilderContext랑 동일한 역할을 한다 // snapshot Future에 상태를 알 수 있다.
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  // Listview가 정해진 크기가 없어서 오류가 발생한다. 그래서 Expanded로 감싸준다.
                  child: makeList(snapshot),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(
                // 로딩중을 표시해주는 위젯
                ),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      // scrollDirection은 ListView의 방향을 정해준다.
      scrollDirection: Axis.horizontal,
      // itemCount는 ListView의 아이템 개수를 정해준다.
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // itemBuilder는 ListView의 각각의 아이템을 만들어준다.
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      // separatorBuilder는 ListView의 각각의 아이템 사이에 있는 위젯을 만들어준다.
      separatorBuilder: (context, index) {
        return const SizedBox(
          width: 40,
        );
      },
    );
  }
}
