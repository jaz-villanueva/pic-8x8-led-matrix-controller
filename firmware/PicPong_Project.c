 /*
 * File:   PONG_PROJ.c
 * Pong Game - PIC16F877A + MAX7219 8x8 LED Matrix
 * MikroC Pro for PIC
 *
 * Wiring (Hardware SPI):
 *   RC5/SDO -> DIN
 *   RC3/SCK -> CLK
 *   RC0     -> CS
 *   RB0     -> Player 1 Up    (Active High)
 *   RB1     -> Player 1 Down  (Active High)
 *   RB2     -> Player 2 Up    (Active High)
 *   RB3     -> Player 2 Down  (Active High)
 */

// ===================== Bool ===============================================
#define bool  unsigned char
#define true  1
#define false 0

// ===================== Button Pins ========================================
#define Player1_up_pin   RB3_bit
#define Player1_down_pin RB2_bit
#define Player2_up_pin   RB1_bit
#define Player2_down_pin RB0_bit

#define BUTTON_PRESSED(pin) ((pin) == 1)

// ===================== MAX7219 Register Addresses =========================
#define NO_OP_REG           0x00
#define DECODE_MODE_REG     0x09
#define INTENSITY_REG       0x0A
#define SCAN_LIMIT_REG      0x0B
#define SHUTDOWN_REG        0x0C
#define DISPLAY_TEST_REG    0x0F

// ===================== MAX7219 Configuration Values =======================
#define DISABLE_DECODE      0x00
#define BRIGHTNESS          0x08
#define SCAN_ALL_DIGITS     0x07
#define NORMAL_OPERATION    0x01
#define DISABLE_TEST        0x00

// ===================== MAX7219 CS Pin ====================================
#define MAX7219_CS      RC0_bit
#define MAX7219_CS_DIR  TRISC0_bit

// ===================== Board / Timing =====================================
#define PLAYER1_COL         7
#define PLAYER2_COL         2
#define FRAME_DELAY_MS      1000
#define DEBOUNCE_DELAY_MS   8

// ===================== LED Row Bitmasks ===================================
#define No_Light  0x00
#define Row0      0x01
#define Row1      0x02
#define Row2      0x04
#define Row3      0x08
#define Row4      0x10
#define Row5      0x20
#define Row6      0x40
#define Row7      0x80

// ===================== Paddle States (4-row paddle) =======================
#define STATE_5   0xF0
#define STATE_4   0x78
#define STATE_3   0x3C
#define STATE_2   0x1E
#define STATE_1   0x0F

// ===================== Global Game Variables ==============================
unsigned char p1State = STATE_3;
unsigned char p2State = STATE_3;

int ballDirX = -1;
int ballDirY = 1;
int ballX = 4;
unsigned char ballYState = Row4;

bool isScore = false;

unsigned char prevB0 = 0;
unsigned char prevB1 = 0;
unsigned char prevB2 = 0;
unsigned char prevB3 = 0;

// ===================== MAX7219 Low-Level ==================================
void MAX7219_Send(unsigned char regAddr, unsigned char regData) {
    MAX7219_CS = 0;
    SPI1_Write(regAddr);
    SPI1_Write(regData);
    MAX7219_CS = 1;
}

void MAX7219_Clear() {
    unsigned char col;
    for (col = 1; col <= 8; col++) {
        MAX7219_Send(col, No_Light);
    }
}

void MAX7219_Config() {
    MAX7219_Send(DISPLAY_TEST_REG, DISABLE_TEST);
    MAX7219_Send(SHUTDOWN_REG, NORMAL_OPERATION);
    MAX7219_Send(DECODE_MODE_REG, DISABLE_DECODE);
    MAX7219_Send(INTENSITY_REG, BRIGHTNESS);
    MAX7219_Send(SCAN_LIMIT_REG, SCAN_ALL_DIGITS);
}

void MAX7219_Init() {
    MAX7219_CS_DIR = 0;
    MAX7219_CS = 1;

    TRISC3_bit = 0;   // SCK output
    TRISC5_bit = 0;   // SDO output

    RC3_bit = 0;
    RC5_bit = 0;

    SPI1_Init_Advanced(
        _SPI_MASTER_OSC_DIV16,
        _SPI_DATA_SAMPLE_MIDDLE,
        _SPI_CLK_IDLE_LOW,
        _SPI_LOW_2_HIGH
    );
}

// ===================== Game Display =======================================
void ApplyPaddleState(unsigned char playerCol, unsigned char paddleState) {
    MAX7219_Send(playerCol, paddleState);
}

