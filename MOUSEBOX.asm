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
MESSAGE_4 DB 'CHECK','$'
MESSAGE_5 DB 'DELETE','$'
MESSAGE_6 DB 'MODIFY','$'
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
MEMONAME DB 100 DUP('$')
MEMOCOUNT DB 00
NUMBER DB ?
COUNTLIST DB 100 DUP(00H)
LISTROW  EQU 30
LISTEND  EQU 90

NAMESTART DB 0
NAMEEND   DB 0
NAMEROW   DB 0
NAMECOUNT DB 0
COUNTSTART DB 0
COUNTEND   DB 0


LONG DB ?
HANDLE DW ?
WORDS  DW ?
ERRORTIMES DB 0
ERRORMESSAGE DB 'ERROR!PLEASE TRY AGAIN!','$'

LISTNUMBER DB ?
CHOOSEROW  DW ?
CHECKROW   DW ?
NOWNAME    DB ?
NAMEALL    DB 0
NAMESINGLE DB ?
NAMESUB    DB 50 DUP(00);��ʱ�洢�ļ���

MODIFYBUF  DB 255,?,255 DUP(00)
MODIFYBUF2 DB 'TEST!'
MODIFYWORD DB ?

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
    
    
    ;FRAME 30,300,80,600,4
    ;FRAME 80,300,130,600,4
    ;FRAME 130,300,180,600,4
    ;FRAME 180,300,230,600,4
    CALL MEMOLIST  
     
    
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
    CALL MODEL1
    JMP SECONDPAINT
MODEL2:   
    CMP CX,50
    JB  MODEL3
    CMP DX,110
    JB  MODEL3
    CMP CX,200
    JA  MODEL3
    CMP DX,160
    JA  MODEL3
    ;CLEARSRC
    MOV CX,33144
    CALL TDELAY
    CALL CHECKPRO               ;�ж��Ƿ���ģ��2
    JMP SECONDPAINT
    
MODEL3:    
    CMP CX,50
    JB  MODEL4
    CMP DX,190
    JB  MODEL4
    CMP CX,200
    JA  MODEL4
    CMP DX,240
    JA  MODEL4
    MOV CX,33144
    CALL TDELAY
    CALL DELETEPRO                ;�ж��Ƿ���ģ��3��
    JMP SECONDPAINT
MODEL4:    
    CMP CX,50
    JB  EXITMAIN
    CMP DX,270
    JB  EXITMAIN
    CMP CX,200
    JA  EXITMAIN
    CMP DX,320
    JA  EXITMAIN
    MOV CX,33144
    CALL TDELAY
    CALL MODIFYPRO                 ;�ж��Ƿ���ģ��4��
    JMP SECONDPAINT
EXITMAIN:   
    CMP CX,500
    JB  NOT_INSIDE2
    CMP DX,400
    JB  NOT_INSIDE2
    CMP CX,600
    JA  NOT_INSIDE2
    CMP DX,450
    JA  NOT_INSIDE2
    ;CLEARSRC
    ;MOV CX,33144
    ;CALL TDELAY
    ;JMP FIRST
    
 
        

NOT_INSIDE:
    JMP SECONDPAINT
    
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

;----------------------------------����¼�б����------------------------------------
MEMOLIST PROC NEAR
    SUB AX,AX
    MOV AL,MEMOCOUNT
    CMP AL,0
    JE  ENDLIST
    FRAME 30,300,300,600,4
    
    MOV AL,3
    MOV NAMEROW,AL
    MOV BL,40
    SUB CX,CX
    MOV CL,MEMOCOUNT
    MOV NAMECOUNT,CL
    SUB AX,AX
    MOV AL,NAMESTART
    MOV COUNTSTART,AL
    MOV SI,OFFSET COUNTLIST
LISTLOOP:
    MOV AH,02H
    MOV BH,00
    MOV DH,NAMEROW
    MOV DL,40  ;���ù��λ��
    INT 10H
    
    ;��ʾ���б���¼����
    ;DISPLAY SMESSAGE
