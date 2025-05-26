import 'dart:math';
import 'dart:ui' as ui;
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/utils/utils.dart';
import 'package:galaxy_bird/game_manager.dart';

class Bird extends Component with GameSound {
  Bird({
    required List<Sprite> spriteList,
    this.deadSprites = const [],
    super.x = 50,
    super.y = 100,
    int fat = 0,
    this.rotation = 0,
    this.frame = 0,
    this.speed = 0,
    this.gravity = .125,
    this.thrust = 3.6,
    this.dead = false,
  }) : sprites = spriteList,
       _fat = fat,
       super(sprite: spriteList.isEmpty ? Sprite.empty : spriteList[fat]);

  int _fat;
  List<Sprite> sprites;
  List<ui.Image> deadSprites;
  int frame;
  double rotation;
  double speed;
  double gravity;
  double thrust;
  bool dead;

  @override
  void draw(ui.Canvas canvas, ui.Size size) {
    // Kiểm tra xem có Shield hoặc Ghost đang active không
    bool hasActiveEffect = spells.any(
      (spell) => (spell is Shield || spell is Ghost) && spell.iat > 0,
    );

    // Tạo hiệu ứng nhấp nháy bằng cách thay đổi opacity
    double opacity =
        hasActiveEffect
            ? (DateTime.now().millisecondsSinceEpoch % 600) < 300
                ? 0.5
                : 1.0
            : 1.0;

    double width = sprites[_fat].path[frame].width.toDouble();
    double height = sprites[_fat].path[frame].height.toDouble();
    canvas.save();

    /// Add a translation to the current transform,
    /// shifting the coordinate space horizontally by the first argument
    /// and vertically by the second argument.
    canvas.translate(x, y);

    /// The argument is in radians clockwise.
    canvas.rotate(rotation * GameConstant.RAD);

    // Vẽ bird với opacity thay đổi
    final paint = ui.Paint()..color = ui.Color.fromRGBO(255, 255, 255, opacity);
    canvas.drawImage(
      sprites[_fat].path[frame],
      ui.Offset(-width / 2, -height / 2),
      paint,
    );
    if (dead) {
      double width0 = deadSprites[frame].width.toDouble();
      double height0 = deadSprites[frame].height.toDouble();
      canvas.drawImage(
        deadSprites[frame],
        ui.Offset(-width0 / 2, -height0 / 2),
        ui.Paint(),
      );
    }
    canvas.restore();
  }

  @override
  void update(GameManager gameManager, int frames) {
    double r = sprites[_fat].width.toDouble() / 2;
    switch (gameManager.getGameState()) {
      case GameState.ready:
        y = 100;
        rotation = 0;
        frame += (frames % 10 == 0) ? 1 : 0;
        y += (frames % 10 == 0) ? sin(frames * GameConstant.RAD) : 0;
        break;
      case GameState.play:
        userSpells(gameManager);
        frame += (frames % 5 == 0) ? 1 : 0;
        // bird will be free to fall (inc y)
        y = y + speed;

        setRotation();
        speed = speed + gravity;
        if (y + r >= gameManager.getGround().y ||
            isCollision(gameManager, frames)) {
          dead = true;
          gameManager.gameOver();
        }
        break;
      case GameState.gameOver:
        //this.frame = 1;
        frame += (frames % 5 == 0) ? 1 : 0;
        // touch pipe and fall down
        if (y + r < gameManager.getGround().y) {
          if (!isFlyingInGap(gameManager)) {
            y += speed;
            setRotation();
          }
          speed += gravity * 2;
        } else {
          // touch ground
          speed = 0;
          y = gameManager.getGround().y - r;
          rotation = 90;
          if (!gameManager.isPlayed()) {
            playSound(path: 'die');
            gameManager.setPlayed(true);
          }
        }
        break;
      default:
        break;
    }
    frame = frame % sprites[_fat].length;
  }

  void flap() {
    if (y > 0) {
      speed = -thrust;
      playSound(path: 'flap');
    }
  }

  void reset() {
    speed = 0;
    y = 100;
    dead = false;
    _fat = 0;
    rotation = 0;
    frame = 0;
    speed = 0;
    gravity = .125;
    thrust = 3.6;
    spells.clear();
  }

  void setRotation() {
    if (speed <= 0) {
      // tap event happen
      // speed_range: [-3.6,0]
      // 0 <= (this.speed / (-this.thrust)) <= 1 ~ -25 - 0 degree
      // = -25 when speed = -3.6, 0 when speed = 0
      rotation = max(-25, -25 * speed / (-thrust));
    } else if (speed > 0) {
      // fall
      // speed_range: (0,7.2]
      // 0 < this.speed / (this.thrust * 2) <= 1
      rotation = min(90, 90 * speed / (thrust * 2));
    }
  }

