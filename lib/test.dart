import 'dart:io';
import 'dart:math';

class User {
  String? username;
  int userHp;
  int userAttack;
  int userDefense;

  User({
    required this.username,
    required this.userHp,
    required this.userAttack,
    required this.userDefense,
  });
}

class Monster {
  String monsterName;
  int monsterHp;
  int monsterAttack;

  Monster({
    required this.monsterName,
    required this.monsterHp,
    required this.monsterAttack,
  });
}

class Game {
  List<Monster> monsterList = [
    // 제네릭 Monster 타입입
    Monster(monsterName: "spiderman", monsterHp: 20, monsterAttack: 5),
    Monster(monsterName: "thanos", monsterHp: 30, monsterAttack: 5),
    Monster(monsterName: "superman", monsterHp: 30, monsterAttack: 10),
  ];

  User player = User(
    username: "random",
    userHp: 50,
    userAttack: 10,
    userDefense: 5,
  );

  Random random = Random();

  void mainBattle() {
    print("캐릭터의 이름을 입력하세요:");
    player.username = stdin.readLineSync();
    print("게임을 시작합니다!");
    print(
      "${player.username} - 체력: ${player.userHp}, 공격력: ${player.userAttack}, 방어력: ${player.userDefense}",
    );

    Monster? resultMonster;

    while (player.userHp > 0 && monsterList.isNotEmpty) {
      int index = random.nextInt(monsterList.length); // 숙지해야할 Random 리스트 코드 방식
      Monster resultMonster =
          monsterList[index]; // nextInt(n) 메서드는 0부터 n-1까지의 정수 중 하나를 랜덤하게 반환합니다.

      print("새로운 몬스터가 나타났습니다!");
      print(
        "${resultMonster.monsterName} - 체력: ${resultMonster.monsterHp}, 공격력: ${resultMonster.monsterAttack}",
      );

      while (player.userHp > 0 && resultMonster.monsterHp > 0) {
        print("${player.username}의 턴");
        print("행동을 선택하세요 (1: 공격, 2: 방어) ");

        String? inputData = stdin.readLineSync();
        int choice = int.tryParse(inputData ?? "0") ?? 0;
        switch (choice) {
          case 1:
            resultMonster.monsterHp -= player.userAttack;
            print(
              "${player.username}이(가) ${resultMonster.monsterName}에게 ${player.userAttack}의 데미지를 입혔습니다.",
            );
            break;

          case 2:
            player.userHp += resultMonster.monsterAttack;
            print(
              "${player.username}이(가) 방어 태세를 취하여 ${resultMonster.monsterAttack} 만큼 체력을 얻었습니다.",
            );
            break;
        }
        player.userHp -= resultMonster.monsterAttack;
        print(
          "${resultMonster.monsterName}이(가) ${player.username}에게 ${resultMonster.monsterAttack -= player.userDefense}의 데미지를 입혔습니다.",
        );
        if (resultMonster.monsterHp <= 0) {
          print("${resultMonster.monsterName}을 물리쳤습니다!");
          monsterList.remove(resultMonster);
          if (monsterList.isNotEmpty) {
            print("다음 몬스터와 싸우시겠습니까? (y/n)");
            String? nextGameChoice = stdin.readLineSync();
            if (nextGameChoice == "y") {
              print("다음 게임으로 이동합니다.");
              break;
            } else if (nextGameChoice == "n") {
              print("게임이 종료되었습니다.");
              return;
            }
          }
          else if (monsterList.isEmpty){
            print("축하합니다!! 모든 몬스터를 물리쳤습니다.");
          }
        } else if (player.userHp <= 0) {
          print("패배하였습니다.");
          return;
        }
      }
    }
  }
}

void main() {
  Game game = Game();
  game.mainBattle();
}