PRINTNAMEFIRST:
    MOV BL,NAMECOUNT
    SUB BH,BH
    MOV BH,BYTE PTR[SI+BX];ȡ�����ֵĳ���
    MOV AH,COUNTSTART;ȡ��������һ���ֵĿ�ʼ��
    DEC AH
    SUB AH,BH
    MOV COUNTSTART,AH
    
    MOV AH,09H
    MOV DX,OFFSET MEMONAME
    ADD DL,COUNTSTART
    SUB BX,BX
    MOV BX,DX
    CMP BYTE PTR[BX],'$'
    JNE PRINTNAME
    MOV BL,NAMECOUNT
    DEC BL
    MOV NAMECOUNT,BL
    DEC CX
    CMP CX,0
    JBE ENDLIST
    JMP PRINTNAMEFIRST
    
PRINTNAME:    
    INT 21H
    
    MOV BL,NAMECOUNT
    DEC BL
    MOV NAMECOUNT,BL
    
    MOV AL,NAMEROW
    ADD AL,3
    MOV NAMEROW,AL
    DEC CX
    CMP CX,0
    JNE LISTLOOP
ENDLIST:
    MOV CX,33144
    CALL TDELAY
    RET
    MEMOLIST ENDP

;----------------------------------------�½�MEMO����-------------------------------
MODEL1 PROC NEAR
     
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
     CURSOR 0,0
     MOV AX,04H
     MOV CX,0
     MOV DX,0
     INT 33H
NEWBACK:
     MOV AX,01H
     INT 33H           ;��������
     MOV AX,03H        ;����Ƿ������
     INT 33H
     CMP BX,0001H      ;������cx=��dx=�е�λ��
     JNE NEWBACK       ;�������Ƿ���
     CMP DX,70
     JB  CONTENTLP
     CMP DX,110
     JA  CONTENTLP
     CMP CX,130
     JB  CONTENTLP
     CMP CX,550
     JA  CONTENTLP

TITLELP:     
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
     
     ;��������MEMO��Ŀ
     SUB AX,AX
     MOV AH,MEMOCOUNT
     INC AH
     MOV MEMOCOUNT,AH
     
     ;���ļ�������MEMONAME��
     MOV DI,OFFSET ADDRESS
     INC DI
     SUB CX,CX
     MOV CL,[DI]
     MOV NUMBER,CL
     INC DI
     MOV SI,OFFSET MEMONAME
     SUB BX,BX
     MOV BL,NAMESTART
NAMELOOP:         
     MOV AL,[DI]
     MOV [SI+BX],AL
     INC DI
     INC SI
     DEC CX
     CMP CX,0
     JNE NAMELOOP
     
     
     ;���ļ������ȴ���COUNTLIST
     SUB BX,BX
     MOV SI,OFFSET COUNTLIST
     MOV BL,MEMOCOUNT
     MOV AL,NUMBER
     MOV BYTE PTR[SI+BX],AL
     
     SUB BX,BX
     MOV SI,OFFSET COUNTLIST
     MOV BL,MEMOCOUNT
     MOV BH,BYTE PTR[SI+BX] ;���COUNTLIST[MEMOCOUNT]
     ADD BH,NAMESTART
     MOV NAMEEND,BH;�����ǰMEMONAME�Ľ�����
     ADD BH,1
     MOV NAMESTART,BH;�����һ��MEMONAME�Ŀ�ʼ��
     
     JMP NEWBACK
          
CONTENTLP:     
     CMP DX,150
     JB  SAVELP
     CMP DX,400
     JA  SAVELP
     CMP CX,130
     JB  SAVELP
     CMP CX,550
     JA  SAVELP
     
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

SAVELP: 

     CMP DX,420
     JB  BACKLP
     CMP DX,450
     JA  BACKLP
     CMP CX,150
     JB  BACKLP
     CMP CX,250
     JA  BACKLP    
     CMP ERRORTIMES,0
     JA  ERRORM
     CURSOR 10,70
     DISPLAY SMESSAGE
     JMP NEWBACK
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
     
     
     
BACKLP:
     CMP DX,420
     JB  NEWBACK
     CMP DX,450
     JA  NEWBACK
     CMP CX,430
     JB  NEWBACK
     CMP CX,530
     JA  NEWBACK
     CLEARSRC
     
     RET