  bool isCollision(GameManager gameManager, int frames) {
    // Pipe pipe = gameManager.getPipes() as Pipe;
    Crate pipe = gameManager.getObstacle() as Crate;

    if (pipe.isEmpty) return false;
    List<Item> items = gameManager.getAvailableItems();
    //final topSprite = pipe.sprites[0];
    final topCrate = pipe.obstacles[0] as Crate;

    final bird = sprites[_fat].path.first;

    /// always compare with first pipe because first pipe will be
    /// removed when it is no longer on canvas
    double xPipe = pipe.obstacles[0].x;
    double yPipe = pipe.obstacles[0].y;

    double r = bird.height / 4 + bird.width / 4;

    double roof = yPipe + topCrate.height;
    double floor = roof + pipe.gap;

    double topSpiteWidth = topCrate.width;
    if (x + r >= xPipe &&
        !(x + r < xPipe + topSpiteWidth) &&
        gameManager.isPipeRemoved()) {
      gameManager.writeScore(RewardType.score);
      int score = gameManager.readScore();
      if (score > 0 && score % 10 == 0) {
        playSound(path: 'score');
      }
      gameManager.setPipeStatus(false);
    }

    /// collide pipe
    final isCollidePipe =
        isCollisionRectRect(
          p1Offset: Vector2(a: -bird.width / 2, b: -bird.height / 2),
          other: topCrate.move(
            Vector2.zero.copyWith(
              a: 0,
              b: topCrate.crateStatus.hasOffset ? topCrate.threshold : 0,
            ),
          ),
        ) ||
        isCollisionRectRect(
          p1Offset: Vector2(a: -bird.width / 2, b: -bird.height / 2),
          other: topCrate.move(
            Vector2.zero.copyWith(
              a: 0,
              b:
                  topCrate.height +
                  pipe.gap -
                  (topCrate.crateStatus.hasOffset ? topCrate.threshold : 0),
            ),
          ),
        );
    if (spells.any((spell) => spell is Shield && spell.iat > 0)) {
      if (isCollidePipe) {
        return false;
      }
    } else if (spells.any((spell) => spell is Ghost && spell.iat > 0)) {
      if (isCollidePipe) {
        return false;
      }
    } else {
      if (isCollidePipe) {
        playSound(path: 'metal_hit');
        return true;
      }
    }

    /// collide item
    if (topCrate.ark != null &&
        isCollisionRectRect(
          other: topCrate.ark!,
          p1Offset: Vector2(a: -bird.width / 2, b: -bird.height / 2),
        )) {
      if (topCrate.ark is Gold) {
        if (!(topCrate.ark as Gold).isCollected) {
          (topCrate.ark as Gold).setCollect();
          gameManager.writeScore(RewardType.coin);
          playSound(path: 'coin_collect');
        }
      }
      //topCrate.ark = null;
    }

    for (var item in items) {
      if (isCollisionRectRect(
        other: item,
        p1Offset: Vector2(a: -bird.width / 2, b: -bird.height / 2),
      )) {
        if (!item.isCollected) {
          item.setCollect();
          if (item.isFruit) {
            gameManager.writeScore(RewardType.fruit);
            playSound(path: 'eat');
          } else if (item is BottlePotion) {
            playSound(path: 'rank_up');
          }
        }
        if (item.isSpell) addSpell(item);
      }
    }

    // if (this.x + r >= xPipe) {
    //   if (this.x + r < xPipe + topSpiteWidth) {
    //     if (this.y - r <= roof || this.y + r >= floor) {
    //       playSound(path: 'metal_hit.mp3');
    //       return true;
    //     }
    //     // We assume when game start at the first time. There will be a pipe is removed on the left
    //     // The result is when the bird pass to the first pipe, the score will be recorded
    //   } else if (gameManager.isPipeRemoved()) {
    //     gameManager.writeScore();
    //     playSound(path: 'score.wav');
    //     gameManager.setPipeStatus(false);
    //   }
    // }

    return false;
  }

  bool isFlyingInGap(GameManager gameManager) {
    Crate pipe = gameManager.getObstacle() as Crate;
    if (pipe.isEmpty) return false;
    final topSprite = pipe.sprite.path[0];
    double xPipe = pipe.obstacles[0].x;
    double yPipe = pipe.obstacles[0].y;
    double roof = yPipe + topSprite.height;
    double floor = roof + pipe.gap;
    return x > xPipe && x < xPipe + topSprite.width && y > roof && y < floor;
  }

  @override
  double get height => sprites[_fat].height.toDouble();

  @override
  double get width => sprites[_fat].width.toDouble();

  List<Item> spells = [];

  void addSpell(Item item) {
    if (item is Magnet) {
      if (!spells.any((e) => e is Magnet)) {
        spells.add(item);
      } else {
        Item magnet = spells.firstWhere((spell) => spell is Magnet);
        magnet.iat += item.iat;
      }
    } else if (item is BottlePotion) {
      if (!spells.any((e) => e is BottlePotion)) {
        spells.add(item);
      } else {
        Item bottle = spells.firstWhere((spell) => spell is BottlePotion);
        bottle.iat += item.iat;
      }
    } else if (item is Ghost) {
      if (!spells.any((e) => e is Ghost)) {
        spells.add(item);
      } else {
        Item ghost = spells.firstWhere((spell) => spell is Ghost);
        ghost.iat += item.iat;
      }
    } else if (item is Shield) {
      if (!spells.any((e) => e is Shield)) {
        spells.add(item);
      } else {
        Item shield = spells.firstWhere((spell) => spell is Shield);
        shield.iat += item.iat;
      }
    }
  }

  void userSpells(GameManager gameManager) {
    spells.removeWhere((spell) => spell.isExpired);
    for (var spell in spells) {
      if (spell is Magnet) {
        gameManager.getAvailableItems().forEach((item) {
          if (item is Gold &&
              isCollisionCircleRect(other: item, radius: spell.affectRadius) &&
              !item.isCollected) {
            /// add: !item.isCollected
            if (item.x < x) {
              item.x += 4;
            } else {
              item.x -= 4;
            }
            if (item.y < y) {
              item.y += 4;
            } else {
              item.y -= 4;
            }
          }
        });
      } else if (spell is BottlePotion) {
        spell.iat > 0 ? _fat = 1 : _fat = 0;
      } else if (spell is Ghost) {
      } else if (spell is Shield) {}
      spell.iat--;
    }
  }
}
