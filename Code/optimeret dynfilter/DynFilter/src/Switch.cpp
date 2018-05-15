///////////////////////////////////////////////////////////
//  Switch.cpp
//  Implementation of Switch
//  Created on:      06-aug-2014 09:30:58
//  Original author: kbe
///////////////////////////////////////////////////////////
#include "Controller.h"

// Controller reference
Controller *pCtrlRight = 0;
Controller *pCtrlLeft = 0;

void InitSwitch(Controller *left, Controller *right)
{
	pCtrlLeft = left;
	pCtrlRight = right;
}

extern "C" {

    void PressedSwitch(short sw)
    {
    	if (pCtrlLeft) pCtrlLeft->pressedSwitch(sw);
    	if (pCtrlRight) pCtrlRight->pressedSwitch(sw);
    }

}