MODEL1 ENDP
;---------------------------�����б�鿴��������------------------------
CHECKPRO PROC NEAR

     MOV AH,00            ;������Ƶģʽ
     MOV AL,NEWVIDEO
     INT 10H

     CURSOR 27,58
     DISPLAY BACKTEXT
     FRAME 420,430,450,530,4
     FRAME 30,30,300,280,4
     CALL MEMOLIST
     
    
     CURSOR 0,0
     MOV AX,0000H      ;��ʼ�����
     INT 33H
     CURSOR 0,0
     MOV AX,04H
     MOV CX,0
     MOV DX,0
     INT 33H
CHECK2:
     MOV AX,01H
     INT 33H           ;��������
     MOV AX,03H        ;����Ƿ������
     INT 33H
     CMP BX,0001H      ;������cx=��dx=�е�λ��
     JNE CHECK2       ;�������Ƿ���
     CMP DX,420
     JB  CHECK3
     CMP DX,450
     JA  CHECK3
     CMP CX,430
     JB  CHECK3
     CMP CX,530
     JA  CHECK3
     JMP CHECKEND
CHECK3:  
     SUB AX,AX
     MOV AL,MEMOCOUNT
     MOV LISTNUMBER,AL
     CMP AL,0
     JE  CHECK2
     CMP CX,300
     JB  CHECK2
     CMP CX,600
     JA  CHECK2
     CMP DX,30
     JBE  CHECK2
     CMP DX,280
     JAE  CHECK2
     MOV CHOOSEROW,DX
     SUB AX,AX
     MOV AX,CHOOSEROW
     SUB AX,30
     SUB DX,DX
     SUB BX,BX
     MOV BX,50
     DIV BX
     MOV CHECKROW,AX;ѡ�е���-1����1�������һ������¼����
     SUB AX,AX
     MOV AL,LISTNUMBER
     SUB BX,BX
     MOV BX,CHECKROW
     SUB AX,BX
     MOV NOWNAME,AL;ѡ���е��ļ������
     SUB AH,AH
     SUB CX,CX
     
     MOV SI,OFFSET COUNTLIST
     SUB BX,BX
     MOV BL,NOWNAME
     MOV BH,BYTE PTR[SI+BX];��õ�ǰ�ļ������ֵ�����
     MOV NAMESINGLE,BH
     
     MOV SI,OFFSET COUNTLIST
     SUB AH,AH
     MOV CL,NOWNAME    
     
COUNTLP:
     ADD AH,[SI];���������ļ���ǰ�����ļ����������ܺ�
     INC SI
     DEC CL
     CMP CL,0
     JA COUNTLP
     MOV NAMEALL,AH
     
     SUB AX,AX
     MOV AL,NOWNAME
     SUB CX,CX
     MOV CL,NAMEALL
     DEC AL
     
     MOV BX, OFFSET MEMONAME;BX���ļ������׵�ַ
     ADD BX,AX
     ADD BX,CX
 
     
     SUB CX,CX
     MOV CL,NAMESINGLE
     SUB AX,AX
     MOV SI,OFFSET NAMESUB
NAMECOPYLP:
     MOV AL,BYTE PTR[BX]
     MOV [SI],AL
     INC BX
     INC SI
     DEC CX
     CMP CX,0
     JA NAMECOPYLP
     
     MOV DX,OFFSET NAMESUB
     MOV AL,0
     MOV AH,3DH
     INT 21H ;���ļ�
     JC ERROR1
     MOV HANDLE,AX;�����ļ���
     MOV BX,AX
     MOV CX,255
     MOV DX,OFFSET BUF
     MOV AH,3FH
     INT 21H;���ļ��ж�255�ֽڵ�BUF��
     JC ERROR2
     MOV BX,AX;ʵ�ʶ������ַ�������BX
     MOV BUF[BX],'$';���ļ�����������1��'$'
     CURSOR 3,5
     MOV DX,OFFSET BUF
     MOV AH,09H
     INT 21H;��ʾ�ļ�����
     MOV BX,HANDLE
     MOV AH,3EH
     INT 21H;�ر��ļ�
     JNC CHECK2
     JMP CHECK2
ERROR1:
    INT 21H
    DISPLAY SMESSAGE
    JMP CHECK2    
 
ERROR2:    
     DISPLAY ERRORMESSAGE
     JMP CHECK2

