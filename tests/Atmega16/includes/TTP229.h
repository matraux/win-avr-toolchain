#ifndef TTP229_HPP
#define TTP229_HPP

#include <util/delay.h>
#include "GPIO_AVR.h"

/**
 * @file TTP229.h
 * @brief Ovladač pro TTP229 s kapacitní klávesnicí
 */
class TTP229
{
	protected:
		volatile uint8_t *portSCL;
		volatile uint8_t *portSDO;
		uint8_t pinSCL;
		uint8_t pinSDO;

	public:
		/**
		 * @brief Nastaví konfiguraci
		 *
		 * @param sclPort Adresa portu SCL(např. &PORTA)
		 * @param sclPin Číslo pinu SCL (např. PA3)
		 * @param sdoPort Adresa portu SDO (např. &PORTA)
		 * @param sdoPin Číslo pinu SDO (např. PA3)
		 */
		TTP229(
				volatile uint8_t *sclPort,
				uint8_t sclPin,
				volatile uint8_t *sdoPort,
				uint8_t sdoPin)
		{
			this->portSCL = sclPort;
			this->pinSCL = sclPin;
			this->portSDO = sdoPort;
			this->pinSDO = sdoPin;
		}

		/**
		 * @brief Inicializuje periferie TTP229
		 */
		void init()
		{
			// SCL as output, idle LOW
			GPIO::output(this->portSCL, this->pinSCL);
			GPIO::set(this->portSCL, this->pinSCL, false);

			// SDO as input with pull-up
			GPIO::input(this->portSDO, this->pinSDO);
			GPIO::set(this->portSDO, this->pinSDO, true);
		}

		/**
		 * @brief Vrací stiknutou klávesu
		 */
		uint8_t get()
		{
			uint8_t key = 0;

			for (uint8_t n = 1; n <= 16; ++n) {
				GPIO::set(this->portSCL, this->pinSCL, true);
				_delay_us(5);

				if (GPIO::get(this->portSDO, this->pinSDO)) {
					key = n;
				}

				GPIO::set(this->portSCL, this->pinSCL, false);
				_delay_us(5);
			}

			return key;
		}
};

#endif