/*
 * AlgoTester.h
 *
 *  Created on: 28. feb. 2018
 *      Author: Kim Bjerge
 */

#ifndef ALGOTESTER_H_
#define ALGOTESTER_H_
#include "Algorithm.h"

class AlgoTester {
public:
	AlgoTester(Algorithm *pAlgo);
	short runTestDyn(char *inFileName, char *outFileName, char *fftFileName);
	short runTest(char *inFileName, char *outFileName);

private:
	short readSignal(short buffer[], char *name);
	short writeSignal(short buffer[], char *name);
	Algorithm *m_pAlgo;
};

#endif /* ALGOTESTER_H_ */

