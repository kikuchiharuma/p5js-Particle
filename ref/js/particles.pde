// パーティクルオブジェクトの配列を作成
Particle[] particles = new Particle[50000];

// 初期値の設定
int ww = 600; // 描画領域の幅
int wh = 600; // 描画領域の高さ
int m  = 0;   // 四辺の計算上のマージン(外へ飛び出すパーティクルの処理用)
int ws = 200;  // パーティクル速度の初期値

// 描画用のイメージ型オブジェクトを、描画領域の大きさに合わせて作成
PImage img = createImage(ww, wh, ARGB);

// 初期化
void setup() {
  // p5の描画設定
  frameRate(60);
  size(ww, wh);
  noStroke();
  background(255);
  
  // 全てのパーティクルの初期位置(x,y)をランダムに設定
  for (int i=0; i<particles.length; i++) {
    particles[i] = new Particle(m+random(ww-m*2), m+random(wh-m*2));
  }
}

// メインループ
void draw() {
  // 描画をバッファーするための、描画領域と同じ大きさの配列
  int[] p = new int[ww*wh+1];
  
  // 全てのパーティクルを毎フレーム処理
  for (int i=0; i<particles.length; i++) {
    // オブジェクトのメソッドを呼び出し
    // 自分の新しい位置を計算させる
    particles[i].move();
    // バッファー内に自分の位置を描画させる
    p = particles[i].draw2d(p);
  }
  
  // 描画用オブジェクトに、バッファーの内容を上書き
  img.pixels = p;
  img.updatePixels();
  // 画面をリフレッシュ
  //background(255);
  fill(255, 50);
  rect(0, 0, ww, wh);
  // 画面を描画
  image(img, 0, 0);
}

// パーティクルオブジェクトのクラス定義
class Particle {
  // 自分の位置(x,y)、スピード初期値(s)、現在のスピード(ss)、進行方向ラジアン(d)
  float x, y, s, ss, d;
  // カラー型の変数、自分の色を保持
  color c;
  
  // コンストラクタ(Particle variablename = new Particle() で呼び出される)
  Particle (float xpos, float ypos) {
    this.x  = xpos;
    this.y  = ypos;
    this.s  = ws;
    this.ss = this.s;
    this.d  = random(TWO_PI);
    this.c  = color(int(random(255)), int(random(255)), int(random(255)), 255);
  }
  
  // 新しい自分の座標を計算する(が、何も返さない)パブリックメソッド
  public void move() {
    assignGravity();
    this.x += sin(this.d) * this.ss;
    this.y += cos(this.d) * this.ss;
    checkCollision();
  }
  
  // 引数で受け取った配列の中の、自分の位置にドットを描画し、配列を返すパブリックメソッド
  public int[] draw2d(int[] i) {
    // 自分の座業を整数に変換
    int tx = int(this.x);
    int ty = int(this.y);
    // 自分の座標を配列の添え字に変換
    int p  = ww*ty + tx;
    // 配列の大きさの内側にある場合だけ、描画を実行
    if (0 <= p && p <= ww*wh) {
      // 自分の色(c)を、引数で渡された配列(i)に書き込む
      i[ww*ty + tx] = this.c;
    }
    // intの配列を戻り値として返す
    return i;
  }
  
  // 描画領域の外にはみ出ているかどうかをチェックするプライベートメソッド
  private void checkCollision() {
    if ( this.x <=m || this.x >= ww-m || this.y <= m || this.y >= wh-m) {
      // はみ出ていたら、進行方向方向を反転させる
      this.d -= PI;
    }
  }
  
  // マウスポインタの位置を中心に斥力を生じさせるプライベートメソッド
  private void assignGravity() {
    // マウス座標のベクトル(描画領域中央が原点になるように変換)
    v1 = new PVector(mouseX-ww/2, mouseY-wh/2);
    // 現在の位置のベクトル(描画領域中央を原点になるように変換)
    v2 = new PVector(this.x-ww/2, this.y-wh/2);
    // 二つのベクトル間の距離を計算
    float dt = PVector.dist(v1, v2);
    // 距離に応じて速度を変更
    this.ss = this.s*(1/dt);
  }
}
