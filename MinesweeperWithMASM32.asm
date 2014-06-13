;**************************************MineSweeper Game*****************************************
;Authors by:
;Gökhan AVCI 
;Orhan GÜNEŞ
;************************************************************************************************
INCLUDE Irvine32.inc
;These following functions have some parameters
fillTableLoop PROTO, X:DWORD;send to dword type of fillTable function
openTable PROTO,xCoordinate1:BYTE,yCoordinate1:BYTE;send to two byte type of openTable function
findArrValue PROTO,xCoordinate2:BYTE,YCoordinate2:BYTE;send to two byte type of findArrValue function
putFlag PROTO,xCoordinate3:BYTE,yCoordinate3:BYTE;send to two byte type of putFlag function
putBomb PROTO,xCoordinate4:BYTE,yCoordinate4:BYTE;send to two byte type of putBomb function

.data
;These first four lines incude some ascıı character for draw table
up BYTE 255,255,65,255,255,255,66,255,255,255,67,255,255,255,68,255,255,255,69,255,255,255,70,255,255,255,71,255,255,255,72,255,255,255,73,255,255,255,74,0
upline BYTE 201,205,205,205,203,205,205,205,203,205,205,205,203,205,205,205,203,205,205,205,203,205,205,205,203,205,205,205,203,205,205,205,203,205,205,205,203,205,205,205,187,0
arasatir BYTE 204,205,205,205,206,205,205,205,206,205,205,205,206,205,205,205,206,205,205,205,206,205,205,205,206,205,205,205,206,205,205,205,206,205,205,205,206,205,205,205,185,0
uzatma BYTE 186,255,177,255,186,255,177,255,186,255,177,255,186,255,177,255,186,255,177,255,186,255,177,255,186,255,177,255,186,255,177,255,186,255,177,255,186,255,177,255,186,0
bottomline BYTE 200,205,205,205,202,205,205,205,202,205,205,205,202,205,205,205,202,205,205,205,202,205,205,205,202,205,205,205,202,205,205,205,202,205,205,205,202,205,205,205,188,0 
bomb BYTE 'B',0;represented mine by B alphabet character
;taking string x and y coordinate by user
xkoordinatIste BYTE "rakami gir :",0
ykoordinatIste BYTE "harfi gir :",0
start BYTE "Enter 0 mark, 1 open :",0;taking which want to choosing by user
kazandin BYTE "YOU WON WINNER  !",0;result string of game
kaybettin BYTE "YOU LOST !",0;result string of game
;used x and y coordinate by user
xCoordinate BYTE ?
YCoordinate BYTE ?
;taking x for character and y for number coordinate by user
harf BYTE ?
sayi BYTE ?
array BYTE 144 DUP(255);represented real array of game(12*12 size) and firstly filling 255 ascıı character(space)
array2 BYTE 144 DUP(255);controlled array for put flag 
x2 BYTE ?;check x coordinate for open table
y BYTE ?;check y coordinate for open table
;These variables are controlled if user wrong enter choosing
yinput byte 50 dup(0)
y2input byte 50 dup(0)
y3input byte 50 dup(0)
xinput byte 50 dup(0)
x2input byte 50 dup(0)
x3input byte 50 dup(0)
cinput byte 50 dup(0)
arrayflag byte 144 dup(177);represented real array of game
count BYTE ?;check game win or loss
count2 BYTE ?;check game win or loss

.code
;*************************mGotoxy MACRO*************************	
;going the row(x) and column(y) on screen
mGotoxy MACRO X:REQ,Y:REQ
 push edx
 mov dh,X
 mov dl,Y
 call Gotoxy
 pop edx
ENDM
;*************************drawTable MACRO*********************** 
;doing the draw table
drawTable MACRO 
push edx
push ecx
call clrscr
mov edx,offset up;first, call up array 
call writeString
call crlf
mov edx,offset upline;second, call upline array
call writeString
call crlf
mov edx,offset uzatma;third, call uzatma array
call writeString
mov eax,0
call writeInt;fourth, put 0 number for table
mov ecx,9;turning 9 times for draw table
L1:
	call crlf
	mov edx,offset arasatir;call arasatir array
	call writeString
	mov edx,offset uzatma;call uzatma array
	call crlf
	call writeString
	mov eax,10
	sub eax,ecx
	call writeInt;put 1 2 ... 9 number of table