void RenderFrame() {
    unsigned char col;
    unsigned char p1Render;
    unsigned char p2Render;

    for (col = 1; col <= 8; col++) {
        MAX7219_Send(col, No_Light);
    }

    p1Render = p1State;
    p2Render = p2State;

    if (ballX == PLAYER1_COL) p1Render |= ballYState;
    if (ballX == PLAYER2_COL) p2Render |= ballYState;

    ApplyPaddleState(PLAYER1_COL, p1Render);
    ApplyPaddleState(PLAYER2_COL, p2Render);

    if ((ballX != PLAYER1_COL) && (ballX != PLAYER2_COL)) {
        MAX7219_Send((unsigned char)ballX, ballYState);
    }
}

void InitGame() {
    p1State = STATE_3;
    p2State = STATE_3;
    ballX = 5;
    ballYState = Row4;
    ballDirX = -1;
    ballDirY = 1;
    isScore = false;

    MAX7219_Clear();
    RenderFrame();
}

// ===================== Button Reading =====================================
unsigned char ReadButton0() { return BUTTON_PRESSED(Player1_up_pin); }
unsigned char ReadButton1() { return BUTTON_PRESSED(Player1_down_pin); }
unsigned char ReadButton2() { return BUTTON_PRESSED(Player2_up_pin); }
unsigned char ReadButton3() { return BUTTON_PRESSED(Player2_down_pin); }

// ===================== Paddle Movement ====================================
void ButtonGoUp(unsigned char player) {
    if (player == 1) {
        switch (p1State) {
            case STATE_1: p1State = STATE_2; break;
            case STATE_2: p1State = STATE_3; break;
            case STATE_3: p1State = STATE_4; break;
            case STATE_4: p1State = STATE_5; break;
            case STATE_5: p1State = STATE_5; break;
            default:      p1State = STATE_3; break;
        }
    } else {
        switch (p2State) {
            case STATE_1: p2State = STATE_2; break;
            case STATE_2: p2State = STATE_3; break;
            case STATE_3: p2State = STATE_4; break;
            case STATE_4: p2State = STATE_5; break;
            case STATE_5: p2State = STATE_5; break;
            default:      p2State = STATE_3; break;
        }
    }
}

void ButtonGoDown(unsigned char player) {
    if (player == 1) {
        switch (p1State) {
            case STATE_1: p1State = STATE_1; break;
            case STATE_2: p1State = STATE_1; break;
            case STATE_3: p1State = STATE_2; break;
            case STATE_4: p1State = STATE_3; break;
            case STATE_5: p1State = STATE_4; break;
            default:      p1State = STATE_3; break;
        }
    } else {
        switch (p2State) {
            case STATE_1: p2State = STATE_1; break;
            case STATE_2: p2State = STATE_1; break;
            case STATE_3: p2State = STATE_2; break;
            case STATE_4: p2State = STATE_3; break;
            case STATE_5: p2State = STATE_4; break;
            default:      p2State = STATE_3; break;
        }
    }
}

// ===================== Ball Logic =========================================
void UpdateBallPosition() {
    if (ballX == PLAYER2_COL) {
        if (p2State & ballYState) {
            ballDirX = -ballDirX;
        }
    } else if (ballX == PLAYER1_COL) {
        if (p1State & ballYState) {
            ballDirX = -ballDirX;
        }
    }

    ballX += ballDirX;

    if ((ballYState & Row0) == Row0) {
        ballYState = Row1;
        ballDirY = 1;
    } else if ((ballYState & Row1) == Row1) {
        ballYState = (ballDirY == 1) ? Row2 : Row0;
    } else if ((ballYState & Row2) == Row2) {
        ballYState = (ballDirY == 1) ? Row3 : Row1;
    } else if ((ballYState & Row3) == Row3) {
        ballYState = (ballDirY == 1) ? Row4 : Row2;
    } else if ((ballYState & Row4) == Row4) {
        ballYState = (ballDirY == 1) ? Row5 : Row3;
    } else if ((ballYState & Row5) == Row5) {
        ballYState = (ballDirY == 1) ? Row6 : Row4;
    } else if ((ballYState & Row6) == Row6) {
        ballYState = (ballDirY == 1) ? Row7 : Row5;
    } else if ((ballYState & Row7) == Row7) {
        ballYState = Row6;
        ballDirY = -1;
    }

    if ((ballX == 1) || (ballX == 8)) {
        isScore = true;
    }

    RenderFrame();
}

// ===================== Main ===============================================
void main() {
    unsigned int elapsed;
    unsigned char b0, b1, b2, b3;

    TRISB = 0xFF;
    TRISC = 0x00;
    PORTB = 0x00;
    PORTC = 0x00;

    OPTION_REG |= 0x80;   // disable PORTB pull-ups

    MAX7219_Init();
    MAX7219_Config();

    while (1) {
        InitGame();

        while (!isScore) {
            elapsed = 0;
            UpdateBallPosition();

            while (elapsed < FRAME_DELAY_MS) {
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

                Delay_ms(DEBOUNCE_DELAY_MS);
                elapsed += DEBOUNCE_DELAY_MS;
            }
        }

        Delay_ms(250);
    }
}