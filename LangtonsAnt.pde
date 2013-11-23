Tabuleiro tabuleiro;
ListaDeFormigas formigas;
Ciclo ciclo;
Ajuda ajuda;

void setup() {
  size(500, 500);

  int w = 50;
  int h = 50;

  tabuleiro = new Tabuleiro(w, h);
  formigas = new ListaDeFormigas();
  ciclo = new Ciclo();
  ajuda = new Ajuda();

  // Formiga nova = new Formiga(w / 2, h / 2, 90);
  // formigas.adiciona(nova);
  
  noLoop();
}

void draw() {
  tabuleiro.draw();
  ciclo.draw();
  ajuda.draw();

  formigas.andem();
  
  if (formigas.n > 0) {
    ciclo.proximo();
  }
}

void keyPressed() {
  switch(key) {
     case 'c': ciclo.mostrar = false; break;
     case 'C': ciclo.mostrar = true; break;
     case 'h': ajuda.mostrar = false; break;
     case 'H': ajuda.mostrar = true; break;
  }

  redraw();
}

class Tabuleiro {
  int w, h;
  float dx, dy;
  int[][] celulas;
  
  Tabuleiro(int w, int h) {
    this.w = w;
    this.h = h;
    this.dx = width / w;
    this.dy = height / h;
    this.celulas = new int[h][w];
    
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        celulas[i][j] = 0;
      }
    }
  }
  
  void draw() {
    stroke(0);
    for (float x = dx; x < width; x += dx) {
      line(x, 0, x, height);
    }
    for (float y = dy; y < height; y += dy) {
      line(0, y, height, y);
    }
    
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) {
        noStroke();
        
        if (formigas.temAlgumaEm(i, j)) {
          fill(255, 127, 127);
        }
        else {
          fill(celulas[i][j] == 0 ? 255 : 127);
        }
        
        drawCelula(i, j);
      } 
    }
  }
  
  void drawCelula(int i, int j) {
    int ajusteX = (j == 0 ? 0 : 1);
    int ajusteY = (i == 0 ? 0 : 1);
    rect(j * dx + ajusteX, i * dy + ajusteY, dx - ajusteX, dy - ajusteY);
  }
}

class Formiga {
  int i, j;
  int direcao;
  
  Formiga(int i, int j, int direcao) {
    this.i = i;
    this.j = j;
    this.direcao = direcao;
  }
  
  boolean estaEm(int i, int j) {
     return this.i == i && this.j == j;
  }
  
  void anda() {
    int celula = tabuleiro.celulas[i][j];
    
    if (celula == 0) {
      viraDireita();
      tabuleiro.celulas[i][j] = 1;
      andaFrente();
    }
    else if (celula == 1) {
      viraEsquerda();
      tabuleiro.celulas[i][j] = 0;
      andaFrente();
    } 
  }
  
  void viraDireita() {
    direcao -= 90;
    direcao += 360; // evita negativo
    direcao %= 360;
  }

  void viraEsquerda() {
    direcao += 90;
    direcao %= 360;
  }
  
  void andaFrente() {
    if (direcao == 0) { j++; if (j >= tabuleiro.w) { j = 0; } }
    else if (direcao == 90) { i--; if (i < 0) { i = tabuleiro.h - 1; } }
    else if (direcao == 180) { j--; if (j < 0) { j = tabuleiro.w - 1; } }
    else if (direcao == 270) { i++; if (i >= tabuleiro.h) { i = 0; } }
  }
}

class Ciclo {
  int ciclo;
  boolean mostrar;
  
  Ciclo() {
    ciclo = 0;
    mostrar = true;
  }
  
  void draw() {
    if (mostrar) {
      String cicloAsTexto = str(ciclo);
      float altura = textAscent() + textDescent();
      float largura = textWidth(cicloAsTexto);
      int padding = 5;
      
      fill(255, 255, 127);
      rect(width - largura - padding, 0, largura + padding, altura + padding);
      fill(255, 0, 0);
      text(cicloAsTexto, width - largura, altura);
    }
  }
  
  void proximo() {
    ++ciclo;
  }
}

class Ajuda {
  boolean mostrar;
  
  Ajuda() {
    mostrar = true;
  }
  
  void draw() {
    if (mostrar) {
      int w = 200;
      int h = 130;
      int padding = 10;
  
      fill(191);
      rect(width / 2 - w / 2, height / 2 - h / 2, w, h);
      
      fill(0);
      text("Ajuda\n\nC/c - mostra/esconde ciclos\nH/h - mostra/esconde ajuda\n\nClique em alguma célula para adicionar (até " + formigas.MAX + ") formigas.", width / 2 - w / 2 + padding, height / 2 - h / 2 + padding, w - padding, h - padding);
    }  
  }
}

class ListaDeFormigas {
  int MAX, n;
  Formiga[] formigas;
  
  ListaDeFormigas() {
    MAX = 10;
    n = 0;
    formigas = new Formiga[MAX];
  }
  
  void adiciona(Formiga formiga) {
    if (n < MAX) {
      formigas[n] = formiga;
      ++n;
    }
  }
  
  void andem() {
    for (int k = 0; k < n; k++) {
      formigas[k].anda();
    }
  }
  
  boolean temAlgumaEm(int i, int j) {
    for (int k = 0; k < n; k++) {
      if (formigas[k].estaEm(i, j)) {
        return true;
      }
    }
    
    return false;
  } 
}

void mousePressed() {
  int i = constrain(int(map(mouseY, 0, height - 1, 0, tabuleiro.h)), 0, tabuleiro.h - 1); 
  int j = constrain(int(map(mouseX, 0, width - 1, 0, tabuleiro.w)), 0, tabuleiro.w - 1);

  Formiga nova = new Formiga(i, j, 90);
  formigas.adiciona(nova);
  
  loop();
}