LOOP L1
call crlf
mov edx,offset bottomline;call bottomline array
call writeString
pop ecx
pop edx
mov array[0],63;filling array left the top corner  of by(?)
mov ecx,11
L4:
mov array[ecx],63;filling array  all of the top horizantal  line by ?
mov edx,ecx
add edx,132
mov array[edx],63;filling array  all of the down horizantal line by ? 
LOOP L4
mov ecx,132
L3:
mov array[ecx],63;filling array  all of the left vertical line by ? 
mov edx,ecx
add edx,11
mov array[edx],63;filling array  all of the right vertical  line by ?
sub ecx,11
LOOP L3
ENDM
;****************************MAIN PROC**************************
main PROC
mov ecx,0
call clrscr
drawTable  ;draw table on the screen 
call crlf
mov count,0
ask:;firstly ask question
	mov edx,offset start;Enter 0 mark, 1 open :
	call writeString
	
	mov edx,OFFSET cinput;taking of input
	mov ecx,50
	
	call readString;read of input
	mov al,cinput[0]
	
	cmp al,48;if below 48(0) ask again
	jb ask
	
	cmp al,49;if above 49(1) ask again
	ja ask
	
	cmp al,49;if equal 1 jump open2 
	je open2
	
	cmp al,48
	je mark2;if equal 0 jump mark2

open2:;if want to first open 
	call crlf
	mov edx,offset ykoordinatIste ;ask y coordinate (a character)
	call writeString
	
	mov edx,OFFSET yinput;taking of input
	mov ecx,50
	call readString
	
	mov al,yinput[0]
	sub al,65
	cmp al,9
	ja open2;if above  J jump open2 again 	
	cmp al,0
	jb open2;if below A ask again otherwise continue
	mov yCoordinate,al;fill input of al 
	call crlf
	
	mov edx,offset xkoordinatIste ;ask x coordinate (a number)
	call writeString
	
	call readInt;reading input 
	mov ebx,eax
	mov xCoordinate,bl;fill input of bl 
	INVOKE putBomb,xCoordinate,yCoordinate;call putbomb function
	call fillTable
	push ecx
	push ebx
	push eax
	mov ecx,145
	L23:;find the in array where put bomb 
		mov ebx,ecx
		dec ebx
		movzx eax,array[ebx]
		mov array2[ebx],al;and put bomb in array2 same location 
	LOOP L23
	pop eax
	pop ebx
	pop ecx 
	INVOKE openTable,xCoordinate,yCoordinate;call openTable function
	mGotoxy 21,0 
	jmp question;jmp question
	
mark2:;if want to first open 
	
	call crlf
	mov edx,offset ykoordinatIste ;ask y coordinate (a character)
	call writeString
	
	mov edx,OFFSET y2input;taking of input
	mov ecx,50
	call readString
	
	mov al,y2input[0]
	sub al,65
	cmp al,9;if above  J ask again 	
	ja mark2
	cmp al,0
	jb mark2;if below A ask again otherwise continue
	mov yCoordinate,al;fill input in al 
	call crlf
	
	mov edx,offset xkoordinatIste ;ask x coordinate (a number)
	call writeString
	call readInt;taking input
	mov ebx,eax
	INVOKE putBomb,xCoordinate,yCoordinate;call putBomb function
	call fillTable
	INVOKE putFlag,xCoordinate,yCoordinate;call putFlag function
	mGotoxy 21,0 
	jmp question;jmp question
	
question:;After the  first question
	call crlf
	ask2:
	mov edx,offset start;Enter 0 mark, 1 open :
	call writeString
	
	mov edx,OFFSET cinput;taking input
	mov ecx,50
	call readString;read input
	
	mov al,cinput[0]
	cmp al,48
	jb ask2;if below 0 ask2 again 
	
	cmp al,49
	ja ask2;if above 1 ask2 again 
	
	cmp al,49
	je open;if equal 1 jump open 
	
	cmp al,48
	je mark;if equal 0 jump mark 

open:;if want to open 
	call crlf
	mov edx,offset ykoordinatIste;ask y coordinate (a character)
	call writeString
	
	mov edx,OFFSET y3input;taking input
	mov ecx,50
	call readString;read input
	
	mov al,y3input[0]
	sub al,65
	cmp al,9;if above  J  jump open again
	ja open
	cmp al,0
	jb open;if below A jump  open again otherwise continue
	mov yCoordinate,al;fill input of al
	call crlf
	
	mov edx,offset xkoordinatIste ;ask x coordinate (a number)
	call writeString
	call readInt;reading input
	mov ebx,eax
	mov xCoordinate,bl
	INVOKE openTable,xCoordinate,yCoordinate;call openTable function
	mGotoxy 21,0 
	jmp question;jump again question
	
