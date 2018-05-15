/*
 * IIRFilter.cpp
 *
 *  Created on: 28. feb. 2018
 *      Author: Kim Bjerge
 */
#include <cmath>
#include "IIRFilter.h"
#include <cycle_count.h>
#include <string.h>

#include <stdio.h>

const float PI_FLOAT  = 3.1415926535897932;


IIRFilter::IIRFilter()
{
	// Clear coefficients and delay lines
	for (short i = 0; i < NUM_IIR_COEFFS; i++) {
		bq.a[i] = 0;
		bq.b[i] = 0;
		if (i < NUM_IIR_COEFFS-1) {
			bq.x[i] = 0;
			bq.y[i] = 0;
		}
	}
}

void IIRFilter::process(short* input, short* output, short len)
{
	// Performs 2. order IIR filtering using Native fractional types
	fract *x = (fract *)input;
	fract *y = (fract *)output;
	accum ylf;
	for (short i = 0; i < len; i++) {
		ylf = bq.b[0]*x[i] + bq.b[1]*bq.x[0] + bq.b[2]*bq.x[1] - bq.a[1]*bq.y[0] - bq.a[2]*bq.y[1];
	    bq.y[1] = bq.y[0];
	    bq.y[0] = ylf<<1;
	    y[i] = (fract)bq.y[0];
	    bq.x[1] = bq.x[0];
	    bq.x[0] = x[i];
	}
}

void IIRFilter::makeNotch (const float sampleRate,
                   	       const float cutOffFrequency,
                           const float r)
{
	cycle_t start_count2;
	cycle_t final_count2;
    float a[NUM_IIR_COEFFS];
    float b[NUM_IIR_COEFFS];
    const float w0 = 2 * PI_FLOAT * (cutOffFrequency / sampleRate);

	START_CYCLE_COUNT(start_count2);
    a[0] = 1;
    a[1] = -2 * r * cos(w0);
    a[2] = r * r;
    b[0] = 1;
    b[1] = -2 * cos(w0);
    b[2] = 1;
	//STOP_CYCLE_COUNT(final_count2,start_count2);
	//PRINT_CYCLES("COEF-CALC ",final_count2);

    for (short i = 0; i < NUM_IIR_COEFFS; i++) {
    	bq.a[i] = a[i]/2;
    	bq.b[i] = b[i]/2;
    }
	STOP_CYCLE_COUNT(final_count2,start_count2);
	PRINT_CYCLES("COEF-CALC ",final_count2);
}

void IIRFilter::create(void)
{
	// Initialization of coefficients
	for (short i = 0; i < NUM_IIR_COEFFS; i++) {
		bq.a[i] = 0;
		bq.b[i] = 0;
	}
	//bq.a[0] = FRACT_MAX;
	//bq.b[0] = FRACT_MAX;
}
