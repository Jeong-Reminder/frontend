import 'dart:convert';
import 'package:frontend/models/makeTeam_modal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MakeTeamService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> saveId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('makeTeamId', id);
  }

  Future<int?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('makeTeamId');
  }

  // 팀원 모집글 작성 API
  Future<int> createMakeTeam(MakeTeam makeTeam) async {

    const String baseUrl = 'https://reminder.sungkyul.ac.kr/api/v1/recruitment';
    // const String baseUrl = 'http://127.0.0.1:9000/api/v1/recruitment';
    // const String baseUrl = 'http://10.0.0.2:9000/api/v1/recruitment';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    print('Request Body: ${jsonEncode(makeTeam.toJson())}');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
      body: jsonEncode(makeTeam.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print('팀원 모집글 작성 성공 $responseData');
      int id = responseData['data']['id']; // 백엔드에서 반환된 id 추출
      print('Returned ID: $id'); // 반환된 id 출력

      await saveId(id); // 반환된 ID를 SharedPreferences에 저장

      return id;
    } else {
      throw Exception('팀원 모집글 작성 실패: ${response.body}');
    }
  }

  // 팀원 모집글 아이디로 조회 API
  Future<Map<String, dynamic>> fetchMakeTeam() async {
    final int? id = await getId();
    if (id == null) {
      throw Exception('저장된 MakeTeam ID를 찾을 수 없습니다.');
    }

    final String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/recruitment/$id';
    // final String baseUrl = 'http://10.0.2.2:9000/api/v1/recruitment/$id';
    // final String baseUrl = 'http://127.0.0.1:9000/api/v1/recruitment/$id';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      final dataResponse = responseData['data'];

      // acceptMemberList 추출
      final List<dynamic> acceptMemberList =
          dataResponse['acceptMemberList'] ?? [];

      final List<Map<String, dynamic>> applyResponse =
          (dataResponse['teamApplicationList'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();

      print('팀원 모집글 조회 성공: $responseData');
      print('acceptMemberlist : $acceptMemberList');

      // acceptMemberList와 다른 데이터를 포함한 Map 반환
      return {
        'applyResponse': applyResponse,
        'acceptMemberList': acceptMemberList,
        'data': dataResponse,
      };
    } else {
      print('팀원 모집글 조회 실패: ${response.body}');
      throw Exception();
    }
  }

  // 팀원 모집글 공지글 아이디로 조회(카테고리 조회) API
  Future<List<Map<String, dynamic>>> fetchCateMakeTeam(int id) async {

    final String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/recruitment/category/$id';
    // final String baseUrl =
    //     'http://127.0.0.1:9000/api/v1/recruitment/category/$id';
    // final String baseUrl =
    //     'http://10.0.0.2:9000/api/v1/recruitment/category/$id';
   
    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      // 최종적으로 필요한 정보를 저장할 리스트를 생성
      final List<Map<String, dynamic>> fullDetailsList = [];

      final List<List<Map<String, dynamic>>> cateResponse =
          // 'responseData['data']'를 List<dynamic>로 변환한 후,
          (responseData['data'] as List<dynamic>)
              // 외부 리스트의 각 항목(item)은 내부 리스트
              .map((item) => (item as List<dynamic>).map((innerItem) {
                    // 내부 리스트의 각 항목(innerItem)을 Map<String, dynamic>으로 변환
                    final innerMap = innerItem as Map<String, dynamic>;

                    if (innerMap.containsKey('memberId') &&
                        innerMap.containsKey('recruitmentTitle')) {
                      // acceptMemberList를 추출
                      final List<Map<String, dynamic>> acceptMemberList =
                          (innerMap['acceptMemberList'] as List<dynamic>?)
                                  ?.map((member) =>
                                      member as Map<String, dynamic>)
                                  .toList() ??
                              [];

                      fullDetailsList.add({
                        'memberId': innerMap['memberId'] as int,
                        'recruitmentTitle':
                            innerMap['recruitmentTitle'] as String,
                        'memberName': innerMap['memberName'] ?? '',
                        'memberLevel': innerMap['memberLevel'] ?? '',
                        'createdTime': innerMap['createdTime'] ?? [],
                        'endTime': innerMap['endTime'] ?? [],
                        'recruitmentContent':
                            innerMap['recruitmentContent'] ?? '',
                        'studentCount': innerMap['studentCount'] ?? 0,
                        'hopeField': innerMap['hopeField'] ?? '',
                        'acceptMemberList':
                            acceptMemberList, // acceptMemberList 추가
                      });
                    }
                    // 최종적으로 현재 항목(innerMap)을 반환
                    return innerMap;
                  }).toList())
              // 각 내부 리스트를 처리한 결과를 다시 List<List<Map<String, dynamic>>> 타입으로 변환
              .toList();

      print('팀원 모집글 공지글 아이디로 조회 성공: $cateResponse');

      return fullDetailsList;
    } else {
      print('팀원 모집글 공지글 아이디로 조회 실패: ${response.body}');
      throw Exception();
    }
  }

  // 팀원 모집글 수정 API
  Future<void> updateMakeTeam(MakeTeam makeTeam) async {
    final int? id = await getId();
    if (id == null) {
      throw Exception('저장된 MakeTeam ID를 찾을 수 없습니다.');
    }

    final String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/recruitment/$id';
    // final String baseUrl = 'http://127.0.0.1:9000/api/v1/recruitment/$id';
    // final String baseUrl = 'http://10.0.0.2:9000/api/v1/recruitment/$id';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    // id를 제외한 요청 바디 생성
    final requestBody = makeTeam.toJson();
    requestBody.remove('id');

    print('Request Body: ${jsonEncode(requestBody)}');

    final response = await http.put(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
      body: jsonEncode(requestBody),
    );

    final responseData = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      print('팀원 모집글 수정 성공');
      print('responseData: $responseData');
    } else {
      throw Exception('팀원 모집글 수정 실패: ${response.body}');
    }
  }

  // 팀원 모집글 삭제 API
  Future<void> deleteMakeTeam() async {
    final int? id = await getId(); // 저장된 팀원 모집글 ID를 가져옵니다.
    if (id == null) {
      throw Exception('저장된 MakeTeam ID를 찾을 수 없습니다.');
    }


    final String baseUrl =
        'https://reminder.sungkyul.ac.kr/api/v1/recruitment/$id';
    // final String baseUrl = 'http://127.0.0.1:9000/api/v1/recruitment/$id';
    // final String baseUrl = 'http://10.0.0.2:9000/api/v1/recruitment/$id';

    final token = await getToken();
    if (token == null) {
      throw Exception('Access token을 찾을 수 없습니다.');
    }

    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access': token,
      },
    );

    if (response.statusCode == 200) {
      print('팀원 모집글 삭제 성공');
    } else {
      throw Exception('팀원 모집글 삭제 실패: ${response.body}');
    }
  }
}