CHECKEND:
     RET
     CHECKPRO ENDP

;----------------------------ɾ��ĳ����Ŀ-------------------
DELETEPRO PROC NEAR

     CALL MEMOLIST
     
     CURSOR 0,0
     MOV AX,0000H      ;��ʼ�����
     INT 33H
     CURSOR 0,0
     MOV AX,04H
     MOV CX,0
     MOV DX,0
     INT 33H
DELETE2:
     MOV AX,01H
     INT 33H           ;��������
     MOV AX,03H        ;����Ƿ������
     INT 33H
     CMP BX,0001H      ;������cx=��dx=�е�λ��
     JNE DELETE2       ;�������Ƿ���
     CMP DX,420
     JB  DELETE3
     CMP DX,450
     JA  DELETE3
     CMP CX,430
     JB  DELETE3
     CMP CX,530
     JA  DELETE3
     JMP DELETEEND
DELETE3:  
     SUB AX,AX
     MOV AL,MEMOCOUNT
     MOV LISTNUMBER,AL
     CMP AL,0
     JE  DELETE2
     CMP CX,300
     JB  DELETE2
     CMP CX,600
     JA  DELETE2
     CMP DX,30
     JBE  DELETE2
     CMP DX,280
     JAE  DELETE2
     MOV CHOOSEROW,DX
     SUB AX,AX
     MOV AX,CHOOSEROW
     SUB AX,30
     SUB DX,DX
     SUB BX,BX
     MOV BX,50
     DIV BX
     MOV CHECKROW,AX;ѡ�е���-1����1�������һ������¼����
     SUB AX,AX
     MOV AL,LISTNUMBER
     SUB BX,BX
     MOV BX,CHECKROW
     SUB AX,BX
     MOV NOWNAME,AL;ѡ���е��ļ������
     SUB AH,AH
     SUB CX,CX
     
     MOV SI,OFFSET COUNTLIST
     SUB BX,BX
     MOV BL,NOWNAME
     MOV BH,BYTE PTR[SI+BX];��õ�ǰ�ļ������ֵ�����
     MOV NAMESINGLE,BH
     
     MOV SI,OFFSET COUNTLIST
     SUB AH,AH
     MOV CL,NOWNAME    
     
COUNTLP:
     ADD AH,[SI];���������ļ���ǰ�����ļ����������ܺ�
     INC SI
     DEC CL
     CMP CL,0
     JA COUNTLP
     MOV NAMEALL,AH
     
     SUB AX,AX
     MOV AL,NOWNAME
     SUB CX,CX
     MOV CL,NAMEALL
     DEC AL
     
     MOV BX, OFFSET MEMONAME;BX���ļ������׵�ַ
     ADD BX,AX
     ADD BX,CX
     
     SUB CX,CX
     MOV CL,NAMESINGLE
     SUB AX,AX
     MOV SI,OFFSET NAMESUB
NAMECOPYLP:
     MOV AL,BYTE PTR[BX]
     MOV [SI],AL
     INC BX
     INC SI
     DEC CX
     CMP CX,0
     JA NAMECOPYLP
     
    ;ɾ���ļ�
    MOV DX,OFFSET NAMESUB
    MOV AH,41H
    INT 21H
    JC  ERROR2
    ;DISPLAY SMESSAGE
    
    ;ɾ���ļ����б��е��ļ���
     SUB AX,AX
     MOV AL,NOWNAME
     SUB CX,CX
     MOV CL,NAMEALL
     DEC AL
     
     MOV BX, OFFSET MEMONAME;BX���ļ������׵�ַ
     ADD BX,AX
     ADD BX,CX
     
     SUB CX,CX
     MOV CL,NAMESINGLE
     SUB AX,AX
NAMEDELETE:
     MOV AL,'$'
     MOV BYTE PTR[BX],AL
     INC BX
     DEC CX
     CMP CX,0
     JA NAMEDELETE
     JMP DELETEEND   
ERROR2:
    DISPLAY ERRORMESSAGE
    JMP DELETE2
DELETEEND:
     RET
     DELETEPRO ENDP
     
;--------------------------------�޸���Ŀ����-----------------------------
MODIFYPRO PROC NEAR
    
     CALL MEMOLIST
     
     CURSOR 0,0
     MOV AX,0000H      ;��ʼ�����
     INT 33H
     CURSOR 0,0
     MOV AX,04H
     MOV CX,0
     MOV DX,0
     INT 33H
