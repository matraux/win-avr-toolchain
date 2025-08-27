#ifndef GPIO_AVR_H
#define GPIO_AVR_H

#include <avr/io.h>
#include <stdbool.h>
#include <stdint.h>

class GPIO final {
	public:
		/**
		 * @brief Nastaví výstup pinu.
		 *
		 * @param port Adresa portu (např. &PORTA)
		 * @param pin Číslo pinu (např. PA3)
		 */
		static inline void output(volatile uint8_t* port, uint8_t pin) {
			*(port - 1) |= (1 << pin);
		}

		/**
		 * @brief Nastaví vstup pinu.
		 *
		 * @param port Adresa portu (např. &PORTA)
		 * @param pin Číslo pinu (např. PA3)
		 */
		static inline void input(volatile uint8_t* port, uint8_t pin) {
			*(port - 1) &= ~(1 << pin);
		}

		/**
		 * @brief Nastaví logickou úroveň pinu.
		 *
		 * @param port Adresa portu (např. &PORTA)
		 * @param pin Číslo pinu (např. PA3)
		 * @param high true = nastaví pin HIGH|Pull-up, false = nastaví pin LOW|floating
		 */
		static inline void set(volatile uint8_t* port, uint8_t pin, bool high) {
			high ? (*port |= (1 << pin)) : (*port &= ~(1 << pin));
		}

		/**
		 * @brief Přečte logickou úroveň pinu.
		 *
		 * @param port Adresa portu (např. &PORTA)
		 * @param pin Číslo pinu (např. PA3)
		 * @return true|false
		 */
		static inline bool get(volatile uint8_t* port, uint8_t pin) {
			return (*(port - 2) & (1 << pin)) != 0;
		}
};

#endif