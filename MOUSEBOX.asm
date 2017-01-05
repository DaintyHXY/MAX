CURSOR MACRO ROW,COLUMN
       MOV AH,02H
       MOV BH,00
       MOV DH,ROW
       MOV DL,COLUMN  ;���ù��λ��
       INT 10H
       ENDM
DISPLAY MACRO STRING
       MOV AH,09H
       MOV DX,OFFSET STRING  ;װ���ַ�����ַ
       INT 21H
       ENDM
FILL MACRO ROW_START,COL_START,ROW_END,COL_END,COLOR
       LOCAL START1,AGAIN
       MOV DX,ROW_START
START1:
       MOV CX,COL_START
AGAIN:
       MOV AH,0CH
       MOV AL,COLOR   ;д���أ�AL�д������ֵ
       INT 10H
       INC CX
       CMP CX,COL_END ;��һ��ˮƽ��
       JNE AGAIN
       INC DX
       CMP DX,ROW_END ;������ֵ��ˮƽ�ߣ��Դ˻�������
       JNE START1
       ENDM

CLEARSRC MACRO
    MOV AX,0600H           ;�����Ļ
    MOV BH,07
    MOV CX,0
    MOV DX,184FH
    INT 10H
    ENDM      

FRAME MACRO ROW_START,COL_START,ROW_END,COL_END,COLOR ;�������ο�
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
      CMP DX,ROW_END
      JNE ROWCOL4       
      
      ENDM

FILEWORD MACRO DATA1
      MOV BX,OFFSET DATA1
      SUB CH,CH
      MOV CL,[BX]+1
      MOV WORDS,CX
      ENDM
             

DATAS SEGMENT
    ;�˴��������ݶδ��� 
CR EQU 0DH
LF EQU 0AH    
    
MESSAGE_1 DB 'Welcome!','$'
MESSAGE_2 DB 'ENTER','$'
MESSAGE_3 DB 'NEWMEMO','$'
MESSAGE_4 DB 'MODEL2','$'
MESSAGE_5 DB 'MODEL3','$'
MESSAGE_6 DB 'MODEL4','$'
MESSAGE_7 DB 'EXIT','$'
MESSAGE_8 DB 'PRESS ENTER TO ENTER','$'
OLDVIDEO  DB ?
NEWVIDEO  DB 12H
WHEATHERIN DB ?

TITLETEXT DB 'TITLE:','$'
CONTEXTTEXT DB 'CONTEXT:','$'
SAVETEXT DB 'SAVE','$'
BACKTEXT DB 'BACK','$'
SMESSAGE DB 'SUCCESS!','$'
TITLEMESSAGE DB 'PLEASE ENTER THE NAME OF FILE','$'
CONTEXTMESSAGE DB 'PLEASE ENTER THE CONTENT','$'
INFORMATION DB 'INFO:','$'
ADDRESS DB 10,?,10 DUP(0FFH)
BUF     DB 100,?,100 DUP(0FFH)
MEMONAME DB 100,?,100 DUP(0FFH)
MEMOCOUNT DB 00
MEMONUMBER   DB ?
LISTROW  EQU 30
LISTEND  EQU 90

LONG DB ?
HANDLE DW ?
WORDS  DW ?
ERRORTIMES DB 0
ERRORMESSAGE DB 'ERROR!PLEASE TRY AGAIN!','$'

DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
MAIN PROC 
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
FIRST:
    MOV CX,33144
    CALL TDELAY            ;�˴��ӳ�ʮ����Ҫ��������ʱû������ӳٵ���ҳ�����ɲ���
    MOV AH,0FH
    INT 10H                ;��õ�ǰ��Ƶģʽ
    MOV OLDVIDEO,AL        ;���浱ǰ��Ƶģʽ
    MOV AX,0600H           ;�����Ļ
    MOV BH,07
    MOV CX,0
    MOV DX,184FH
    INT 10H
    MOV AH,00H             ;�����µ���Ƶģʽ
    MOV AL,NEWVIDEO
    INT 10H
    CURSOR 0,0             ;���ù����0,0
    FILL 150,250,250,350,4 ;��150,250����һ�����
    CURSOR 6,194     
    DISPLAY MESSAGE_1
    CURSOR 8,27
    DISPLAY MESSAGE_8
    CURSOR 12,195
    DISPLAY MESSAGE_2
    MOV AX,0000H     ;��ʼ�����
    INT 33H
    MOV AX,01H
    INT 33H          ;��������
BACK:
    MOV AX,03H       ;����Ƿ������
    INT 33H
    CMP BX,0001H     ;������cx=��dx=�е�λ��
    JNE BACK         ;�������Ƿ���
    CMP CX,250       ;���Ƿ��ڿ���ұ�
    JB NOT_INSIDE
    CMP CX,350
    JA NOT_INSIDE
    CMP DX,150
    JB NOT_INSIDE
    CMP DX,250
    JA NOT_INSIDE     ;����Ƿ��ڿ���

SECONDPAINT:        
    MOV AX,0600H           ;�����Ļ
    MOV BH,07
    MOV CX,0
    MOV DX,184FH
    INT 10H
    
    MOV AH,00H              ;�����µ���Ƶģʽ
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
    
    ;����¼�б����
MEMOLIST:
    SUB AX,AX
    MOV AL,MEMOCOUNT
    CMP AL,0
    JE  SECONDBEGIN
    FRAME 30,300,300,600,4
    
    ;MOV CX,2
    MOV AL,3
    MOV BL,40
    MOV CL,MEMOCOUNT