mark:
	call crlf
	mov edx,offset ykoordinatIste ;ask y coordinate (a character)
	call writeString
	mov edx,OFFSET yinput;taking input
	mov ecx,50
	call readString;read input
	mov al,yinput[0]
	sub al,65
	cmp al,9;if above  J  jump mark again
	ja mark
	cmp al,0
	jb mark;if below A jump  open again otherwise continue
	mov yCoordinate,al;filling input of al 
	call crlf
	mov edx,offset xkoordinatIste ;ask x coordinate (a number)
	call writeString
	call readInt;reading input
	mov ebx,eax
	mov xCoordinate,bl
	INVOKE putFlag,xCoordinate,yCoordinate;call putFlag function
	mGotoxy 21,0 
	jmp question;jump again question
exit	
main ENDP

;***************************putBomb Functions ***********************************
;The function put 10 bomb of in the array and when user first open location,
;the adjacent of the location doesn't have bomb 
putBomb PROC ,xCoordinate4:BYTE, yCoordinate4:BYTE
;These proceses find this location where in our array 
mov ebx,12
movzx eax,xCoordinate4
mul ebx
add eax,13
add al,yCoordinate4
mov edx,eax
;**********************
;Then, first user location and adjacent of the location fill 33(!) character 
;for own location
push edx
mov array[edx],33;did array element !
pop edx

;left for adjacent
push edx
sub edx,1
cmp array[edx],63;if have ? do nothing otherwise jmp w1
jne w1
pop edx
jmp e1
w1:
	mov array[edx],33;did array element !
	pop edx
	jmp e1

;right for adjacent
e1:
	push edx
	add edx,1
	cmp array[edx],63;if have ? do nothing otherwise jmp w2
	jne w2
	pop edx
	jmp e2
	w2:
		mov array[edx],33;did array element !
		pop edx
		jmp e2
		
;left down for adjacent
e2:	
	push edx
	add edx,11
	cmp array[edx],63;if have ? do nothing otherwise jmp w3
	jne w3
	pop edx
	jmp e3
	w3:
		mov array[edx],33;did array element !
		pop edx
		jmp e3
		
;down for adjacent
e3:
	push edx
	add edx,12
	cmp array[edx],63;if have ? do nothing otherwise jmp w4
	jne w4
	pop edx
	jmp e4
	w4:
		mov array[edx],33;did array element !
		pop edx
		jmp e4
	
;right down for adjacent
e4:
	push edx
	add edx,13
	cmp array[edx],63;if have ? do nothing otherwise jmp w5
	jne w5
	pop edx
	jmp e5
	w5:
		mov array[edx],33;did array element !
		pop edx
		jmp e5
		
;left down for adjacent
e5:
	push edx
	sub edx,13
	cmp array[edx],63;if have ? do nothing otherwise jmp w6
	jne w6
	pop edx
	jmp e6
	w6:
		mov array[edx],33;did array element !
		pop edx
		jmp e6
		
;top for adjacent
e6:
	push edx
	sub edx,12
	cmp array[edx],63;if have ? do nothing otherwise jmp w7
	jne w7
	pop edx
	jmp e7
	w7:
		mov array[edx],33;did array element !
		pop edx
		jmp e7
		
;top right for adjacent
e7:
	push edx
	sub edx,11
	cmp array[edx],63;if have ? do nothing otherwise jmp w8
	jne w8
	pop edx
	jmp e8
	w8:
		mov array[edx],33;did array element !
		pop edx
		jmp e8
		
e8:	
	top:
		mov edi,0;controlled how many put bomb
		call randomize;call randomize for each run, different locatıon put bomb	
		mov ecx,10;put 10 bomb by using loop 
		L2:
			repeatt:
				again :
					mov eax,75;create 0- 74 between number 
					call RandomRange
					cmp eax,65;for A character , A=0, B=1, C=2, .... J=9
					jb again;if below jump again
					sub eax,65;for represented number 
					mov harf,al;filling of harf 
					mov eax,10;create 0-9 between number
					call RandomRange
					mov sayi,al;filling of sayi 
					;These proceses find this location where in our array 
					movzx eax,sayi
					mov ebx,12
					mul ebx
					movzx edx,harf
					add eax,edx
					add eax,13
					mov esi,eax
					cmp array[esi],33;if have ? jump repeatt 
					jne succes1
					jmp repeatt
				succes1:
					cmp array[esi],66;if have a bomb jmp repeatt
					jne succes2
					jmp repeatt
				succes2:	
					add edi,1
					mov array[esi],66;put bomb in our array
		LOOP L2
			cmp edi,10;if have 10 bomb jmp stop and end of putBomb function
			je stop
			jmp top