MODIFY2:
     MOV AX,01H
     INT 33H           ;��������
     MOV AX,03H        ;����Ƿ������
     INT 33H
     CMP BX,0001H      ;������cx=��dx=�е�λ��
     JNE MODIFY2       ;�������Ƿ���
     CMP DX,420
     JB  MODIFY3
     CMP DX,450
     JA  MODIFY3
     CMP CX,430
     JB  MODIFY3
     CMP CX,530
     JA  MODIFY3
     JMP MODIFYEND
MODIFY3:  
     SUB AX,AX
     MOV AL,MEMOCOUNT
     MOV LISTNUMBER,AL
     CMP AL,0
     JE  MODIFY2
     CMP CX,300
     JB  MODIFY2
     CMP CX,600
     JA  MODIFY2
     CMP DX,30
     JBE  MODIFY2
     CMP DX,280
     JAE  MODIFY2
     MOV CHOOSEROW,DX
     SUB AX,AX
     MOV AX,CHOOSEROW
     SUB AX,30
     SUB DX,DX
     SUB BX,BX
     MOV BX,50
     DIV BX
     MOV CHECKROW,AX;ѡ�е���-1����1�������һ������¼����
     SUB AX,AX
     MOV AL,LISTNUMBER
     SUB BX,BX
     MOV BX,CHECKROW
     SUB AX,BX
     MOV NOWNAME,AL;ѡ���е��ļ������
     SUB AH,AH
     SUB CX,CX
     
     MOV SI,OFFSET COUNTLIST
     SUB BX,BX
     MOV BL,NOWNAME
     MOV BH,BYTE PTR[SI+BX];��õ�ǰ�ļ������ֵ�����
     MOV NAMESINGLE,BH
     
     MOV SI,OFFSET COUNTLIST
     SUB AH,AH
     MOV CL,NOWNAME    
     
COUNTLP:
     ADD AH,[SI];���������ļ���ǰ�����ļ����������ܺ�
     INC SI
     DEC CL
     CMP CL,0
     JA COUNTLP
     MOV NAMEALL,AH
     
     SUB AX,AX
     MOV AL,NOWNAME
     SUB CX,CX
     MOV CL,NAMEALL
     DEC AL
     
     MOV BX, OFFSET MEMONAME;BX���ļ������׵�ַ
     ADD BX,AX
     ADD BX,CX
     
     SUB CX,CX
     MOV CL,NAMESINGLE
     SUB AX,AX
     MOV SI,OFFSET NAMESUB
NAMECOPYLP:
     MOV AL,BYTE PTR[BX]
     MOV [SI],AL
     INC BX
     INC SI
     DEC CX
     CMP CX,0
     JA NAMECOPYLP
     
     MOV DX,OFFSET NAMESUB
     MOV AL,2
     MOV AH,3DH
     INT 21H ;���ļ�
     JC ERRORM
     MOV HANDLE,AX;�����ļ���
     
     MOV SI,OFFSET MODIFYBUF2
     CURSOR 10,10
     MOV AH,0AH
     MOV DX,OFFSET MODIFYBUF
     INT 21H
     INC DX
     MOV BX,DX
     SUB CL,CL
     MOV CL,BYTE PTR[BX]
     MOV MODIFYWORD,CL
     INC DX
     MOV BX,DX
MODIFYLP:
     MOV AX,[BX]
     MOV [SI],AX
     INC BX
     INC SI
     DEC CL
     CMP CL,0
     JNE MODIFYLP
     SUB CX,CX
     MOV AH,40H
     MOV BX,HANDLE
     MOV DX,OFFSET MODIFYBUF2
     MOV CL,MODIFYWORD
     MOV CH,0
     INT 21H
     
     
     JC  ERRORM
     JMP MODIFYEND
ERRORM:
   DISPLAY ERRORMESSAGE
   JMP  MODIFY2
     
MODIFYEND:
     MOV BX,HANDLE
     MOV AH,3EH
     INT 21H;�ر��ļ�
     RET
     MODIFYPRO ENDP

CODES ENDS
    END START

