LISTLOOP:
    MOV AH,02H
    MOV BH,00
    MOV DH,AL
    MOV DL,BL  ;���ù��λ��
    INT 10H
    DISPLAY SMESSAGE
    ADD AL,2
    DEC CX
    CMP CX,0
    JNE LISTLOOP
    
 
    
    
SECONDBEGIN:    
    MOV AX,0000H
    INT 33H                  ;��ʼ�����
    MOV AX,01H
    INT 33H     
BACK2:
    MOV AX,03H                ;������
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
    JA  MODEL2           ;�ж��Ƿ���ģ��һ��
    CLEARSRC
    MOV CX,33144
    CALL TDELAY
    JMP MODEL1
    ;JMP SECONDPAINT
MODEL2:   
    CMP CX,50
    JB  MODEL3
    CMP DX,110
    JB  MODEL3
    CMP CX,200
    JA  MODEL3
    CMP DX,160
    JA  MODEL3
    ;CALL MODEL2               ;�ж��Ƿ���ģ��2
MODEL3:    
    CMP CX,50
    JB  MODEL4
    CMP DX,190
    JB  MODEL4
    CMP CX,200
    JA  MODEL4
    CMP DX,240
    JA  MODEL4
    ;CALL MODEL3                ;�ж��Ƿ���ģ��3��
MODEL4:    
    CMP CX,50
    JB  EXITMAIN
    CMP DX,270
    JB  EXITMAIN
    CMP CX,200
    JA  EXITMAIN
    CMP DX,320
    JA  EXITMAIN
    ;CALL MODEL4                 ;�ж��Ƿ���ģ��4��
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
    
 
    MODEL1:
     
     CLEARSRC               ;�����Ļ
     MOV AH,00            ;������Ƶģʽ
     MOV AL,NEWVIDEO
     INT 10H
     
     CURSOR 0,0
     FRAME 70,130,110,550,4
     FRAME 150,130,400,550,4
     FRAME 420,150,450,250,4
     FRAME 420,430,450,530,4
     
     CURSOR 5,10
     DISPLAY TITLETEXT
     CURSOR 10,8
     DISPLAY CONTEXTTEXT
     CURSOR 8,70
     DISPLAY INFORMATION
     CURSOR 27,23
     DISPLAY SAVETEXT
     CURSOR 27,58
     DISPLAY BACKTEXT
     
     CURSOR 0,0
     MOV AX,0000H      ;��ʼ�����
     INT 33H
     
NEWBACK:
     MOV AX,01H
     INT 33H           ;��������
     MOV AX,03H        ;����Ƿ������
     INT 33H
     CMP BX,0001H      ;������cx=��dx=�е�λ��
     JNE NEWBACK       ;�������Ƿ���
     CMP DX,70
     JB  NEWBACK2
     CMP DX,110
     JA  NEWBACK2
     CMP CX,130
     JB  NEWBACK2
     CMP CX,550
     JA  NEWBACK2
     
     CURSOR 3,16
     DISPLAY TITLEMESSAGE
     ;��ȡ����
     CURSOR 5,18
     MOV AH,0AH
     MOV DX,OFFSET ADDRESS
     INT 21H                  
     ;�����뻺�����е�0DH��Ϊ00H
     FILEWORD ADDRESS
     SUB CH,CH
     MOV SI,CX
     MOV BYTE PTR[BX+SI]+2,00
     ;��ȡ�ļ�����00�������½��ļ�
     MOV DX,OFFSET ADDRESS
     INC DX
     INC DX
     MOV CX,0
     MOV AH,3CH
     INT 21H
     JC  ERROR
     MOV ERRORTIMES,0
     MOV HANDLE,AX
     JMP NEWBACK
          
NEWBACK2:     
     CMP DX,150
     JB  NEWBACK3
     CMP DX,400
     JA  NEWBACK3
     CMP CX,130
     JB  NEWBACK3
     CMP CX,550
     JA  NEWBACK3
     
     CURSOR 8,16
     DISPLAY CONTEXTMESSAGE
     ;�����ļ�����
     CURSOR 10,18
     MOV AH,0AH
     MOV DX,OFFSET BUF
     INT 21H
     
     ;��ȡ������������
     FILEWORD BUF
     MOV BX,HANDLE
     MOV CX,WORDS
     MOV DX,OFFSET BUF
     INC DX
     INC DX
     MOV AH,40H
     INT 21H
     JC ERROR
     MOV ERRORTIMES,0
     ;�ر��ļ�
     MOV BX,HANDLE
     MOV AH,3EH
     INT 21H
     JC ERROR
     JMP NEWBACK

NEWBACK3:     
     CMP DX,420
     JB  NEWBACK4
     CMP DX,450
     JA  NEWBACK4
     CMP CX,150
     JB  NEWBACK4
     CMP CX,250
     JA  NEWBACK4
     CMP ERRORTIMES,0
     JA  ERRORM
     CURSOR 10,70
     DISPLAY SMESSAGE
     JMP NEWBACK4
ERROR:
     INC ERRORTIMES
     JMP NEWBACK     
ERRORM:
     CURSOR 10,70
     DISPLAY ERRORMESSAGE

NEWNEXT:
     MOV CX,33144
     CALL TDELAY
     MOV AX,0600H
     MOV BH,0
     MOV CX,2020H
     MOV DX,2330H
     INT 10H
     JMP NEWBACK
     
     
     
NEWBACK4:
     CMP DX,420
     JB  NEWBACK
     CMP DX,450
     JA  NEWBACK
     CMP CX,430
     JB  NEWBACK
     CMP CX,530
     JA  NEWBACK
     JMP SECONDPAINT
     
     

        
     
     
    

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






CODES ENDS
    END START