stop:
	ret
putBomb ENDP

;***********************findArrValue Function*********************************
;These function find this location where in our array 
findArrValue PROC,xCoordinate2:BYTE,YCoordinate2:BYTE
;These proceses find this location where in our array and return edx value 
mov ebx,12
movzx eax,xCoordinate2
mul ebx
add eax,13
add al,yCoordinate2
mov edx,eax
ret		
findArrValue ENDP

;***************************openTable Function*********************************
openTable PROC USES eax ebx ecx edx, xCoordinate1:BYTE, yCoordinate1:BYTE  
;These process put character (A B .... J) of top on the table
push edx
mGotoxy 0,0
mov edx,OFFSET up
call WriteString
pop edx
;saved x and  y coordinate value by x2 and y 		
mov al,xCoordinate1
mov x2,al
mov bl,yCoordinate1
mov y,bl
;These proceses find this location where in our array and return edx value
mov ebx,12
movzx eax,xCoordinate1
mul ebx
add eax,13
add al,yCoordinate1
mov edx,eax
;**********************************************************************************
cmp array[edx],63d;if have ? dont open and return
jne ileri3
ret

ileri3:
	cmp array[edx],5d;if have flag dont open and return
	jne ileri2
	ret
		
ileri2:
	cmp array[edx],80d;if have proceses(P) dont open and return otherwise jmp ileri 
	jne ileri
	ret 

ileri:
	;These process where is the our table
    mov eax,0
	mov bl,2		       
	mov al,xCoordinate1 ;for number
	mul bl 			   
	mov xCoordinate1,al 
	add xCoordinate1,2  

	mov bl,4	
	mov al,yCoordinate1	 ;for character
	mul bl				
	mov yCoordinate1,al	
	add yCoordinate1,2	
	;*************************************************************************************
	;These process give a color each color
	mov al,array[edx] 	
	push eax
	
	cmp al,49
	je s3
	jmp devam3
	
	s3:
		mov eax,10 + (black*16) ;16  fore + background
        call setTextColor
		
	devam3:
		cmp al,50
		je s4
		jmp devam4
	
	s4:
		mov eax,2 + (black*16) ;16  fore + background
        call setTextColor
		
	devam4:
		cmp al,51
		je s5
		jmp devam5
	
	s5:
	    mov eax,14 + (black*16) ;16  fore + background
        call setTextColor
	
	devam5:
		cmp al,52
		je s6
		jmp devam6
	s6:
		mov eax,15 + (black*16) ;16 hep + background
        call setTextColor
		
	devam6:
		cmp al,53
		je s7
		jmp devam7
	
	s7:
		mov eax,8 + (black*16) ;16 fore + background
        call setTextColor
		
	devam7:
		cmp al,54
		je s8
		jmp devam8
	
	s8:
	    mov eax,6 + (black*16) ;16  fore + background
        call setTextColor
		
	devam8:
		cmp al,55
		je s9
		jmp devam9
	
	s9:
		mov eax,12+ (black*16) ;16 fore + background
        call setTextColor
		
	devam9:
		cmp al,56
		je s10
		jmp devam10
	
	s10:
		mov eax,4+ (black*16) ;16  fore + background
        call setTextColor
		
	devam10:	
		pop eax
        mGotoxy xCoordinate1,yCoordinate1
		
		cmp al,33;if have ! jump s otherwise jump s2
		je s
		jmp s2
		
	s:
		mov al,255;did 255(space)
	
	s2:
		call writeChar;write char on the table
		mov array[edx],80;and did process
		
		cmp al,66d;if have bomb jump yeter and return
		je yeter
		
		cmp al,255;if have space jump rec1 and open 
		je rec1
		
		cmp al,33;if have ! jump rec1 and open otherwise return 
		je rec1
		
ret		
				
