DATAS SEGMENT
    ;�˴��������ݶδ���  
    
    ORG 0000H
    DATA1 DB 100 DUP(00)
    
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
    MOV SI,OFFSET DATA1
    MOV AX,[SI]
    ADD AX,1
    MOV [SI],AX
    
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
