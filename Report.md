MinesweeperWithMASM32
=====================

Assembly term project with teammate Orhan Güneş
***********************************************

FUNCTIONS  WE HAVE USED

fillTableLoop PROTO, X:DWORD;

openTable PROTO,xCoordinate1:BYTE,yCoordinate1:BYTE

findArrValue PROTO,xCoordinate2:BYTE,YCoordinate2:BYTE

putFlag PROTO,xCoordinate3:BYTE,yCoordinate3:BYTE

putBomb PROTO,xCoordinate4:BYTE,yCoordinate4:BYTE

MAIN 

To create a gui on cmd we use character arrays that includes ASCII characters and by writing that strings we built our table seen by user.And this part is done by a MAKRO which is called as drawTable.
After drawing table on command window its time to get input from user and give output.There are 4 label.That 4 label considers 4 different situations which are : 

Ask,
opening first,
marking first, 
opening after first iteration ,
marking after first iteration,
question.

In ask lavel we print on screen  “enter 0 mark,1 open :” by moving offset of start to edx and calling writeString.And we have an array called cinput we move its offset to edx and setting ecx 50 provides us getting input with max size 50 and putting it into cinput array.We only care about first element and checking first element of input.If cinout[0] is not 1 or 0 it ask again till we get valid input.If cinput[0] equalst 49(1’ASCII code) it jumps open2 label.Open2 label is for opening first.If cinput[0] equals to 48 it means mark first and jumps to mark2 label.Mark2 label is for marking first.

Lets look what these labels do.Open2 label as we said before works when we want to open first.It asks first y coordinate which is a letter.And checks whether input is valid or not if not valid it ask again.After getting y coordinate we get x coordinate in same manner.We took coordinates now we can put bombs with rule that no adjacent of input includes bomb.When we putting bombs we use a function putBomb with parameters xCoordinate and yCoordinate.And after putting bombs we call fillTable function.Fill table function arranges our array according to bombs location this is place that we put 1s,2s,3s etc.Finally we open location demanded by user.We use openTable function with xCoordinate and yCoordinate parameters and open it.We will look at openTable after.
Mark2 marks first it hapens rarely actually but it works in same manner with open2 label only difference is last of the label insteadof openTable function putFlag function is called.
Putbomb function is only called opening first and marking first.It means only after first input we putBomb and arrange our array after that we dont change our bombs location.
We marked or opened first we have arranged array and 10 bombs.Questioning must be continued.Question label does this job asks again would user like to open or mark.And almost same with ask label.Difference between ask and question label is ask is for firt input and after ask it jumps mark2 or open2 label after question label it jumbs open or mark.Difference between open2 and open mark is one is for first one is for 2nd and after iterations.Same is okey with mark2 and mark.
Open and mark labels are same with open2 and mark2 with difference in mark and open there is no putBomb and fillTable because these 2 function for first input and used in open2 and mark2 table once.

FUNCTIONS AND MACROS WE HAVE WRITTEN



mGotoxy MACRO X:REQ,Y:REQ



It takes x and y as input and puts cursor here.
drawTable MACRO
It clears screen first and uses our strings which we prepare and moving their offset to edx writes on screen.And our array we say that there is boundaries and we use array with size 144 intead of 100 these extra lines are boundaries and filled with 63 which means ‘?’ in ASCII. Our table is like that:





findArrValue PROTO,xCoordinate2:BYTE,YCoordinate2:BYTE



In that function take 2 input. We use one dimensional array with size 144.10 for squares one for right bound 1 for left bound 1 for upper bound and last below bound so 12*12 array.And according to our code when we ultioly entered xCoordinate2 with 12 and adding to it 13+ yCoordinate2 gives arrays location.



putBomb PROC ,xCoordinate4:BYTE, yCoordinate4:BYTE



In that function we take 2 input which xcoordinate and ycoordinate.The function put 10 bomb of in our array. When user  first open location, the adjacent  (left to top,top,right to top, left to down, down, right to down, left and right)  of the location and own doesn't  put bomb.
Firstly, we found this input where our of location in array and stored edx register.  Lİke this:
mov ebx,12
movzx eax,xCoordinate4
mul ebx
add eax,13
add al,yCoordinate4
mov edx,eax
Then, we filled first user location and adjacent of the location(left to top,top,right to top, left to down, down, right to down, left and right)  33(!) character. If adjacent array have 63(?) character,it was nothing.
Secondly, we used edi register for controlled how many put bomb, then call randomize for each  iteration run different location put bomb. We created a loop which turning 10 times. Each times we did;  created  between 0 - 74  number  by call RandomRange. We compared the numbers 65 because A character begin 65. If it  below, repeat a created number. If it doesn't below, it substract by 65 for represent A=0,B=1,C =2......J=9. We stored these numbers by al register and move harf variable.  Then we did; created between 0-9 number by call RandomRange and we stored these numbers by al register and move sayi variable.
Thirdly, we stored harf and sayi  variables in esi register. Like this:
movzx eax,sayi
mov ebx,12
mul ebx
movzx edx,harf
add eax,edx
add eax,13
mov esi,eax
Finally, we checked in our array by array[esi] command. If it has 33(!) or 66 (B) , it  jump  top on loop, repeat that aboving processes , otherwise we put succesllly 10 bomb, return function  and end of our function.



