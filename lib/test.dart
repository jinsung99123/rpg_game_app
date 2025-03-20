/*
수정해야할 사항

1. 주석추가 (완료!)
2. 사용자의 스텟 및 몬스터의 스텟, 턴 표시가 보여지지 않는 현상 수정 (완료!)
3. 몬스터의 공격력이 지속적으로 감소하는 현상 수정 (완료!)
4. 방어력 값이 차감되지 않고 몬스터의 공격력만큼 데미지가 들어오는 현상 (완료!)
5. 방어 논리 수정(방어시 공격받은 수치를 회복해야하는데 공격받지 않아도(첫 번째 턴)체력 회복하는 논리)
6. 사용자가 몬스터를 먼저 처치하여도(몬스터 체력이 0이하가 되더라도) 몬스터가 한턴은 공격을 하는 현상 수정
7. 메시지 출력간 2초의 지연시간 추가
8. 세밀한 게임 방식의 논리 오류 수정
9. 가독성과 유지보수성을 위한 코드 분리 시도

ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
이번 수정사항
5. 방어 논리 수정(방어시 공격받은 수치를 회복해야하는데 공격받지 않아도(첫 번째 턴)체력 회복하는 논리)
-           case 2:
            int recoverHp = player.userHp + resultMonster.monsterAttack;
            if (recoverHp < 100) {
              player.userHp += resultMonster.monsterAttack;
              print(
                "${player.username}이(가) 방어 태세를 취하여 ${resultMonster.monsterAttack} 만큼 체력을 얻었습니다.",
              );
            } else {
              print("방어할 수 없습니다.");
            }
            break;
  에서 최대 체력을 설정하여 100이하는 공격 받았다는 것으로 동일시하고 체력회복 진행
  최대체력이 100이면 공격을 받지 않았다는 것으로 동일시하고 방어 실패 출력
  (공격력이 높거나 방어력이 낮으면면 100이 넘어갈 수 있기 때문에 더 정확한 게임 논리(공격을 받았을시 공격을 인식하고 방어가 가능한 구조)를 구현해봐야할 것 같다..)


6. 사용자가 몬스터를 먼저 처치하여도(몬스터 체력이 0이하가 되더라도) 몬스터가 한턴은 공격을 하는 현상 수정
- 몬스터 공격 패턴 로직에 if (resultMonster.monsterHp > 0) 만 감싸주어도 문제가 해결이 된다.
- 그러나 코드가 길어지고 순차적으로만 진행되고 예쁘게 정리되지는 않은 것 같다. 이 여러개의 if 조건문들은 객체지향적으로 바꾸는 과정에서 더 정리하거나 축약하는 방법이 없는지 연구해봐야할 것 같다.


*/

import 'dart:io';
import 'dart:math';

class User {
  // 사용자 클래스 정의
  String? username;
  int userHp;
  int userAttack;
  int userDefense;

  User({
    // 초기값 설정(생성자)
    required this.username,
    required this.userHp,
    required this.userAttack,
    required this.userDefense,
  });
}

class Monster {
  // 몬스터 클래스 정의
  String monsterName;
  int monsterHp;
  int monsterAttack;

  Monster({
    // 초기값 설정(생성자)
    required this.monsterName,
    required this.monsterHp,
    required this.monsterAttack,
  });
}

class Game {
  List<Monster> monsterList = [
    // 몬스터 리스트 초기화
    Monster(monsterName: "spiderman", monsterHp: 20, monsterAttack: 5),
    Monster(monsterName: "thanos", monsterHp: 30, monsterAttack: 15),
    Monster(monsterName: "superman", monsterHp: 30, monsterAttack: 10),
  ];

  User player = User(
    // 사용자 정보 초기화
    username: "random",
    userHp: 100,
    userAttack: 10,
    userDefense: 5,
  );

  Random random = Random(); //랜덤 숫자 생성을 위한 random 객체 생성