rec1:
	;for right adjacent
	 inc x2
	 invoke findArrValue,x2,y ;call findArrValue function
	 cmp array[edx],66 ;if have bomb dont open
	 je next1
	 invoke openTable,x2,y ;1,0 and call openTable function
	 dec x2
	 
	next1:
		;for left adjacent
		dec x2
		invoke findArrValue,x2,y;call findArrValue function
		cmp array[edx],66;if have bomb dont open
		je next4
		invoke openTable,x2,y;-1,0 and call openTable function
		inc x2	
		
	next2:
		;for top adjacent
		dec y
		invoke findArrValue,x2,y;call findArrValue function
		cmp array[edx],66;if have bomb dont open
		je next3
		invoke openTable,x2,y ;0,-1 and call openTable function
		inc y
		
	next3:
		;for down adjacent
		inc y
		invoke findArrValue,x2,y;call findArrValue function
		cmp array[edx],66;if have bomb dont open jump next4 and return
		je next4
		invoke openTable,x2,y ;0,1 and call openTable function
		dec y
		
	next4:
		ret

yeter:;if user open bomb game finish and loss
	mGotoxy 30,0
	mov edx,OFFSET kaybettin
    call WriteString
exit
openTable ENDP

;****************************fillTable Function**********************************
;The function fill number and ! in array and check first user open location 
fillTable PROC
mov edx,0
mov ecx,144;scan all of the element array
L5:
	cmp array[edx],66 ;if have bomb continue
	je continue
	cmp array[edx],63;if we have ? continue otherwise call fillTableLoop function
	je continue
	push edx
	INVOKE fillTableLoop, edx ;if we dont have bomb or ?, send edx value of fillTableLoop
	add edx,1;going next element
	pop edx
	continue:
			add edx,1;going next element
LOOP L5	
ret
fillTable ENDP

;*********************************fillTableLoop Function**************************************************
;The function fill number and ! in array and check first user open location
fillTableLoop PROC X:DWORD
	mov edx,X
	push edx;save index of 255
	sub edx,1;going to left adjacent
	cmp array[edx],66;if have bomb jump yes1
	je yes1;
	pop edx;
	jmp cont1
	yes1:
		pop edx
		cmp array[edx],255;if have 255 add 50 of index  
		jne equal1 
		add array[edx],50
		jmp cont1
		equal1:
			cmp array[edx],33;if have ! did 1 
			jne q1
			mov array[edx],49
			jmp cont1
			q1:
				add array[edx],1;inc index of element
				jmp cont1
	cont1:	
		push edx;save index of 255
		add edx,1;going to right adjacent
		cmp array[edx],66;if have bomb jump yes2
		je yes2
		pop edx
		jmp cont2
		yes2:
			pop edx
			cmp array[edx],255;if have 255 add 50 of index 
			jne equal2 
			add array[edx],50
			jmp cont2
			equal2:
				cmp array[edx],33;if have ! did 1 
				jne q2
				mov array[edx],49
				jmp cont2
				q2:
					add array[edx],1;inc index of element
					jmp cont2
	cont2:	
		push edx;save index of 255
		add edx,11;going to left to down adjacent
		cmp array[edx],66;if have bomb jump yes3
		je yes3
		pop edx
		jmp cont3
		yes3:
			pop edx
			cmp array[edx],255;if have 255 add 50 of index 
			jne equal3 
			add array[edx],50
			jmp cont3
			equal3:
				cmp array[edx],33;if have ! did 1 
				jne q3
				mov array[edx],49
				jmp cont3
				q3:
					add array[edx],1;inc index of element
					jmp cont3
	cont3:		
		push edx;save index of 255
		add edx,12;going to down adjacent
		cmp array[edx],66;if have bomb jump yes4
		je yes4
		pop edx
		jmp cont4
		yes4:
			pop edx
			cmp array[edx],255;if have 255 add 50 of index 
			jne equal4 
			add array[edx],50
			jmp cont4
			equal4:
				cmp array[edx],33;if have ! did 1 
				jne q4
				mov array[edx],49
				jmp cont4
				q4:
					add array[edx],1;inc index of element
					jmp cont4
	cont4:	
		push edx;save index of 255
		add edx,13;going to right to down adjacent
		cmp array[edx],66;if have bomb jump yes5
		je yes5
		pop edx
		jmp cont5
		yes5:
			pop edx
			cmp array[edx],255;if have 255 add 50 of index 
			jne equal5 
			add array[edx],50
			jmp cont5
			equal5:
				cmp array[edx],33;if have ! did 1 
				jne q5
				mov array[edx],49
				jmp cont5
				q5:
					add array[edx],1;inc index of element
					jmp cont5
	cont5:
		push edx;save index of 255
		sub edx,13;going to left to top adjacent
		cmp array[edx],66;if have bomb jump yes6
		je yes6
		pop edx;
		jmp cont6
		yes6:
			pop edx
			cmp array[edx],255;if have 255 add 50 of index 
			jne equal6 
			add array[edx],50
			jmp cont6
			equal6:
				cmp array[edx],33;if have ! did 1 
				jne q6
				mov array[edx],49
				jmp cont6
				q6:
					add array[edx],1;inc index of element
					jmp cont6
		cont6:	
		push edx;save index of 255
		sub edx,12;going to top adjacent
		cmp array[edx],66;if have bomb jump yes7
		je yes7
		pop edx
		jmp cont7
		yes7:
			pop edx
			cmp array[edx],255;if have 255 add 50 of index 
			jne equal7 
			add array[edx],50;arrayın içindeki eleman bosluk ise onu 1 yap
			jmp cont7
			equal7:
				cmp array[edx],33;if have ! did 1 
				jne q7
				mov array[edx],49
				jmp cont7
				q7:
					add array[edx],1;inc index of element
					jmp cont7
	cont7:	
		push edx;save index of 255
		sub edx,11;going to right to top adjacent
		cmp array[edx],66;if have bomb jump yes8
		je yes8
		pop edx
		jmp cont8
		yes8:
			pop edx
			cmp array[edx],255;if have 255 add 50 of index 
			jne equal8 
			add array[edx],50
			jmp cont8
			equal8:
				cmp array[edx],33;if have ! did 1 
				jne q8
				mov array[edx],49
				jmp cont8
				q8:
					add array[edx],1;inc index of element jump cont8 and return 
					jmp cont8
	cont8:	
		ret
