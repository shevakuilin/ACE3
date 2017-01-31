/*
 * Author: Glowbal
 * Calculate the blood pressure of a unit.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * ReturnValue:
 * 0: BloodPressure Low <NUMBER>
 * 1: BloodPressure High <NUMBER>
 *
 * Public: No
 */

#include "script_component.hpp"

// Value is taken because with cardic output and resistance at default values, it will put blood pressure High at 120.
#define MODIFIER_BP_HIGH    13.7142792

// Value is taken because with cardic output and resistance at default values, it will put blood pressure Low at 80.
#define MODIFIER_BP_LOW     9.1428528

params ["_unit"];

private _cardiacOutput = [_unit] call FUNC(getCardiacOutput);
private _resistance = _unit getVariable [QGVAR(peripheralResistance), DEFAULT_PERIPHERAL_RESISTANCE];
private _bloodPressure = _cardiacOutput * _resistance;

[round(_bloodPressure * MODIFIER_BP_LOW), round(_bloodPressure * MODIFIER_BP_HIGH)]
