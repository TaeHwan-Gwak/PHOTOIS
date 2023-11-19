import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

enum SearchSeason { spring, summer, autumn, winter }

enum SearchTime { day, night }

enum SearchWeather { sun, cloudSun, cloud, rainy, snow }

class Tab2 extends StatefulWidget {
  const Tab2({super.key});

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  final TextEditingController _searchController = TextEditingController();
  SearchSeason selectedSeason = SearchSeason.spring;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        const SizedBox(height: 30),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: '검색',
            hintText: '찾고싶은 사진 스팟 장소를 입력해주세요',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onChanged: (value) {
            // 검색어 변경 시 동작
            print('검색어: $value');
          },
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SearchSeason>(
                  value: selectedSeason,
                  onChanged: (SearchSeason? newValue) {
                    setState(() {
                      selectedSeason = newValue!;
                    });
                  },
                  items: SearchSeason.values.map((SearchSeason status) {
                    return DropdownMenuItem<SearchSeason>(
                      value: status,
                      child: Text(status.toString().split('.').last),
                    );
                  }).toList(),
                  icon: null,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}

/*
Scaffold(
      body: KakaoMap(),
    );
*/
