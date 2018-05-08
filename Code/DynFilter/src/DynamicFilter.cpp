///////////////////////////////////////////////////////////
//  DynamicFilter.cpp
//  Implementation of the Class Equalizer
//  Created on:      13-marts-2018 10:15:01
//  Original author: kbe
///////////////////////////////////////////////////////////

#include "DynamicFilter.h"

//#include <string.h>
#include <stdio.h>
#include <cycle_count.h>


// Used for debugging
//fract16	m_real_magnitude[FFT_SIZE];

 // TODO Threshold value to be adjusted
#define PEAK_THRESHOLD   50
const float PI_FLOAT  = 3.1415926535897932;

DynamicFilter::DynamicFilter(int sampleRate):m_IIRFilter()
{
	m_sampleRate = sampleRate;
	m_fnotch = 0.0;
	m_updateNotch = false;
}

DynamicFilter::~DynamicFilter(){

}

/*void DynamicFilter::hilbert(){
	// parameters
	int block_exponent;
	fract16 instafreq[N_FFT];
	complex_fract16 scale;
	scale.re=2; scale.im=0;

	// Hilbert transform
	zHilbert[0] = m_fft_output[0];
	for (int i = 1; i<N_FFT/2; i++){
		//zHilbert[i] = cmlt_fr16(m_fft_output[i], scale);
	}
	zHilbert[N_FFT/2] = m_fft_output[N_FFT/2];

	// ifft of the hilbert signal
	ifft_fr16(zHilbert, m_ifft_output, m_twiddle_table, 1, N_FFT, &block_exponent, 1);

	////// instant freqeunecy finding //////
	//first finding the phase
	for (int i = 0; i<N_FFT; i++){
		instafreq[i] = arg_fr16(m_ifft_output[i]);
	}
	// unwraping with threshold 2PI

	// find the diff

}*/

void DynamicFilter::process(short* input, short* output, short len)
{
	int block_exponent;
	/*cycle_t start_count;
	cycle_t final_count;

	// Perform notch filtering
	START_CYCLE_COUNT(start_count);
	m_IIRFilter.process(input, output, len); // ændres til pitch shift algorithme
	STOP_CYCLE_COUNT(final_count,start_count);
	PRINT_CYCLES("Number of cycles for filter-process: ",final_count);*/


	//START_CYCLE_COUNT(start_count);
	rfft_fr16(input, m_fft_output, m_twiddle_table, 1, len, &block_exponent, 1);
	fft_magnitude_fr16 (m_fft_output, m_real_magnitude, len, block_exponent, 1);
	//hilbert();


	//findMax(PEAK_THRESHOLD);
	//STOP_CYCLE_COUNT(final_count,start_count);
	//PRINT_CYCLES("Number of cycles for FFT part: ",final_count);


 }

void DynamicFilter::updateDynFilter(void)
{
	cycle_t start_count;
	cycle_t final_count;
	START_CYCLE_COUNT(start_count);
	if (m_updateNotch)
	{
		// TODO Change code to handle update of notch filter when new peak found
		m_IIRFilter.makeNotch(m_sampleRate, m_fnotch, 0.90);

		//m_IIRFilter.makeNotch(m_sampleRate, 1000, 0.95); // TODO for testing only 1 kHz notch, to be removed
		m_updateNotch = false;
	}
	STOP_CYCLE_COUNT(final_count,start_count);
	PRINT_CYCLES("Number of cycles making of filter coef: ",final_count);

}


// Find maximum peak in FFT magnitude response
void DynamicFilter::findMax(fract16 threshold)
{
	short i, i_max;
	fract16 max = 0;

	// TODO Verify and improve code below to
	// find maximum amplitude in frequency spectrum
	for (i = 1; i < FFT_SIZE; i++)
	{
		if (m_real_magnitude[i] > max)
		{
			i_max = i;
			max = m_real_magnitude[i_max];
		}
	}

	// Check maximum peak above threshold
	if (max >= threshold)
	{
		float fnotch = i_max * ((float)m_sampleRate / N_FFT);
		if (fnotch != m_fnotch)
		{
			m_fnotch = fnotch;
			// Signal to main loop update notch filter
			m_updateNotch = true;
		}
	}
}

void DynamicFilter::create(void) 
{
	// TODO Compute FFT twiddle factors
	twidfftrad2_fr16 (m_twiddle_table, N_FFT);

	// Clear FFT magnitude response
	for (int i = 0; i < FFT_SIZE; i++)
		m_real_magnitude[i] = 0;

	// Initialize IIR cascade filter
	m_IIRFilter.create();

	m_updateNotch = true;

	CYCLES_INIT(m_stats);
}
