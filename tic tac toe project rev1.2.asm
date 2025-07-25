					//
					// ethan brown tic tac toe 12/4
					// this is my project for my embedded systems design class
					// this project enables a player to play tic tac toe using the touchscreen 
					// attached to the STMicroelectronics STM32F746G-DISCO board


  .syntax unified 			// This directive specifies the use of UAL syntax
  .cpu cortex-m7  			// This directive indicates that the code is targeting the ARM Cortex-M7 processor
  .fpu softvfp    			// This directive specifies that the floating-point operations will be handled by a software floating-point library
  .thumb          			// This directive instructs the assembler to interpret the subsequent instructions as Thumb instructions
  .text           			// This directive indicates that the following code is part of the program's code section
  .align          			// This directive ensures that the code or data is aligned to a specific memory boundary
  .global myFunc  			// This directive declares the symbol myFunc as global, making it visible to other files during the linking process
  .global printf  			// This directive makes the printf symbol visible to the linker, allowing the assembly code to call the standard C library's printf function

 					// the following C language functions are defined in myAlgorithm.c
  .global checkForTouch
  .global touchX
  .global touchY

 					// the following C language functions are defined in stm32746g_discovery_lcd.c
  .global BSP_LCD_Clear 	    	// Clears the entire active LCD layer with a specified color
  .global BSP_LCD_SetTextColor      	// Sets the color for subsequent text displayed on the LCD
  .global BSP_LCD_FillRect          	// Draws and fills a rectangle on the currently active LCD layer
  .global BSP_LCD_FillCircle        	// Draws and fills a circle on the currently active LCD layer
  .global BSP_LCD_DrawCircle        	// Draws the outline of a circle on the currently active LCD layer
  .global BSP_LCD_DrawLine          	// Draws a line between two specified points on the currently active LCD layer
  .global BSP_LCD_DisplayStringAt   	// Displays a string of characters at a specific position on the currently active LCD layer

					// the following constants are defined in stm32746g_discovery_lcd.h
LCD_COLOR_BLUE          = 0xFF0000FF
LCD_COLOR_GREEN         = 0xFF00FF00
LCD_COLOR_RED           = 0xFFFF0000
LCD_COLOR_CYAN          = 0xFF00FFFF
LCD_COLOR_MAGENTA       = 0xFFFF00FF
LCD_COLOR_YELLOW        = 0xFFFFFF00
LCD_COLOR_LIGHTBLUE     = 0xFF8080FF
LCD_COLOR_LIGHTGREEN    = 0xFF80FF80
LCD_COLOR_LIGHTRED      = 0xFFFF8080
LCD_COLOR_LIGHTCYAN     = 0xFF80FFFF
LCD_COLOR_LIGHTMAGENTA  = 0xFFFF80FF
LCD_COLOR_LIGHTYELLOW   = 0xFFFFFF80
LCD_COLOR_DARKBLUE      = 0xFF000080
LCD_COLOR_DARKGREEN     = 0xFF008000
LCD_COLOR_DARKRED       = 0xFF800000
LCD_COLOR_DARKCYAN      = 0xFF008080
LCD_COLOR_DARKMAGENTA   = 0xFF800080
LCD_COLOR_DARKYELLOW    = 0xFF808000
LCD_COLOR_WHITE         = 0xFFFFFFFF
LCD_COLOR_LIGHTGRAY     = 0xFFD3D3D3
LCD_COLOR_GRAY          = 0xFF808080
LCD_COLOR_DARKGRAY      = 0xFF404040
LCD_COLOR_BLACK         = 0xFF000000
LCD_COLOR_BROWN         = 0xFFA52A2A
LCD_COLOR_ORANGE        = 0xFFFFA500
LCD_COLOR_TRANSPARENT   = 0xFF000000

					// Mode for BSP_LCD_DisplayStringAt
 CENTER_MODE            = 0x01		// Aligns the text to the center of the specified area on the LCD
 RIGHT_MODE             = 0x02  	// Aligns the text to the right
 LEFT_MODE              = 0x03  	// Aligns the text to the left

myFunc:
					// we begin the game with the player placing an X active
	LDR r7,=0

					// Clear the screen and makes it a white background
	LDR	r0, =LCD_COLOR_WHITE
	BL	BSP_LCD_Clear

					// BSP_LCD_SetTextColor(LCD_COLOR_BLUE);
	LDR	r0, =LCD_COLOR_BLUE
	BL	BSP_LCD_SetTextColor // this is used to draw blue grid squares

					// BSP_LCD_DrawRect(x,y,width,height); draws the top left square of the 9 square grid
					// I am leaving a 50 pixel margin around my grid
	LDR	r0, =50
	LDR	r1, =50
	LDR	r2, =70
	LDR	r3, =70
	BL	BSP_LCD_DrawRect

					// Draws the top center square
	LDR	r0, =120
	LDR	r1, =50
	LDR	r2, =70
	LDR	r3, =70
	BL	BSP_LCD_DrawRect
	
					// Draws the top right square
	LDR	r0, =190
	LDR	r1, =50
	LDR	r2, =70
	LDR	r3, =70
	BL	BSP_LCD_DrawRect

					// Draws the middle left square
	LDR	r0, =50
	LDR	r1, =120
	LDR	r2, =70
	LDR	r3, =70
	BL	BSP_LCD_DrawRect

					// Drawn the middle middle square
	LDR	r0, =120
	LDR	r1, =120
	LDR	r2, =70
	LDR	r3, =70
	BL	BSP_LCD_DrawRect

					// Draw the middle right square
	LDR	r0, =190
	LDR	r1, =120
	LDR	r2, =70
	LDR	r3, =70
	BL	BSP_LCD_DrawRect

					// Draw the bottom left square
	LDR	r0, =50
	LDR	r1, =190
	LDR	r2, =70
	LDR	r3, =70
	BL	BSP_LCD_DrawRect

					// Draw the bottom middle square
	LDR	r0, =120
	LDR	r1, =190
	LDR	r2, =70
	LDR	r3, =70
	BL	BSP_LCD_DrawRect

					// Draw the bottom right square
	LDR	r0, =190
	LDR	r1, =190
	LDR	r2, =70
	LDR	r3, =70
	BL	BSP_LCD_DrawRect

