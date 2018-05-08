/*
b * AlgoTester.cpp
 *
 *  Created on: 28. feb. 2018
 *      Author: Kim Bjerge
 */

#include <stdio.h>
#include "AlgoTester.h"
#include "DynamicFilter.h"

// Fixed signal size must be manually changed
#define 	N  1024  // Test signal length

// Test signal used for testing made as global variables for plotting
section("L1_data_a") short TestSignal[N]; // Test signal loaded from test input file
section("L1_data_a") short OutputSignal[N]; // Result after processing test signal with m_pAlgo

AlgoTester::AlgoTester(Algorithm *pAlgo)
{
	m_pAlgo = pAlgo;
}

short AlgoTester::readSignal(short buffer[], char *name)
{
	short error = -1;
	FILE *fp;
	short tmp;

	fp=fopen(name , "r");
	if (fp)
	{
		for(short n=0; n < N; n++) {
			fscanf(fp, "%hd,\n", &tmp);
			buffer[n] = tmp;
		}
		fclose(fp);
		error = 0;
	}
	return error;
}

short AlgoTester::writeSignal(short buffer[], char *name)
{
	short error = -1;
	FILE *fp;

	fp=fopen(name, "w");
	if (fp)
	{
		for(short n=0; n < N; n++)
			fprintf(fp, "%hd,\n", buffer[n]);
		fclose(fp);
		error = 0;
	}
	return error;
}

short AlgoTester::runTest(char *inFileName, char *outFileName)
{
	// Reading test signal in inFileName
	short error = readSignal(TestSignal, inFileName);
	if (error == 0)
	{
		// Test file loaded into TestSignal
		printf("Testing algorithm - input file %s with signal of %d samples\n", inFileName, N);

		// Processing algorithm on TestSignal
		m_pAlgo->process(TestSignal, OutputSignal, N);

		// Writing result from OutputSignal to outFileName
		error = writeSignal(OutputSignal, outFileName);

		if (error == 0)
			printf("Result signal of %d samples saved in %s \n", N, outFileName);
		else
			printf("Error writing result to file %s \n", outFileName);
	}
	else
		printf("Error reading file %s with input test signal\n", inFileName);

	return error;
}

short AlgoTester::runTestDyn(char *inFileName, char *outFileName, char *fftFileName)
{
	short error;
	short *pMagnitudes;
	DynamicFilter *pDynFilter;

	// Reading test signal in inFileName
	error = readSignal(TestSignal, inFileName);
	if (error == 0)
	{
		// Test file loaded into TestSignal
		printf("Testing algorithm - input file %s with signal of %d samples\n", inFileName, N);

		// Processing algorithm on TestSignal
		m_pAlgo->process(TestSignal, OutputSignal, N);

		// Writing result from OutputSignal to outFileName
		error = writeSignal(OutputSignal, outFileName);
		if (error == 0)
			printf("Result signal of %d samples saved in %s \n", N, outFileName);
		else
			printf("Error writing result to file %s \n", outFileName);

		// Read FFT magnitude response
		pDynFilter = (DynamicFilter*)m_pAlgo;
		pMagnitudes = (short*)pDynFilter->getMagnitudeResponse();

		// Writing result from pMagnitude to outFileName
		error = writeSignal(pMagnitudes, fftFileName);
		if (error == 0)
			printf("FFT magnitude of %d samples saved in %s \n", N, fftFileName);
		else
			printf("Error writing result to file %s \n", fftFileName);
	}
	else
		printf("Error reading file %s with input test signal\n", inFileName);

	return error;
}
