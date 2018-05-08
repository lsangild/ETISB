///////////////////////////////////////////////////////////
//  DynamicFilter.h
//  Implementation of the Class Equalizer
//  Created on:      13-marts-2018 10:15:01
//  Original author: kbe
///////////////////////////////////////////////////////////

#if !defined(_DYNAMIC_FILTER_INCLUDED_)
#define _DYNAMIC_FILTER_INCLUDED_

#include <filter.h>
#include <cycles.h>
//#include <complex.h>
#include "HAL.h"
#include "Algorithm.h"
#include "IIRFilter.h"

#define N_FFT   	INPUT_SIZE
#define FFT_SIZE 	(N_FFT/2)+1


class DynamicFilter : public Algorithm
{

public:

	DynamicFilter(int sampleRate);
	virtual ~DynamicFilter();

	//virtual void hilbert();
	virtual void process(short* input, short* output, short len);
	virtual void create(void);
	void updateDynFilter(void);
	fract16 *getMagnitudeResponse(void) {
		return m_real_magnitude;
	}

protected:

	void findMax(short threshold);

	complex_fract16    m_fft_output[N_FFT];
	complex_fract16    m_twiddle_table[N_FFT]; 
	complex_fract16 zHilbert[N_FFT];
	complex_fract16 m_ifft_output[N_FFT];
	fract16	m_real_magnitude[FFT_SIZE]; // Moved to *cpp file for debugging
	int m_sampleRate;
	bool m_updateNotch;
	float m_fnotch;

	IIRFilter m_IIRFilter;
	cycle_stats_t m_stats; // Used for cycle counter measure
};

#endif // !defined(_DYNAMIC_FILTER_INCLUDED_)