fillTableLoop ENDP

;**********************************PutFLAG Function**********************************************
putFlag PROC,xCoordinate3:BYTE,yCoordinate3:BYTE
;give a color for flag
mov eax,12+ (black*16) ;16 hep fore + background
call setTextColor
invoke findArrValue,xCoordinate3,yCoordinate3;call findArrValue for find where array index
cmp arrayflag[edx],177;if have 177 again set up 177 
jne koyma
mov arrayflag[edx],5;if not equal did flag of arrayflag 
mov array[edx],5;if not equal did flag of array
inc count;inc count for calculated flag number
jmp g2
koyma:
mov arrayflag[edx],177;again set up 177 
push ebx
movzx ebx,array2[edx]
mov array[edx],bl
dec count;dec count for calculated flag number
pop ebx
g2:
cmp count,10;if count 10 check result game 
je bitirelim;egual finish 
jmp bitirmeyelim;not egual not fınısh 
bitirelim :
;These process where is the table
mov eax,0
mov bl,2		       
mov al,xCoordinate3;for character 
mul bl 			   
mov xCoordinate3,al 
add xCoordinate3,2  

mov bl,4			
mov al,yCoordinate3;for number 
mul bl		
mov yCoordinate3,al	
add yCoordinate3,2	
;*************************************************************************************
movzx eax,arrayflag[edx];put eax value in arrayflag
mGotoxy xCoordinate3,yCoordinate3;goto x and y coordinate
call writeChar 
call checkWIN;call checkWIN

bitirmeyelim:;if dont finished 
;These process where is the table
mov eax,0
mov bl,2		     
mov al,xCoordinate3; for character
mul bl 			   
mov xCoordinate3,al 
add xCoordinate3,2  

mov bl,4			
mov al,yCoordinate3;for number
mul bl				
mov yCoordinate3,al	
add yCoordinate3,2	
;*************************************************************************************
movzx eax,arrayflag[edx];put eax value in arrayflag
mGotoxy xCoordinate3,yCoordinate3;goto x and y coordinate
call writeChar
mGotoxy 26,0
ret
putFlag ENDP

;**********************************checkWIN Function**********************************
checkWIN PROC
mov count2,0
mov ecx,145;scan all of the element of array 
L22:;calculated number of flag in arrayflag and array2
mov ebx,ecx
dec ebx
mov al,arrayflag[ebx]
mov ah,array2[ebx]
sub ah,61
cmp al,ah;if array2 and arrayflag index of element equal inc count 
je arttir2
jmp endOfLoop
arttir2:
inc count2
endOfLoop:
	LOOP L22

movzx eax,count2
cmp count2,10;compare count2, if equal you win otherwise you loss 
jne lose
mGotoxy 30,0
mov edx,OFFSET kazandin;call kazandin array
call WriteString
exit
lose:
mGotoxy 30,0
mov edx,OFFSET kaybettin;call kaybettin array
call WriteString
exit
 checkWIN ENDP
END main
;***************************************************FINISHED********************************************************