loop:

	BL	checkForTouch		// check if user is touching the LCD screen
	CMP	r0, #0
	BEQ	loop			// if no touch, loop

					// Checks whose turn it is
	CMP 	r7, #0 			// Checking if the X player is active
	BEQ 	tic
	CMP 	r7, #1			// Checking if the O player is active
	BEQ 	tac

tic:
    	MOV 	r7, #1 			// Changes from X player to O player being active
    	B 	continue
tac:
	MOV 	r7, #0 			// Changes from O player to X player being active
	B 	continue

continue:
	BL	touchX			// get x coordinate
					// make sure x coordinate isn't too small (or program will crash)
					// if a touch is registered between pixles of x cordinates 0-60 set that touch to 60
					// the reason I am doing this is that I found that the program would crash 
					// whenever I touched on the top (y) or left (x) edge of the screen within 60 pixels
					// I am not sure why but I found that adding the code to set the x or y value to 60 when less than 60 stopped the crashes
	CMP 	r0,#60
	BHI	x_rangeOK
	MOV	r0,#60

x_rangeOK:
	MOV	r4, #85	    		// change x coordinate to new coordinate
	CMP 	r0, #100
	BLO 	checky      		// if touch is between 0 and 99 touch is in left column
					// I made the touch areas different from the drawn grid because I found that the center box touch area
					// was not registering correctly until I made it bigger.
					// This failure combined with the edge touch crashes makes me think there is an issue with the check for touch algorithm.
	MOV 	r4, #155
	CMP 	r0, #210
	BLO 	checky      		// if touch is between 100 and 209 touch is in middle column
	MOV 	r4, #225    		// else touch is in right column
checky:
	BL	touchY	    		// get y coordinate
			    		// make sure y coordinate isn't too small (or program will crash)
	CMP 	r0,#60
	BHI	y_rangeOK

	MOV	r0,#60
y_rangeOK:
	MOV	r5,#85			// change y coordinate to new coordinate
	CMP 	r0, #100    		// if touch is between 0 and 99 touch is in top row
	BLO 	waitForTouchRelease
	MOV 	r5, #155
	CMP 	r0, #200   		// if touch is between 100 and 199 touch is in middle row
	BLO 	waitForTouchRelease
	MOV 	r5, #225   		// else touch is in bottom row

waitForTouchRelease:
	BL	checkForTouch
	CMP	r0, #0
	BNE	waitForTouchRelease


	LDR	r0, =LCD_COLOR_WHITE
	BL	BSP_LCD_SetTextColor
					// This area is drawing a solid white square within my blue grid outline
	MOV	r0, r4
	SUB 	r0, #33
	MOV	r1, r5
	SUB 	r1, #33
	LDR	r2, =66
	LDR	r3, =66
	BL	BSP_LCD_FillRect

	CMP 	r7, #0
	BEQ 	circle
	CMP 	r7, #1
	BEQ 	exe

					// draw green O
circle:
					// BSP_LCD_SetTextColor(LCD_COLOR_GREEN);
	LDR	r0, =LCD_COLOR_GREEN
	BL	BSP_LCD_SetTextColor
					// BSP_LCD_DrawCircle(x,y,radius);
	MOV	r0, r4
	MOV 	r1, r5
	LDR	r2, =30
	BL	BSP_LCD_DrawCircle
	B 	loop

					// draw red X
exe:
					// BSP_LCD_SetTextColor(LCD_COLOR_RED);
	LDR	r0, =LCD_COLOR_RED
	BL	BSP_LCD_SetTextColor

					// BSP_LCD_DrawLine(x1,y1,x2,y2)
	MOV	r0, r4
	SUB 	r0, #30
	MOV	r1, r5
	ADD	r1, #30
	MOV 	r2, r4
	ADD 	r2, #30
	MOV 	r3, r5
	SUB 	r3, #30
	BL	BSP_LCD_DrawLine

	MOV	r0, r4
	SUB 	r0, #30
	MOV	r1, r5
	SUB 	r1, #30
	MOV 	r2, r4
	ADD 	r2, #30
	MOV 	r3, r5
	ADD 	r3, #30
	BL	BSP_LCD_DrawLine
	B 	loop

					// delayLoop - use a loop to cause a delay
delayLoop:
	ADDS 	r0, #-1			// decrement r0
	BNE	delayLoop
	BX	LR			// return from subroutine
stop:
	B	stop			// infinite loop!
 .end