fillTableLoop PROC X:DWORD



In that functıon, we take a input which x , type of dword register and this function fills table with numbers up to how many bomb its adjacents have.The function call by fillTable proc.In the fillTable proc, we did; beginning of the array,  created a loop and the loop turning 144 times for scan all of the element array by using edx register.  Each iteration, we checked element of array. If it has a bomb or 66(?) character, it is nothing and looked the next element of array. Otherwise, we called fillTableLoop function with  sending edx value.
Firstly, we saved element of array  by push operand and going to each  adjacent(left to top,top,right to top, left to down, down, right to down, left and right) of the element array.After, we looked the each adjacent of the element array, we popped , for ancient edx value.
Secondly, we checked of element array. If it has a bomb, checked has 255(space).If doesn't have a bomb, looked the other adjacent of the element array. If it has 255, it add 50 of index. It means that, the element of array was 1.If doesn't have 255, checked has 33(!). If has 33(!), it was 49. It means that, the element of array was 1. If doesn't have 33(!), It was increment by one. It means that, the element of array was 2 or 3 .... or 8. These operations is like that:
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
				jmp cont1;looked the other adjacent
Finallly,we  looked the other all  adjacent of the element array, scan all of the element array, return our function and end of function.



openTable PROC USES eax ebx ecx edx, xCoordinate1:BYTE, yCoordinate1:BYTE



In that function we take 2 input and use 2 more data space x2 and y to store it.We did these because when we roaming we change xcoordinates and ycoordinates we did not want to change input we prefer change temporary space we crate and where we copied input.
After storing input in extra space we calculate which elemet of array corresponds to location user demanded to open.
	
mov al,xCoordinate1
mov x2,al
mov bl,yCoordinate1
mov y,bl
	  
mov ebx,12
movzx eax,xCoordinate1
mul ebx
add eax,13
add al,yCoordinate1
mov edx,eax

And in edx we have that location after pece of code shown above.
Because of our function works recursively i need some stop condition one of them is when it comes to a boundary there is ? in array and by comparing i can decide that if i am at the boundary stop dont proceed.
Another control mechanis is that if there is marked square and you want to open beside this and mark is done wrong dont open this user should understand its mistakes and unmark it.So if there is flag dont open it.
3rd check is the most if this check is deleted openTable does not work.If i opened a square ishould not check it again.To do this check we put 80 (P)  to array for understanding we check that square.
After these check i am finding which location on cmd corresponds to that demanded value.We have 2 formula here :
For x coordinate 
2x+2
For y coordinate
4y+2
And i put these values to xcoordinate and ycoordinate.If we did not use x2 and y data space for storing x and y input we would lose in that point and would not use remaining part of this function.
And i have in edx my array location i put my array’s these locationth element to al so i know what is behind that square.
After that i am setting colors.I compare value with 1,2,3,.....,8 and set color up to that value.I dont check numbers more than 8 because a square can be adjacent to max 8 square.
After setting color checks are continuing.We check that values is ! or not .We use ! for avoiding putting bomb adjacents of first selected area.If there is ! it means there is no bomb and these value is 0 actually.
And this was the last check now i print by calling writeChar.
If i print B ends the game by jumping yeter label.

If there is 33(!) or space 255 ( ) jump rec1 where recursive is.
If this situation is not both 0 or B it means i open a number and open it and stop
In recursive part it checks left right below and up adjacent of the selected square.And calls itself for that locations.



putFlag PROC,xCoordinate3:BYTE,yCoordinate3:BYTE



This function marks or unmarks.To understand this uses a control and looks that it is marked before or not opened or marked before.And there is an array arrayflag with firstly fulled with 177 and when we mark we put these arrays corresponfing location 5.And also when we mark we change our main array.So when we need to turn back from marked i need an extra array which we called array2.We bring previous value from that array and first we close that square and embed behind this previous value (before we set 5 in array)
And when number of marked squares reached to 10 it calls checkWIN function which says user win or lose.
checkWIN PROC
I have 2 array which are my array includes bombs numbers and other is arrayFlag array that shows an element marked or unmarked 177 or 5 like 1 and 0’s.And there is a loop checks arrayflags and array2’s elements one by one.It subtracts 61 from element of array2 and if result is 5 it means there 66 which is Bomb.And If arrayFlag’s value in that location is 5 it means it is marked so bomb is marked increment count by1.After checking all if there is 10 check it means all boms are  marked and user won else user lost. 

