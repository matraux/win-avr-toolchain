#define __AVR_ATmega16A__
#define F_CPU 8000000UL

#include <util/delay.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include "includes/TTP229.h"
#include "includes/GPIO_AVR.h"

#define lowICR 320
#define highICR 340
#define maxCycles 4

volatile uint8_t cycleCounter = 0;
volatile uint8_t active = false;

TTP229 touchKeyboard(&PORTA, PA3, &PORTA, PA2);

ISR(TIMER1_OVF_vect)
{
	if (cycleCounter++ > maxCycles) {
		OCR1A = 0;
	}
}

ISR(INT1_vect)
{
	active = active == true ? false : true;
}

void setup(void)
{
	// Nastavení Timer1 pro PWM
	TCCR1A = (1 << COM1A1) | (1 << WGM11);
	TCCR1B = (1 << WGM13) | (1 << CS11);  // Phase Correct PWM, prescaler 8
	ICR1 = 320;
	OCR1A = 0;

	// Povolení přerušení Timer1
	TIMSK |= (1 << TOIE1);

	// // PD5 (OC1A) jako výstup
	GPIO::output(&PORTD, PD5);

	// Nastavení externího přerušení INT1 (PD3)
	GPIO::input(&DDRD, PD3);

	PORTD |= (1 << PD3);   // pull-up
	MCUCR |= (1 << ISC11); // přerušení na sestupnou hranu
	GICR  |= (1 << INT1);  // povolit INT1

	sei(); // Globální povolení přerušení
}

void buzzer(uint16_t ICR)
{
	ICR1 = ICR;
	cycleCounter = 0;
	TCNT1 = 0;
	OCR1A = ICR1 / 2;
}

int main(void)
{
	setup();

	touchKeyboard.init();

	while (true) {

		uint8_t keys = touchKeyboard.get();

		for(uint8_t n = 0; n < keys; n++) {
			buzzer(lowICR);
			_delay_ms(250);
		}

	}
}
