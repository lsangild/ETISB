///////////////////////////////////////////////////////////
//  Controller.cpp
//  Implementation of the Class Controller
//  Created on:      06-aug-2014 23:31:01
//  Original author: kbe
///////////////////////////////////////////////////////////

#include "Controller.h"

Controller::Controller(DynamicFilter *dyn) : m_parVal(0)
{
	m_dyn = dyn;
}

Controller::~Controller()
{

}

void Controller::updateUI()
{
	SetMaskLed(0x0f, 0);
}


void Controller::incParamValue()
{
    int val = ++m_parVal;
	// Update LED UI
	unsigned char tmp = (val > 2 ? val: val*10);
	SetMaskLed(0x38, tmp & 0x07);
}

void Controller::decParamValue()
{
	int val = 0;
	if (m_parVal > 0)
    	val = --m_parVal;

	// Update LED UI
	unsigned char tmp = (val > 2 ? val: val*10);
	SetMaskLed(0x38, tmp & 0x07);
}

void Controller::pressedSwitch(short sw)
{
	switch (sw) {
		case KEY_SW4:
			incParamValue(); // Increment selected parameter value
			break;
		case KEY_SW5:
			decParamValue(); // Decrement selected parameter value
			break;
		case KEY_SW6:
			break;
		case KEY_SW7:
			break;
	}
}

