
_MAX7219_Send:

;PicPong_Project.c,89 :: 		void MAX7219_Send(unsigned char regAddr, unsigned char regData) {
;PicPong_Project.c,90 :: 		MAX7219_CS = 0;
	BCF        RC0_bit+0, BitPos(RC0_bit+0)
;PicPong_Project.c,91 :: 		SPI1_Write(regAddr);
	MOVF       FARG_MAX7219_Send_regAddr+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;PicPong_Project.c,92 :: 		SPI1_Write(regData);
	MOVF       FARG_MAX7219_Send_regData+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;PicPong_Project.c,93 :: 		MAX7219_CS = 1;
	BSF        RC0_bit+0, BitPos(RC0_bit+0)
;PicPong_Project.c,94 :: 		}
L_end_MAX7219_Send:
	RETURN
; end of _MAX7219_Send

_MAX7219_Clear:

;PicPong_Project.c,96 :: 		void MAX7219_Clear() {
;PicPong_Project.c,98 :: 		for (col = 1; col <= 8; col++) {
	MOVLW      1
	MOVWF      MAX7219_Clear_col_L0+0
L_MAX7219_Clear0:
	MOVF       MAX7219_Clear_col_L0+0, 0
	SUBLW      8
	BTFSS      STATUS+0, 0
	GOTO       L_MAX7219_Clear1
;PicPong_Project.c,99 :: 		MAX7219_Send(col, No_Light);
	MOVF       MAX7219_Clear_col_L0+0, 0
	MOVWF      FARG_MAX7219_Send_regAddr+0
	CLRF       FARG_MAX7219_Send_regData+0
	CALL       _MAX7219_Send+0
;PicPong_Project.c,98 :: 		for (col = 1; col <= 8; col++) {
	INCF       MAX7219_Clear_col_L0+0, 1
;PicPong_Project.c,100 :: 		}
	GOTO       L_MAX7219_Clear0
L_MAX7219_Clear1:
;PicPong_Project.c,101 :: 		}
L_end_MAX7219_Clear:
	RETURN
; end of _MAX7219_Clear

_MAX7219_Config:

;PicPong_Project.c,103 :: 		void MAX7219_Config() {
;PicPong_Project.c,104 :: 		MAX7219_Send(DISPLAY_TEST_REG, DISABLE_TEST);
	MOVLW      15
	MOVWF      FARG_MAX7219_Send_regAddr+0
	CLRF       FARG_MAX7219_Send_regData+0
	CALL       _MAX7219_Send+0
;PicPong_Project.c,105 :: 		MAX7219_Send(SHUTDOWN_REG, NORMAL_OPERATION);
	MOVLW      12
	MOVWF      FARG_MAX7219_Send_regAddr+0
	MOVLW      1
	MOVWF      FARG_MAX7219_Send_regData+0
	CALL       _MAX7219_Send+0
;PicPong_Project.c,106 :: 		MAX7219_Send(DECODE_MODE_REG, DISABLE_DECODE);
	MOVLW      9
	MOVWF      FARG_MAX7219_Send_regAddr+0
	CLRF       FARG_MAX7219_Send_regData+0
	CALL       _MAX7219_Send+0
;PicPong_Project.c,107 :: 		MAX7219_Send(INTENSITY_REG, BRIGHTNESS);
	MOVLW      10
	MOVWF      FARG_MAX7219_Send_regAddr+0
	MOVLW      8
	MOVWF      FARG_MAX7219_Send_regData+0
	CALL       _MAX7219_Send+0
;PicPong_Project.c,108 :: 		MAX7219_Send(SCAN_LIMIT_REG, SCAN_ALL_DIGITS);
	MOVLW      11
	MOVWF      FARG_MAX7219_Send_regAddr+0
	MOVLW      7
	MOVWF      FARG_MAX7219_Send_regData+0
	CALL       _MAX7219_Send+0
;PicPong_Project.c,109 :: 		}
L_end_MAX7219_Config:
	RETURN
; end of _MAX7219_Config

_MAX7219_Init:

;PicPong_Project.c,111 :: 		void MAX7219_Init() {
;PicPong_Project.c,112 :: 		MAX7219_CS_DIR = 0;
	BCF        TRISC0_bit+0, BitPos(TRISC0_bit+0)
;PicPong_Project.c,113 :: 		MAX7219_CS = 1;
	BSF        RC0_bit+0, BitPos(RC0_bit+0)
;PicPong_Project.c,115 :: 		TRISC3_bit = 0;   // SCK output
	BCF        TRISC3_bit+0, BitPos(TRISC3_bit+0)
;PicPong_Project.c,116 :: 		TRISC5_bit = 0;   // SDO output
	BCF        TRISC5_bit+0, BitPos(TRISC5_bit+0)
;PicPong_Project.c,118 :: 		RC3_bit = 0;
	BCF        RC3_bit+0, BitPos(RC3_bit+0)
;PicPong_Project.c,119 :: 		RC5_bit = 0;
	BCF        RC5_bit+0, BitPos(RC5_bit+0)
;PicPong_Project.c,122 :: 		_SPI_MASTER_OSC_DIV16,
	MOVLW      1
	MOVWF      FARG_SPI1_Init_Advanced_master+0
;PicPong_Project.c,123 :: 		_SPI_DATA_SAMPLE_MIDDLE,
	CLRF       FARG_SPI1_Init_Advanced_data_sample+0
;PicPong_Project.c,124 :: 		_SPI_CLK_IDLE_LOW,
	CLRF       FARG_SPI1_Init_Advanced_clock_idle+0
;PicPong_Project.c,125 :: 		_SPI_LOW_2_HIGH
	MOVLW      1
	MOVWF      FARG_SPI1_Init_Advanced_transmit_edge+0
	CALL       _SPI1_Init_Advanced+0
;PicPong_Project.c,127 :: 		}
L_end_MAX7219_Init:
	RETURN
; end of _MAX7219_Init

_ApplyPaddleState:

;PicPong_Project.c,130 :: 		void ApplyPaddleState(unsigned char playerCol, unsigned char paddleState) {
;PicPong_Project.c,131 :: 		MAX7219_Send(playerCol, paddleState);
	MOVF       FARG_ApplyPaddleState_playerCol+0, 0
	MOVWF      FARG_MAX7219_Send_regAddr+0
	MOVF       FARG_ApplyPaddleState_paddleState+0, 0
	MOVWF      FARG_MAX7219_Send_regData+0
	CALL       _MAX7219_Send+0
;PicPong_Project.c,132 :: 		}
L_end_ApplyPaddleState:
	RETURN
; end of _ApplyPaddleState

_RenderFrame:

;PicPong_Project.c,134 :: 		void RenderFrame() {
;PicPong_Project.c,139 :: 		for (col = 1; col <= 8; col++) {
	MOVLW      1
	MOVWF      RenderFrame_col_L0+0
L_RenderFrame3:
	MOVF       RenderFrame_col_L0+0, 0
	SUBLW      8
	BTFSS      STATUS+0, 0
	GOTO       L_RenderFrame4
;PicPong_Project.c,140 :: 		MAX7219_Send(col, No_Light);
	MOVF       RenderFrame_col_L0+0, 0
	MOVWF      FARG_MAX7219_Send_regAddr+0
	CLRF       FARG_MAX7219_Send_regData+0
	CALL       _MAX7219_Send+0
;PicPong_Project.c,139 :: 		for (col = 1; col <= 8; col++) {
	INCF       RenderFrame_col_L0+0, 1
;PicPong_Project.c,141 :: 		}
	GOTO       L_RenderFrame3
L_RenderFrame4:
;PicPong_Project.c,143 :: 		p1Render = p1State;
	MOVF       _p1State+0, 0
	MOVWF      RenderFrame_p1Render_L0+0
;PicPong_Project.c,144 :: 		p2Render = p2State;
	MOVF       _p2State+0, 0
	MOVWF      RenderFrame_p2Render_L0+0
;PicPong_Project.c,146 :: 		if (ballX == PLAYER1_COL) p1Render |= ballYState;
	MOVLW      0
	XORWF      _ballX+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RenderFrame114
	MOVLW      7
	XORWF      _ballX+0, 0
L__RenderFrame114:
	BTFSS      STATUS+0, 2
	GOTO       L_RenderFrame6
	MOVF       _ballYState+0, 0
	IORWF      RenderFrame_p1Render_L0+0, 1
L_RenderFrame6:
;PicPong_Project.c,147 :: 		if (ballX == PLAYER2_COL) p2Render |= ballYState;
	MOVLW      0
	XORWF      _ballX+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RenderFrame115
	MOVLW      2
	XORWF      _ballX+0, 0
L__RenderFrame115:
	BTFSS      STATUS+0, 2
	GOTO       L_RenderFrame7
	MOVF       _ballYState+0, 0
	IORWF      RenderFrame_p2Render_L0+0, 1
L_RenderFrame7:
;PicPong_Project.c,149 :: 		ApplyPaddleState(PLAYER1_COL, p1Render);
	MOVLW      7
	MOVWF      FARG_ApplyPaddleState_playerCol+0
	MOVF       RenderFrame_p1Render_L0+0, 0
	MOVWF      FARG_ApplyPaddleState_paddleState+0
	CALL       _ApplyPaddleState+0
;PicPong_Project.c,150 :: 		ApplyPaddleState(PLAYER2_COL, p2Render);
	MOVLW      2
	MOVWF      FARG_ApplyPaddleState_playerCol+0
	MOVF       RenderFrame_p2Render_L0+0, 0
	MOVWF      FARG_ApplyPaddleState_paddleState+0
	CALL       _ApplyPaddleState+0
;PicPong_Project.c,152 :: 		if ((ballX != PLAYER1_COL) && (ballX != PLAYER2_COL)) {
	MOVLW      0
	XORWF      _ballX+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RenderFrame116
	MOVLW      7
	XORWF      _ballX+0, 0
L__RenderFrame116:
	BTFSC      STATUS+0, 2
	GOTO       L_RenderFrame10
	MOVLW      0
	XORWF      _ballX+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RenderFrame117
	MOVLW      2
	XORWF      _ballX+0, 0
L__RenderFrame117:
	BTFSC      STATUS+0, 2
	GOTO       L_RenderFrame10
L__RenderFrame102:
;PicPong_Project.c,153 :: 		MAX7219_Send((unsigned char)ballX, ballYState);
	MOVF       _ballX+0, 0
	MOVWF      FARG_MAX7219_Send_regAddr+0
	MOVF       _ballYState+0, 0
	MOVWF      FARG_MAX7219_Send_regData+0
	CALL       _MAX7219_Send+0
;PicPong_Project.c,154 :: 		}
L_RenderFrame10:
;PicPong_Project.c,155 :: 		}
L_end_RenderFrame:
	RETURN
; end of _RenderFrame

_InitGame:

;PicPong_Project.c,157 :: 		void InitGame() {
;PicPong_Project.c,158 :: 		p1State = STATE_3;
	MOVLW      60
	MOVWF      _p1State+0
;PicPong_Project.c,159 :: 		p2State = STATE_3;
	MOVLW      60
	MOVWF      _p2State+0
;PicPong_Project.c,160 :: 		ballX = 5;
	MOVLW      5
	MOVWF      _ballX+0
	MOVLW      0
	MOVWF      _ballX+1
;PicPong_Project.c,161 :: 		ballYState = Row4;
	MOVLW      16
	MOVWF      _ballYState+0
;PicPong_Project.c,162 :: 		ballDirX = -1;
	MOVLW      255
	MOVWF      _ballDirX+0
	MOVLW      255
	MOVWF      _ballDirX+1
;PicPong_Project.c,163 :: 		ballDirY = 1;
	MOVLW      1
	MOVWF      _ballDirY+0
	MOVLW      0
	MOVWF      _ballDirY+1
;PicPong_Project.c,164 :: 		isScore = false;
	CLRF       _isScore+0
;PicPong_Project.c,166 :: 		MAX7219_Clear();
	CALL       _MAX7219_Clear+0
;PicPong_Project.c,167 :: 		RenderFrame();
	CALL       _RenderFrame+0
;PicPong_Project.c,168 :: 		}
L_end_InitGame:
	RETURN
; end of _InitGame

_ReadButton0:

;PicPong_Project.c,171 :: 		unsigned char ReadButton0() { return BUTTON_PRESSED(Player1_up_pin); }
	CLRF       R1+0
	BTFSC      RB3_bit+0, BitPos(RB3_bit+0)
	INCF       R1+0, 1
	MOVF       R1+0, 0
	XORLW      1
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
L_end_ReadButton0:
	RETURN
; end of _ReadButton0

_ReadButton1:

;PicPong_Project.c,172 :: 		unsigned char ReadButton1() { return BUTTON_PRESSED(Player1_down_pin); }
	CLRF       R1+0
	BTFSC      RB2_bit+0, BitPos(RB2_bit+0)
	INCF       R1+0, 1
	MOVF       R1+0, 0
	XORLW      1
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
L_end_ReadButton1:
	RETURN
; end of _ReadButton1

_ReadButton2:

;PicPong_Project.c,173 :: 		unsigned char ReadButton2() { return BUTTON_PRESSED(Player2_up_pin); }
	CLRF       R1+0
	BTFSC      RB1_bit+0, BitPos(RB1_bit+0)
	INCF       R1+0, 1
	MOVF       R1+0, 0
	XORLW      1
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
L_end_ReadButton2:
	RETURN
; end of _ReadButton2

_ReadButton3:

;PicPong_Project.c,174 :: 		unsigned char ReadButton3() { return BUTTON_PRESSED(Player2_down_pin); }
	CLRF       R1+0
	BTFSC      RB0_bit+0, BitPos(RB0_bit+0)
	INCF       R1+0, 1
	MOVF       R1+0, 0
	XORLW      1
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
L_end_ReadButton3:
	RETURN
; end of _ReadButton3

_ButtonGoUp:

;PicPong_Project.c,177 :: 		void ButtonGoUp(unsigned char player) {
;PicPong_Project.c,178 :: 		if (player == 1) {
	MOVF       FARG_ButtonGoUp_player+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_ButtonGoUp11
;PicPong_Project.c,179 :: 		switch (p1State) {
	GOTO       L_ButtonGoUp12
;PicPong_Project.c,180 :: 		case STATE_1: p1State = STATE_2; break;
L_ButtonGoUp14:
	MOVLW      30
	MOVWF      _p1State+0
	GOTO       L_ButtonGoUp13
;PicPong_Project.c,181 :: 		case STATE_2: p1State = STATE_3; break;
L_ButtonGoUp15:
	MOVLW      60
	MOVWF      _p1State+0
	GOTO       L_ButtonGoUp13
;PicPong_Project.c,182 :: 		case STATE_3: p1State = STATE_4; break;
L_ButtonGoUp16:
	MOVLW      120
	MOVWF      _p1State+0
	GOTO       L_ButtonGoUp13
;PicPong_Project.c,183 :: 		case STATE_4: p1State = STATE_5; break;
L_ButtonGoUp17:
	MOVLW      240
	MOVWF      _p1State+0
	GOTO       L_ButtonGoUp13
;PicPong_Project.c,184 :: 		case STATE_5: p1State = STATE_5; break;
L_ButtonGoUp18:
	MOVLW      240
	MOVWF      _p1State+0
	GOTO       L_ButtonGoUp13
;PicPong_Project.c,185 :: 		default:      p1State = STATE_3; break;
L_ButtonGoUp19:
	MOVLW      60
	MOVWF      _p1State+0
	GOTO       L_ButtonGoUp13
;PicPong_Project.c,186 :: 		}
L_ButtonGoUp12:
	MOVF       _p1State+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoUp14
	MOVF       _p1State+0, 0
	XORLW      30
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoUp15
	MOVF       _p1State+0, 0
	XORLW      60
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoUp16
	MOVF       _p1State+0, 0
	XORLW      120
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoUp17
	MOVF       _p1State+0, 0
	XORLW      240
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoUp18
	GOTO       L_ButtonGoUp19
L_ButtonGoUp13:
;PicPong_Project.c,187 :: 		} else {
	GOTO       L_ButtonGoUp20
L_ButtonGoUp11:
;PicPong_Project.c,188 :: 		switch (p2State) {
	GOTO       L_ButtonGoUp21
;PicPong_Project.c,189 :: 		case STATE_1: p2State = STATE_2; break;
L_ButtonGoUp23:
	MOVLW      30
	MOVWF      _p2State+0
	GOTO       L_ButtonGoUp22
;PicPong_Project.c,190 :: 		case STATE_2: p2State = STATE_3; break;
L_ButtonGoUp24:
	MOVLW      60
	MOVWF      _p2State+0
	GOTO       L_ButtonGoUp22
;PicPong_Project.c,191 :: 		case STATE_3: p2State = STATE_4; break;
L_ButtonGoUp25:
	MOVLW      120
	MOVWF      _p2State+0
	GOTO       L_ButtonGoUp22
;PicPong_Project.c,192 :: 		case STATE_4: p2State = STATE_5; break;
L_ButtonGoUp26:
	MOVLW      240
	MOVWF      _p2State+0
	GOTO       L_ButtonGoUp22
;PicPong_Project.c,193 :: 		case STATE_5: p2State = STATE_5; break;
L_ButtonGoUp27:
	MOVLW      240
	MOVWF      _p2State+0
	GOTO       L_ButtonGoUp22
;PicPong_Project.c,194 :: 		default:      p2State = STATE_3; break;
L_ButtonGoUp28:
	MOVLW      60
	MOVWF      _p2State+0
	GOTO       L_ButtonGoUp22
;PicPong_Project.c,195 :: 		}
L_ButtonGoUp21:
	MOVF       _p2State+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoUp23
	MOVF       _p2State+0, 0
	XORLW      30
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoUp24
	MOVF       _p2State+0, 0
	XORLW      60
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoUp25
	MOVF       _p2State+0, 0
	XORLW      120
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoUp26
	MOVF       _p2State+0, 0
	XORLW      240
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoUp27
	GOTO       L_ButtonGoUp28
L_ButtonGoUp22:
;PicPong_Project.c,196 :: 		}
L_ButtonGoUp20:
;PicPong_Project.c,197 :: 		}
L_end_ButtonGoUp:
	RETURN
; end of _ButtonGoUp

_ButtonGoDown:

;PicPong_Project.c,199 :: 		void ButtonGoDown(unsigned char player) {
;PicPong_Project.c,200 :: 		if (player == 1) {
	MOVF       FARG_ButtonGoDown_player+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_ButtonGoDown29
;PicPong_Project.c,201 :: 		switch (p1State) {
	GOTO       L_ButtonGoDown30
;PicPong_Project.c,202 :: 		case STATE_1: p1State = STATE_1; break;
L_ButtonGoDown32:
	MOVLW      15
	MOVWF      _p1State+0
	GOTO       L_ButtonGoDown31
;PicPong_Project.c,203 :: 		case STATE_2: p1State = STATE_1; break;
L_ButtonGoDown33:
	MOVLW      15
	MOVWF      _p1State+0
	GOTO       L_ButtonGoDown31
;PicPong_Project.c,204 :: 		case STATE_3: p1State = STATE_2; break;
L_ButtonGoDown34:
	MOVLW      30
	MOVWF      _p1State+0
	GOTO       L_ButtonGoDown31
;PicPong_Project.c,205 :: 		case STATE_4: p1State = STATE_3; break;
L_ButtonGoDown35:
	MOVLW      60
	MOVWF      _p1State+0
	GOTO       L_ButtonGoDown31
;PicPong_Project.c,206 :: 		case STATE_5: p1State = STATE_4; break;
L_ButtonGoDown36:
	MOVLW      120
	MOVWF      _p1State+0
	GOTO       L_ButtonGoDown31
;PicPong_Project.c,207 :: 		default:      p1State = STATE_3; break;
L_ButtonGoDown37:
	MOVLW      60
	MOVWF      _p1State+0
	GOTO       L_ButtonGoDown31
;PicPong_Project.c,208 :: 		}
L_ButtonGoDown30:
	MOVF       _p1State+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoDown32
	MOVF       _p1State+0, 0
	XORLW      30
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoDown33
	MOVF       _p1State+0, 0
	XORLW      60
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoDown34
	MOVF       _p1State+0, 0
	XORLW      120
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoDown35
	MOVF       _p1State+0, 0
	XORLW      240
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoDown36
	GOTO       L_ButtonGoDown37
L_ButtonGoDown31:
;PicPong_Project.c,209 :: 		} else {
	GOTO       L_ButtonGoDown38
L_ButtonGoDown29:
;PicPong_Project.c,210 :: 		switch (p2State) {
	GOTO       L_ButtonGoDown39
;PicPong_Project.c,211 :: 		case STATE_1: p2State = STATE_1; break;
L_ButtonGoDown41:
	MOVLW      15
	MOVWF      _p2State+0
	GOTO       L_ButtonGoDown40
;PicPong_Project.c,212 :: 		case STATE_2: p2State = STATE_1; break;
L_ButtonGoDown42:
	MOVLW      15
	MOVWF      _p2State+0
	GOTO       L_ButtonGoDown40
;PicPong_Project.c,213 :: 		case STATE_3: p2State = STATE_2; break;
L_ButtonGoDown43:
	MOVLW      30
	MOVWF      _p2State+0
	GOTO       L_ButtonGoDown40
;PicPong_Project.c,214 :: 		case STATE_4: p2State = STATE_3; break;
L_ButtonGoDown44:
	MOVLW      60
	MOVWF      _p2State+0
	GOTO       L_ButtonGoDown40
;PicPong_Project.c,215 :: 		case STATE_5: p2State = STATE_4; break;
L_ButtonGoDown45:
	MOVLW      120
	MOVWF      _p2State+0
	GOTO       L_ButtonGoDown40
;PicPong_Project.c,216 :: 		default:      p2State = STATE_3; break;
L_ButtonGoDown46:
	MOVLW      60
	MOVWF      _p2State+0
	GOTO       L_ButtonGoDown40
;PicPong_Project.c,217 :: 		}
L_ButtonGoDown39:
	MOVF       _p2State+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoDown41
	MOVF       _p2State+0, 0
	XORLW      30
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoDown42
	MOVF       _p2State+0, 0
	XORLW      60
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoDown43
	MOVF       _p2State+0, 0
	XORLW      120
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoDown44
	MOVF       _p2State+0, 0
	XORLW      240
	BTFSC      STATUS+0, 2
	GOTO       L_ButtonGoDown45
	GOTO       L_ButtonGoDown46
L_ButtonGoDown40:
;PicPong_Project.c,218 :: 		}
L_ButtonGoDown38:
;PicPong_Project.c,219 :: 		}
L_end_ButtonGoDown:
	RETURN
; end of _ButtonGoDown

_UpdateBallPosition:

;PicPong_Project.c,222 :: 		void UpdateBallPosition() {
;PicPong_Project.c,223 :: 		if (ballX == PLAYER2_COL) {
	MOVLW      0
	XORWF      _ballX+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__UpdateBallPosition126
	MOVLW      2
	XORWF      _ballX+0, 0
L__UpdateBallPosition126:
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition47
;PicPong_Project.c,224 :: 		if (p2State & ballYState) {
	MOVF       _ballYState+0, 0
	ANDWF      _p2State+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L_UpdateBallPosition48
;PicPong_Project.c,225 :: 		ballDirX = -ballDirX;
	MOVF       _ballDirX+0, 0
	SUBLW      0
	MOVWF      _ballDirX+0
	MOVF       _ballDirX+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       _ballDirX+1
	SUBWF      _ballDirX+1, 1
;PicPong_Project.c,226 :: 		}
L_UpdateBallPosition48:
;PicPong_Project.c,227 :: 		} else if (ballX == PLAYER1_COL) {
	GOTO       L_UpdateBallPosition49
L_UpdateBallPosition47:
	MOVLW      0
	XORWF      _ballX+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__UpdateBallPosition127
	MOVLW      7
	XORWF      _ballX+0, 0
L__UpdateBallPosition127:
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition50
;PicPong_Project.c,228 :: 		if (p1State & ballYState) {
	MOVF       _ballYState+0, 0
	ANDWF      _p1State+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L_UpdateBallPosition51
;PicPong_Project.c,229 :: 		ballDirX = -ballDirX;
	MOVF       _ballDirX+0, 0
	SUBLW      0
	MOVWF      _ballDirX+0
	MOVF       _ballDirX+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       _ballDirX+1
	SUBWF      _ballDirX+1, 1
;PicPong_Project.c,230 :: 		}
L_UpdateBallPosition51:
;PicPong_Project.c,231 :: 		}
L_UpdateBallPosition50:
L_UpdateBallPosition49:
;PicPong_Project.c,233 :: 		ballX += ballDirX;
	MOVF       _ballDirX+0, 0
	ADDWF      _ballX+0, 1
	MOVF       _ballDirX+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _ballX+1, 1
;PicPong_Project.c,235 :: 		if ((ballYState & Row0) == Row0) {
	MOVLW      1
	ANDWF      _ballYState+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition52
;PicPong_Project.c,236 :: 		ballYState = Row1;
	MOVLW      2
	MOVWF      _ballYState+0
;PicPong_Project.c,237 :: 		ballDirY = 1;
	MOVLW      1
	MOVWF      _ballDirY+0
	MOVLW      0
	MOVWF      _ballDirY+1
;PicPong_Project.c,238 :: 		} else if ((ballYState & Row1) == Row1) {
	GOTO       L_UpdateBallPosition53
L_UpdateBallPosition52:
	MOVLW      2
	ANDWF      _ballYState+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition54
;PicPong_Project.c,239 :: 		ballYState = (ballDirY == 1) ? Row2 : Row0;
	MOVLW      0
	XORWF      _ballDirY+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__UpdateBallPosition128
	MOVLW      1
	XORWF      _ballDirY+0, 0
L__UpdateBallPosition128:
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition55
	MOVLW      4
	MOVWF      ?FLOC___UpdateBallPositionT54+0
	GOTO       L_UpdateBallPosition56
L_UpdateBallPosition55:
	MOVLW      1
	MOVWF      ?FLOC___UpdateBallPositionT54+0
L_UpdateBallPosition56:
	MOVF       ?FLOC___UpdateBallPositionT54+0, 0
	MOVWF      _ballYState+0
;PicPong_Project.c,240 :: 		} else if ((ballYState & Row2) == Row2) {
	GOTO       L_UpdateBallPosition57
L_UpdateBallPosition54:
	MOVLW      4
	ANDWF      _ballYState+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition58
;PicPong_Project.c,241 :: 		ballYState = (ballDirY == 1) ? Row3 : Row1;
	MOVLW      0
	XORWF      _ballDirY+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__UpdateBallPosition129
	MOVLW      1
	XORWF      _ballDirY+0, 0
L__UpdateBallPosition129:
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition59
	MOVLW      8
	MOVWF      ?FLOC___UpdateBallPositionT58+0
	GOTO       L_UpdateBallPosition60
L_UpdateBallPosition59:
	MOVLW      2
	MOVWF      ?FLOC___UpdateBallPositionT58+0
L_UpdateBallPosition60:
	MOVF       ?FLOC___UpdateBallPositionT58+0, 0
	MOVWF      _ballYState+0
;PicPong_Project.c,242 :: 		} else if ((ballYState & Row3) == Row3) {
	GOTO       L_UpdateBallPosition61
L_UpdateBallPosition58:
	MOVLW      8
	ANDWF      _ballYState+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      8
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition62
;PicPong_Project.c,243 :: 		ballYState = (ballDirY == 1) ? Row4 : Row2;
	MOVLW      0
	XORWF      _ballDirY+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__UpdateBallPosition130
	MOVLW      1
	XORWF      _ballDirY+0, 0
L__UpdateBallPosition130:
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition63
	MOVLW      16
	MOVWF      ?FLOC___UpdateBallPositionT62+0
	GOTO       L_UpdateBallPosition64
L_UpdateBallPosition63:
	MOVLW      4
	MOVWF      ?FLOC___UpdateBallPositionT62+0
L_UpdateBallPosition64:
	MOVF       ?FLOC___UpdateBallPositionT62+0, 0
	MOVWF      _ballYState+0
;PicPong_Project.c,244 :: 		} else if ((ballYState & Row4) == Row4) {
	GOTO       L_UpdateBallPosition65
L_UpdateBallPosition62:
	MOVLW      16
	ANDWF      _ballYState+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      16
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition66
;PicPong_Project.c,245 :: 		ballYState = (ballDirY == 1) ? Row5 : Row3;
	MOVLW      0
	XORWF      _ballDirY+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__UpdateBallPosition131
	MOVLW      1
	XORWF      _ballDirY+0, 0
L__UpdateBallPosition131:
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition67
	MOVLW      32
	MOVWF      ?FLOC___UpdateBallPositionT66+0
	GOTO       L_UpdateBallPosition68
L_UpdateBallPosition67:
	MOVLW      8
	MOVWF      ?FLOC___UpdateBallPositionT66+0
L_UpdateBallPosition68:
	MOVF       ?FLOC___UpdateBallPositionT66+0, 0
	MOVWF      _ballYState+0
;PicPong_Project.c,246 :: 		} else if ((ballYState & Row5) == Row5) {
	GOTO       L_UpdateBallPosition69
L_UpdateBallPosition66:
	MOVLW      32
	ANDWF      _ballYState+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition70
;PicPong_Project.c,247 :: 		ballYState = (ballDirY == 1) ? Row6 : Row4;
	MOVLW      0
	XORWF      _ballDirY+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__UpdateBallPosition132
	MOVLW      1
	XORWF      _ballDirY+0, 0
L__UpdateBallPosition132:
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition71
	MOVLW      64
	MOVWF      ?FLOC___UpdateBallPositionT70+0
	GOTO       L_UpdateBallPosition72
L_UpdateBallPosition71:
	MOVLW      16
	MOVWF      ?FLOC___UpdateBallPositionT70+0
L_UpdateBallPosition72:
	MOVF       ?FLOC___UpdateBallPositionT70+0, 0
	MOVWF      _ballYState+0
;PicPong_Project.c,248 :: 		} else if ((ballYState & Row6) == Row6) {
	GOTO       L_UpdateBallPosition73
L_UpdateBallPosition70:
	MOVLW      64
	ANDWF      _ballYState+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      64
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition74
;PicPong_Project.c,249 :: 		ballYState = (ballDirY == 1) ? Row7 : Row5;
	MOVLW      0
	XORWF      _ballDirY+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__UpdateBallPosition133
	MOVLW      1
	XORWF      _ballDirY+0, 0
L__UpdateBallPosition133:
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition75
	MOVLW      128
	MOVWF      ?FLOC___UpdateBallPositionT74+0
	GOTO       L_UpdateBallPosition76
L_UpdateBallPosition75:
	MOVLW      32
	MOVWF      ?FLOC___UpdateBallPositionT74+0
L_UpdateBallPosition76:
	MOVF       ?FLOC___UpdateBallPositionT74+0, 0
	MOVWF      _ballYState+0
;PicPong_Project.c,250 :: 		} else if ((ballYState & Row7) == Row7) {
	GOTO       L_UpdateBallPosition77
L_UpdateBallPosition74:
	MOVLW      128
	ANDWF      _ballYState+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      128
	BTFSS      STATUS+0, 2
	GOTO       L_UpdateBallPosition78
;PicPong_Project.c,251 :: 		ballYState = Row6;
	MOVLW      64
	MOVWF      _ballYState+0
;PicPong_Project.c,252 :: 		ballDirY = -1;
	MOVLW      255
	MOVWF      _ballDirY+0
	MOVLW      255
	MOVWF      _ballDirY+1
;PicPong_Project.c,253 :: 		}
L_UpdateBallPosition78:
L_UpdateBallPosition77:
L_UpdateBallPosition73:
L_UpdateBallPosition69:
L_UpdateBallPosition65:
L_UpdateBallPosition61:
L_UpdateBallPosition57:
L_UpdateBallPosition53:
;PicPong_Project.c,255 :: 		if ((ballX == 1) || (ballX == 8)) {
	MOVLW      0
	XORWF      _ballX+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__UpdateBallPosition134
	MOVLW      1
	XORWF      _ballX+0, 0
L__UpdateBallPosition134:
	BTFSC      STATUS+0, 2
	GOTO       L__UpdateBallPosition103
	MOVLW      0
	XORWF      _ballX+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__UpdateBallPosition135
	MOVLW      8
	XORWF      _ballX+0, 0
L__UpdateBallPosition135:
	BTFSC      STATUS+0, 2
	GOTO       L__UpdateBallPosition103
	GOTO       L_UpdateBallPosition81
L__UpdateBallPosition103:
;PicPong_Project.c,256 :: 		isScore = true;
	MOVLW      1
	MOVWF      _isScore+0
;PicPong_Project.c,257 :: 		}
L_UpdateBallPosition81:
;PicPong_Project.c,259 :: 		RenderFrame();
	CALL       _RenderFrame+0
;PicPong_Project.c,260 :: 		}
L_end_UpdateBallPosition:
	RETURN
; end of _UpdateBallPosition

_main:

;PicPong_Project.c,263 :: 		void main() {
;PicPong_Project.c,267 :: 		TRISB = 0xFF;
	MOVLW      255
	MOVWF      TRISB+0
;PicPong_Project.c,268 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;PicPong_Project.c,269 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;PicPong_Project.c,270 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;PicPong_Project.c,272 :: 		OPTION_REG |= 0x80;   // disable PORTB pull-ups
	BSF        OPTION_REG+0, 7
;PicPong_Project.c,274 :: 		MAX7219_Init();
	CALL       _MAX7219_Init+0
;PicPong_Project.c,275 :: 		MAX7219_Config();
	CALL       _MAX7219_Config+0
;PicPong_Project.c,277 :: 		while (1) {
L_main82:
;PicPong_Project.c,278 :: 		InitGame();
	CALL       _InitGame+0
;PicPong_Project.c,280 :: 		while (!isScore) {
L_main84:
	MOVF       _isScore+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main85
;PicPong_Project.c,281 :: 		elapsed = 0;
	CLRF       main_elapsed_L0+0
	CLRF       main_elapsed_L0+1
;PicPong_Project.c,282 :: 		UpdateBallPosition();
	CALL       _UpdateBallPosition+0
;PicPong_Project.c,284 :: 		while (elapsed < FRAME_DELAY_MS) {
L_main86:
	MOVLW      3
	SUBWF      main_elapsed_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main137
	MOVLW      232
	SUBWF      main_elapsed_L0+0, 0
L__main137:
	BTFSC      STATUS+0, 0
	GOTO       L_main87
;PicPong_Project.c,285 :: 		b0 = ReadButton0();
	CALL       _ReadButton0+0
	MOVF       R0+0, 0
	MOVWF      main_b0_L0+0
;PicPong_Project.c,286 :: 		b1 = ReadButton1();
	CALL       _ReadButton1+0
	MOVF       R0+0, 0
	MOVWF      main_b1_L0+0
;PicPong_Project.c,287 :: 		b2 = ReadButton2();
	CALL       _ReadButton2+0
	MOVF       R0+0, 0
	MOVWF      main_b2_L0+0
;PicPong_Project.c,288 :: 		b3 = ReadButton3();
	CALL       _ReadButton3+0
	MOVF       R0+0, 0
	MOVWF      main_b3_L0+0
;PicPong_Project.c,290 :: 		if (b0 && !prevB0) {
	MOVF       main_b0_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main90
	MOVF       _prevB0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main90
L__main107:
;PicPong_Project.c,291 :: 		ButtonGoUp(1);
	MOVLW      1
	MOVWF      FARG_ButtonGoUp_player+0
	CALL       _ButtonGoUp+0
;PicPong_Project.c,292 :: 		RenderFrame();
	CALL       _RenderFrame+0
;PicPong_Project.c,293 :: 		}
L_main90:
;PicPong_Project.c,294 :: 		if (b1 && !prevB1) {
	MOVF       main_b1_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main93
	MOVF       _prevB1+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main93
L__main106:
;PicPong_Project.c,295 :: 		ButtonGoDown(1);
	MOVLW      1
	MOVWF      FARG_ButtonGoDown_player+0
	CALL       _ButtonGoDown+0
;PicPong_Project.c,296 :: 		RenderFrame();
	CALL       _RenderFrame+0
;PicPong_Project.c,297 :: 		}
L_main93:
;PicPong_Project.c,298 :: 		if (b2 && !prevB2) {
	MOVF       main_b2_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main96
	MOVF       _prevB2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main96
L__main105:
;PicPong_Project.c,299 :: 		ButtonGoUp(2);
	MOVLW      2
	MOVWF      FARG_ButtonGoUp_player+0
	CALL       _ButtonGoUp+0
;PicPong_Project.c,300 :: 		RenderFrame();
	CALL       _RenderFrame+0
;PicPong_Project.c,301 :: 		}
L_main96:
;PicPong_Project.c,302 :: 		if (b3 && !prevB3) {
	MOVF       main_b3_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main99
	MOVF       _prevB3+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main99
L__main104:
;PicPong_Project.c,303 :: 		ButtonGoDown(2);
	MOVLW      2
	MOVWF      FARG_ButtonGoDown_player+0
	CALL       _ButtonGoDown+0
;PicPong_Project.c,304 :: 		RenderFrame();
	CALL       _RenderFrame+0
;PicPong_Project.c,305 :: 		}
L_main99:
;PicPong_Project.c,307 :: 		prevB0 = b0;
	MOVF       main_b0_L0+0, 0
	MOVWF      _prevB0+0
;PicPong_Project.c,308 :: 		prevB1 = b1;
	MOVF       main_b1_L0+0, 0
	MOVWF      _prevB1+0
;PicPong_Project.c,309 :: 		prevB2 = b2;
	MOVF       main_b2_L0+0, 0
	MOVWF      _prevB2+0
;PicPong_Project.c,310 :: 		prevB3 = b3;
	MOVF       main_b3_L0+0, 0
	MOVWF      _prevB3+0
;PicPong_Project.c,312 :: 		Delay_ms(DEBOUNCE_DELAY_MS);
	MOVLW      21
	MOVWF      R12+0
	MOVLW      198
	MOVWF      R13+0
L_main100:
	DECFSZ     R13+0, 1
	GOTO       L_main100
	DECFSZ     R12+0, 1
	GOTO       L_main100
	NOP
;PicPong_Project.c,313 :: 		elapsed += DEBOUNCE_DELAY_MS;
	MOVLW      8
	ADDWF      main_elapsed_L0+0, 1
	BTFSC      STATUS+0, 0
	INCF       main_elapsed_L0+1, 1
;PicPong_Project.c,314 :: 		}
	GOTO       L_main86
L_main87:
;PicPong_Project.c,315 :: 		}
	GOTO       L_main84
L_main85:
;PicPong_Project.c,317 :: 		Delay_ms(250);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main101:
	DECFSZ     R13+0, 1
	GOTO       L_main101
	DECFSZ     R12+0, 1
	GOTO       L_main101
	DECFSZ     R11+0, 1
	GOTO       L_main101
	NOP
	NOP
;PicPong_Project.c,318 :: 		}
	GOTO       L_main82
;PicPong_Project.c,319 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
