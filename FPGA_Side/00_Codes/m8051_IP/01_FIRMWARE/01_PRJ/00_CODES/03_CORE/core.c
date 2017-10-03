#include <delay.h>
#include <mem.h>
#include <core.h>
//==================================================

void init_sys( char mode )
{
	P2=0xFF;		//ALL'RE INPUTS
	//-------------------
	P0=0;				//ALL'RE OUTPUTS
	P1=0;				//ALL'RE OUTPUTS
	
	/////////////////////////////////////////////////
	blink_yellow(20,75); //fast blink
	
	/////////////////////////////////////////////////
	reset_deep();
	
	/////////////////////////////////////////////////
	reset_i3c();
	
	/////////////////////////////////////////////////
	delay_ms(500);
	
	/////////////////////////////////////////////////
	blink_yellow(20,25); //fast blink
	
	/////////////////////////////////////////////////
}

//======================================================================================
void reset_deep()
{
	trig_deep_nrst=0;
	delay_ms(1);
	trig_deep_nrst=1;
}

//======================================================================================
void reset_i3c()
{
	trig_i3c_nrst=0;
	delay_ms(1);
	trig_i3c_nrst=1;	
}

//======================================================================================
void blink_yellow(int count, int delay)
{
	for(i=0;i<count;i++)
	{
		LED_Y = ~LED_Y;
		delay_ms(delay);
	}
}
