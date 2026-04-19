#line 1 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/Development Systems/EasyPIC v8/Led Blinking/PicPong_Project.c"
#line 73 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/Development Systems/EasyPIC v8/Led Blinking/PicPong_Project.c"
unsigned char p1State =  0x3C ;
unsigned char p2State =  0x3C ;

int ballDirX = -1;
int ballDirY = 1;
int ballX = 4;
unsigned char ballYState =  0x10 ;

 unsigned char  isScore =  0 ;

unsigned char prevB0 = 0;
unsigned char prevB1 = 0;
unsigned char prevB2 = 0;
unsigned char prevB3 = 0;


void MAX7219_Send(unsigned char regAddr, unsigned char regData) {
  RC0_bit  = 0;
 SPI1_Write(regAddr);
 SPI1_Write(regData);
  RC0_bit  = 1;
}

void MAX7219_Clear() {
 unsigned char col;
 for (col = 1; col <= 8; col++) {
 MAX7219_Send(col,  0x00 );
 }
}

void MAX7219_Config() {
 MAX7219_Send( 0x0F ,  0x00 );
 MAX7219_Send( 0x0C ,  0x01 );
 MAX7219_Send( 0x09 ,  0x00 );
 MAX7219_Send( 0x0A ,  0x08 );
 MAX7219_Send( 0x0B ,  0x07 );
}

void MAX7219_Init() {
  TRISC0_bit  = 0;
  RC0_bit  = 1;

 TRISC3_bit = 0;
 TRISC5_bit = 0;

 RC3_bit = 0;
 RC5_bit = 0;

 SPI1_Init_Advanced(
 _SPI_MASTER_OSC_DIV16,
 _SPI_DATA_SAMPLE_MIDDLE,
 _SPI_CLK_IDLE_LOW,
 _SPI_LOW_2_HIGH
 );
}


void ApplyPaddleState(unsigned char playerCol, unsigned char paddleState) {
 MAX7219_Send(playerCol, paddleState);
}

void RenderFrame() {
 unsigned char col;
 unsigned char p1Render;
 unsigned char p2Render;

 for (col = 1; col <= 8; col++) {
 MAX7219_Send(col,  0x00 );
 }

 p1Render = p1State;
 p2Render = p2State;

 if (ballX ==  7 ) p1Render |= ballYState;
 if (ballX ==  2 ) p2Render |= ballYState;

 ApplyPaddleState( 7 , p1Render);
 ApplyPaddleState( 2 , p2Render);

 if ((ballX !=  7 ) && (ballX !=  2 )) {
 MAX7219_Send((unsigned char)ballX, ballYState);
 }
}

void InitGame() {
 p1State =  0x3C ;
 p2State =  0x3C ;
 ballX = 5;
 ballYState =  0x10 ;
 ballDirX = -1;
 ballDirY = 1;
 isScore =  0 ;

 MAX7219_Clear();
 RenderFrame();
}


unsigned char ReadButton0() { return  (( RB3_bit ) == 1) ; }
unsigned char ReadButton1() { return  (( RB2_bit ) == 1) ; }
unsigned char ReadButton2() { return  (( RB1_bit ) == 1) ; }
unsigned char ReadButton3() { return  (( RB0_bit ) == 1) ; }


void ButtonGoUp(unsigned char player) {
 if (player == 1) {
 switch (p1State) {
 case  0x0F : p1State =  0x1E ; break;
 case  0x1E : p1State =  0x3C ; break;
 case  0x3C : p1State =  0x78 ; break;
 case  0x78 : p1State =  0xF0 ; break;
 case  0xF0 : p1State =  0xF0 ; break;
 default: p1State =  0x3C ; break;
 }
 } else {
 switch (p2State) {
 case  0x0F : p2State =  0x1E ; break;
 case  0x1E : p2State =  0x3C ; break;
 case  0x3C : p2State =  0x78 ; break;
 case  0x78 : p2State =  0xF0 ; break;
 case  0xF0 : p2State =  0xF0 ; break;
 default: p2State =  0x3C ; break;
 }
 }
}

void ButtonGoDown(unsigned char player) {
 if (player == 1) {
 switch (p1State) {
 case  0x0F : p1State =  0x0F ; break;
 case  0x1E : p1State =  0x0F ; break;
 case  0x3C : p1State =  0x1E ; break;
 case  0x78 : p1State =  0x3C ; break;
 case  0xF0 : p1State =  0x78 ; break;
 default: p1State =  0x3C ; break;
 }
 } else {
 switch (p2State) {
 case  0x0F : p2State =  0x0F ; break;
 case  0x1E : p2State =  0x0F ; break;
 case  0x3C : p2State =  0x1E ; break;
 case  0x78 : p2State =  0x3C ; break;
 case  0xF0 : p2State =  0x78 ; break;
 default: p2State =  0x3C ; break;
 }
 }
}


void UpdateBallPosition() {
 if (ballX ==  2 ) {
 if (p2State & ballYState) {
 ballDirX = -ballDirX;
 }
 } else if (ballX ==  7 ) {
 if (p1State & ballYState) {
 ballDirX = -ballDirX;
 }
 }

 ballX += ballDirX;

 if ((ballYState &  0x01 ) ==  0x01 ) {
 ballYState =  0x02 ;
 ballDirY = 1;
 } else if ((ballYState &  0x02 ) ==  0x02 ) {
 ballYState = (ballDirY == 1) ?  0x04  :  0x01 ;
 } else if ((ballYState &  0x04 ) ==  0x04 ) {
 ballYState = (ballDirY == 1) ?  0x08  :  0x02 ;
 } else if ((ballYState &  0x08 ) ==  0x08 ) {
 ballYState = (ballDirY == 1) ?  0x10  :  0x04 ;
 } else if ((ballYState &  0x10 ) ==  0x10 ) {
 ballYState = (ballDirY == 1) ?  0x20  :  0x08 ;
 } else if ((ballYState &  0x20 ) ==  0x20 ) {
 ballYState = (ballDirY == 1) ?  0x40  :  0x10 ;
 } else if ((ballYState &  0x40 ) ==  0x40 ) {
 ballYState = (ballDirY == 1) ?  0x80  :  0x20 ;
 } else if ((ballYState &  0x80 ) ==  0x80 ) {
 ballYState =  0x40 ;
 ballDirY = -1;
 }

 if ((ballX == 1) || (ballX == 8)) {
 isScore =  1 ;
 }

 RenderFrame();
}


void main() {
 unsigned int elapsed;
 unsigned char b0, b1, b2, b3;

 TRISB = 0xFF;
 TRISC = 0x00;
 PORTB = 0x00;
 PORTC = 0x00;

 OPTION_REG |= 0x80;

 MAX7219_Init();
 MAX7219_Config();

 while (1) {
 InitGame();

 while (!isScore) {
 elapsed = 0;
 UpdateBallPosition();

 while (elapsed <  1000 ) {
 b0 = ReadButton0();
 b1 = ReadButton1();
 b2 = ReadButton2();
 b3 = ReadButton3();

 if (b0 && !prevB0) {
 ButtonGoUp(1);
 RenderFrame();
 }
 if (b1 && !prevB1) {
 ButtonGoDown(1);
 RenderFrame();
 }
 if (b2 && !prevB2) {
 ButtonGoUp(2);
 RenderFrame();
 }
 if (b3 && !prevB3) {
 ButtonGoDown(2);
 RenderFrame();
 }

 prevB0 = b0;
 prevB1 = b1;
 prevB2 = b2;
 prevB3 = b3;

 Delay_ms( 8 );
 elapsed +=  8 ;
 }
 }

 Delay_ms(250);
 }
}
