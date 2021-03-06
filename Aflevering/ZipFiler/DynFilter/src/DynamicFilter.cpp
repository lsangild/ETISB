///////////////////////////////////////////////////////////
//  DynamicFilter.cpp
//  Implementation of the Class Equalizer
//  Created on:      13-marts-2018 10:15:01
//  Original author: kbe
///////////////////////////////////////////////////////////

#include "DynamicFilter.h"
#include <cmath>
#include "AlgoTester.h"
#include <string.h>
#include <stdio.h>
#include <cycle_count.h>
#include <complex.h>
#include <fract2float_conv.h>

// Used for debugging
//fract16	m_real_magnitude[FFT_SIZE];

 // TODO Threshold value to be adjusted
#define PEAK_THRESHOLD   50
#define fs 48000
const float PI_FLOAT  = 3.1415926535897932;

DynamicFilter::DynamicFilter(int sampleRate):m_IIRFilter()
{
	m_sampleRate = sampleRate;
	m_fnotch = 0.0;
	m_updateNotch = false;
}

DynamicFilter::~DynamicFilter(){

}

void DynamicFilter::process(short* input, short* output, short len)
{
	fract16 meanFreq = 0;
	int block_exponent;
	cycle_t start_count;
	cycle_t final_count;
/*
	// Perform notch filtering
	START_CYCLE_COUNT(start_count);
	m_IIRFilter.process(input, output, len);
	STOP_CYCLE_COUNT(final_count,start_count);
	PRINT_CYCLES("Number of cycles for filter-process: ",final_count);*/


	START_CYCLE_COUNT(start_count);
	rfft_fr16(input, m_fft_output, m_twiddle_table, 1, len, &block_exponent, 1);
	//fft_magnitude_fr16 (m_fft_output, m_real_magnitude, len, block_exponent, 1);
	//short error = writeSignal(m_fft_output,  "..\\src\\y_signal470.txt");
	meanFreq = hilbert();
	STOP_CYCLE_COUNT(final_count,start_count);
	PRINT_CYCLES("Hilbert cycles: ",final_count);


	START_CYCLE_COUNT(start_count);
	sineGenerator(meanFreq);
	//findMax(PEAK_THRESHOLD);
	STOP_CYCLE_COUNT(final_count,start_count);
	PRINT_CYCLES("Sinegenerator cycles: ",final_count);


 }
void DynamicFilter::sineGenerator(fract16 meanFreq){
	//int Amp = 1;
	fract32 freq = meanFreq;
	fract16 phi = 0;
	fract32 t = 0;
	fract32 deltaT;
	float k = (2*PI_FLOAT)/9;
	deltaT = float_to_fr32(k);
	fract32 newSine[183];
	fract32 piFract = float_to_fr32(PI_FLOAT);

	for(int i = 0 ; i < 183 ; i++){
		fract32 temp = sin_fr32(2 * piFract * freq * t + phi);

		newSine[i] = temp;
		t += deltaT;
	}

}

short DynamicFilter::writeSignal(complex_fract16 buffer[], char *name)
{
	short error = -1;
	FILE *fp;

	fp=fopen(name, "w");
	if (fp)
	{
		for(short n=0; n < N_FFT; n++)
			fprintf(fp, "%d+%di,\n", buffer[n].re, buffer[n].im);
		fclose(fp);
		error = 0;
	}
	return error;
}
short DynamicFilter::writeSignal_fr16(fract16 buffer[], char *name)
{
	short error = -1;
	FILE *fp;

	fp=fopen(name, "w");
	if (fp)
	{
		for(short n=0; n < N_FFT; n++)
			fprintf(fp, "%hd,\n", buffer[n]);
		fclose(fp);
		error = 0;
	}
	return error;
}

fract16 DynamicFilter::hilbert(){
	// parameters
	int block_exponent;
	fract16 instafreq[N_FFT];
	fract16 meanFreq;
	fract32 temp = 0;
	uint16_t dif;
	complex_fract16 scale;
	fract32 temp32[512];
	scale.re=0.5; scale.im=0.5;

	// Hilbert transform
	zHilbert[0] = cmlt_fr16(m_fft_output[0], scale);

	for (int i = 1; i<N_FFT/2; i++){
		zHilbert[i] = m_fft_output[i];
	}

	zHilbert[N_FFT/2] = cmlt_fr16(m_fft_output[N_FFT/2], scale);

	// ifft of the hilbert signal
	ifft_fr16(zHilbert, m_ifft_output, m_twiddle_table, 1, N_FFT, &block_exponent, 1);
	short error = writeSignal(m_ifft_output,  "..\\src\\y_ifft.txt");

	////// instant frequency finding //////
	//first finding the phase
	for (int i = 0; i<N_FFT; i++){
		instafreq[i] = atan2_fr16(m_ifft_output[i].im,m_ifft_output[i].re);
	}

	// unwrapping with threshold 2PI
	temp32[0] = instafreq[0];
    for(int i = 1; i<N_FFT;i++){
    	dif = (((int16_t)instafreq[i - 1] - (int16_t)instafreq[i]) + (1 << 15)) % (2 * (1 << 15)); //1<<15 = pi

       	temp32[i] = ((int32_t)(dif - (1 << 15)));

    	temp32[i] = sub_fr1x32(temp32[i-1],	temp32[i]); // optimering
    }

    // find the diff
    for(int i = 1; i<N_FFT;i++){
    	temp32[i-1] = (sub_fr1x32(temp32[i],temp32[i-1])) * fs/(2*PI_FLOAT); //optimering
    }

    //finding the mean and therefore the value
    for(int i = 100; i<N_FFT-99;i++){
    	temp += temp32[i];
    }

    meanFreq = ((temp/(N_FFT-200)) * PI_FLOAT) / (1<<15);

    return(meanFreq);
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
