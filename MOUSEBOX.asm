CURSOR MACRO ROW,COLUMN
       MOV AH,02H
       MOV BH,00
       MOV DH,ROW
       MOV DL,COLUMN  ;设置光标位置
       INT 10H
       ENDM
DISPLAY MACRO STRING
       MOV AH,09H
       MOV DX,OFFSET STRING  ;装入字符串地址
       INT 21H
       ENDM
FILL MACRO ROW_START,COL_START,ROW_END,COL_END,COLOR
       LOCAL START1,AGAIN
       MOV DX,ROW_START
START1:
       MOV CX,COL_START
AGAIN:
       MOV AH,0CH
       MOV AL,COLOR   ;写像素，AL中存放像素值
       INT 10H
       INC CX
       CMP CX,COL_END ;画一条水平线
       JNE AGAIN
       INC DX
       CMP DX,ROW_END ;增加行值画水平线，以此画出矩形
       JNE START1
       ENDM

MACRO CLEARSRC 
    MOV AX,0600H           ;清除屏幕
    MOV BH,07
    MOV CX,0
    MOV DX,184FH
    INT 10H
    ENDM      

MACRO FRAME ROW_START,COL_START,ROW_END,COL_END,COLOR
      LOCAL ROWCOL1,ROWCOL2,ROWCOL3,ROWCOL4
      MOV DX,ROW_START
      MOV CX,COL_START
ROWCOL1:
      MOV AH,0CH
      MOV AL,COLOR
      INT 10H
      INC CX
      CMP CX,COL_END
      JNE ROWCOL1
      
      MOV CX,COL_START
ROWCOL2:
      MOV AH,0CH
      MOV AL,COLOR
      INT 10H
      INC DX
      CMP DX,ROW_END
      JNE ROWCOL2
      
      MOV DX,ROW_END
      MOV CX,COL_START
ROWCOL3:
      MOV AH,0CH
      MOV AL,COLOR
      INT 10H
      INC CX
      CMP CX,COL_END
      JNE ROWCOL3
      
      MOV DX,ROW_START
      MOV CX,COL_END
ROWCOL4:
      MOV AH,0CH
      MOV AL,COLOR
      INT 10H
      INC DX
      CMP DX,ROL_END
      JNE ROWCOL4       
      
      ENDM
             

DATAS SEGMENT
    ;此处输入数据段代码 
MESSAGE_1 DB 'Welcome!','$'
MESSAGE_2 DB 'ENTER','$'
MESSAGE_3 DB 'MODEL1','$'
MESSAGE_4 DB 'MODEL2','$'
MESSAGE_5 DB 'MODEL3','$'
MESSAGE_6 DB 'MODEL4','$'
MESSAGE_7 DB 'EXIT','$'
MESSAGE_8 DB 'PRESS ENTER TO ENTER','$'
OLDVIDEO  DB ?
NEWVIDEO  DB 12H
WHEATHERIN DB ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
MAIN PROC 
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
FIRST:
    MOV CX,33144
    CALL TDELAY            ;此处延迟十分重要！！调试时没有这个延迟导致页面生成不对
    MOV AH,0FH
    INT 10H                ;获得当前视频模式
    MOV OLDVIDEO,AL        ;保存当前视频模式
    MOV AX,0600H           ;清除屏幕
    MOV BH,07
    MOV CX,0
    MOV DX,184FH
    INT 10H
    MOV AH,00H             ;设置新的视频模式
    MOV AL,NEWVIDEO
    INT 10H
    CURSOR 0,0             ;设置光标在0,0
    FILL 150,250,250,350,4 ;在150,250处画一个红框
    CURSOR 6,194     
    DISPLAY MESSAGE_1
    CURSOR 8,27
    DISPLAY MESSAGE_8
    CURSOR 12,195
    DISPLAY MESSAGE_2
    MOV AX,0000H     ;初始化鼠标
    INT 33H
    MOV AX,01H
    INT 33H          ;检查鼠标光标
BACK:
    MOV AX,03H       ;检查是否按下鼠标
    INT 33H
    CMP BX,0001H     ;现在在cx=列dx=行的位置
    JNE BACK         ;检查左键是否按下
    CMP CX,250       ;看是否在框的右边
    JB NOT_INSIDE
    CMP CX,350
    JA NOT_INSIDE
    CMP DX,150
    JB NOT_INSIDE
    CMP DX,250
    JA NOT_INSIDE     ;检查是否在框中

SECONDPAINT:        
    MOV AX,0600H           ;清除屏幕
    MOV BH,07
    MOV CX,0
    MOV DX,184FH
    INT 10H
    
    MOV AH,00H              ;设置新的视频模式
    MOV AL,NEWVIDEO
    INT 10H
    
    CURSOR 0,0
    FILL 30,50,80,200,4
    CURSOR 3,12
    DISPLAY MESSAGE_3
    FILL 110,50,160,200,4
    CURSOR 8,12
    DISPLAY MESSAGE_4
    FILL 190,50,240,200,4
    CURSOR 13,12
    DISPLAY MESSAGE_5
    FILL 270,50,320,200,4
    CURSOR 18,12
    DISPLAY MESSAGE_6
    FILL 400,500,450,600,4
    CURSOR 26,67
    DISPLAY MESSAGE_7
    
    MOV AX,0000H
    INT 33H                  ;初始化鼠标
    MOV AX,01H
    INT 33H     
BACK2:
    MOV AX,03H                ;检查鼠标
    INT 33H
    CMP BX,0001H
    JNE BACK2
    CMP CX,50
    JB  MODEL2
    CMP DX,30
    JB  MODEL2
    CMP CX,200
    JA  MODEL2
    CMP DX,80
    JA  MODEL2           ;判断是否在模块一中
    CALL MODEL1
MODEL2:   
    CMP CX,50
    JB  MODEL3
    CMP DX,110
    JB  MODEL3
    CMP CX,200
    JA  MODEL3
    CMP DX,160
    JA  MODEL3
    ;CALL MODEL2               ;判断是否在模块2
MODEL3:    
    CMP CX,50
    JB  MODEL4
    CMP DX,190
    JB  MODEL4
    CMP CX,200
    JA  MODEL4
    CMP DX,240
    JA  MODEL4
    ;CALL MODEL3                ;判断是否在模块3中
MODEL4:    
    CMP CX,50
    JB  EXITMAIN
    CMP DX,270
    JB  EXITMAIN
    CMP CX,200
    JA  EXITMAIN
    CMP DX,320
    JA  EXITMAIN
    ;CALL MODEL4                 ;判断是否在模块4中
EXITMAIN:   
    CMP CX,500
    JB  NOT_INSIDE2
    CMP DX,400
    JB  NOT_INSIDE2
    CMP CX,600
    JA  NOT_INSIDE2
    CMP DX,450
    JA  NOT_INSIDE2
    JMP FIRST

NOT_INSIDE:
    JMP BACK
    
NOT_INSIDE2:
   
    MOV AH,4CH
    INT 21H
MAIN ENDP

TDELAY PROC NEAR
     PUSH AX
W1:  
     IN  AL,61H
     AND AL,00010000B
     CMP AL,AH
     JE  W1
     MOV AH,AL
     LOOP W1
     POP AX
     RET
TDELAY ENDP


MODEL1 PROC NEAR
     
     CLEARP               ;清除屏幕
     MOV AH,00            ;设置视频模式
     MOV AL,NEWVIDEO
     INT 10H
     
     
   

MODEL1 ENDP



CODES ENDS
    END START