  void mainBattle() {
    print("캐릭터의 이름을 입력하세요:");
    player.username = stdin.readLineSync();
    print("게임을 시작합니다!");
    print(
      "${player.username} - 체력: ${player.userHp}, 공격력: ${player.userAttack}, 방어력: ${player.userDefense}",
    ); // 게임 시작 출력문

    while (player.userHp > 0 && monsterList.isNotEmpty) {
      // 외부 While문 시작(루프시킬 전체 게임구조)
      int index = random.nextInt(monsterList.length); // 숙지해야할 Random 리스트 코드 방식
      Monster resultMonster =
          monsterList[index]; // nextInt(n) 메서드는 0부터 n-1까지의 정수 중 하나를 랜덤하게 반환합니다.

      print("새로운 몬스터가 나타났습니다!");
      print(
        "${resultMonster.monsterName} - 체력: ${resultMonster.monsterHp}, 공격력: ${resultMonster.monsterAttack}",
      );

      while (player.userHp > 0 && resultMonster.monsterHp > 0) {
        // 내부 While문 시작(루프시킬 전투 구조)
        print("${player.username}의 턴");
        print("행동을 선택하세요 (1: 공격, 2: 방어) ");

        String? inputData = stdin.readLineSync(); // 사용자의 공격패턴 입력받기
        int choice = int.tryParse(inputData ?? "0") ?? 0;
        switch (choice) {
          case 1:
            resultMonster.monsterHp -= player.userAttack;
            print(
              "${player.username}이(가) ${resultMonster.monsterName}에게 ${player.userAttack}의 데미지를 입혔습니다.",
            );
            break;

          case 2:
            int recoverHp = player.userHp + resultMonster.monsterAttack;
            if (recoverHp < 100) {
              player.userHp += resultMonster.monsterAttack;
              print(
                "${player.username}이(가) 방어 태세를 취하여 ${resultMonster.monsterAttack} 만큼 체력을 얻었습니다.",
              );
            } else {
              print("방어할 수 없습니다.");
            }
            break;
        } // 사용자의 행동패턴 조건식 switch문 (공격 or 방어)
        if (resultMonster.monsterHp > 0) {
          print("${resultMonster.monsterName}의 턴");

          player.userHp -=
              (resultMonster.monsterAttack -
                  player.userDefense); // 몬스터 행동 패턴 (공격 고정)
          print(
            "${resultMonster.monsterName}이(가) ${player.username}에게 ${resultMonster.monsterAttack - player.userDefense}의 데미지를 입혔습니다.",
          );

          print(
            "${player.username} - 체력: ${player.userHp}, 공격력: ${player.userAttack}, 방어력: ${player.userDefense}",
          );
          print(
            "${resultMonster.monsterName} - 체력: ${resultMonster.monsterHp}, 공격력: ${resultMonster.monsterAttack}",
          );
        }
        if (resultMonster.monsterHp <= 0) {
          // 최상위 if, else if문 (몬스터 사망(몬스터 사망시 리스트에서 제거)/플레이어 사망)
          print("${resultMonster.monsterName}을 물리쳤습니다!");
          monsterList.remove(resultMonster);
          if (monsterList.isNotEmpty) {
            // 하위 if, else if문 (다음 몬스터 선택/모두 처치시 멘트 출력)
            print("다음 몬스터와 싸우시겠습니까? (y/n)");
            String? nextGameChoice = stdin.readLineSync();
            if (nextGameChoice == "y") {
              // 최하위 if, else if문 (다음 게임 이동 Yes or No)
              print("다음 게임으로 이동합니다.");
              break; // 몬스터 처치시 내부 While문 탈출
            } else if (nextGameChoice == "n") {
              print("게임이 종료되었습니다.");
              return; // 게임 종료 (void mainbattle()탈출)
            }
          } else if (monsterList.isEmpty) {
            print("축하합니다!! 모든 몬스터를 물리쳤습니다.");
          } // 리스트 내의 모든 몬스터 제거시 출력 멘트
        } else if (player.userHp <= 0) {
          print("패배하였습니다.");
          return;
        } // 플레이어 사망시 게임 종료
      }
    }
  }
}

void main() {
  Game game = Game(); // 게임 인스턴스 생성
  game.mainBattle(); // 게임시작
}

