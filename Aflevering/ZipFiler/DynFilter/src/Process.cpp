///////////////////////////////////////////////////////////
//  Process.cpp
//  Implementation of Process
//  Created on:      06-aug-2014 09:30:58
//  Original author: kbe
///////////////////////////////////////////////////////////
#include "HAL.h"
#include "Algorithm.h"

Algorithm *pAlgoLeft = 0;
Algorithm *pAlgoRight = 0;

void InitProcess(Algorithm *left, Algorithm *right)
{
	pAlgoLeft = left;
	pAlgoRight = right;
}

extern "C" {

	// Interface to SPORT interrupt
	void Process(void)
	{
		/* Not used - extra channel Ch1 left/right
		int i;
		for (i=0; i<INPUT_SIZE; i++)
		{
			sCh1LeftOut[i] = sCh1LeftIn[i];
			sCh1RightOut[i] = sCh1RightIn[i];
		}
		*/

		if (pAlgoLeft) pAlgoLeft->process(sCh0LeftIn, sCh0LeftOut, INPUT_SIZE);
		if (pAlgoRight) pAlgoRight->process(sCh0RightIn, sCh0RightOut, INPUT_SIZE);
	
	}

}
