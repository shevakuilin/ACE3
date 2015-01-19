/*
	fnc_DustHandler.sqf

	Author: Garth de Wet (LH)

	Description:
	Determines whether to place dust on the goggles, based on calibre of weapon fired and other requirements.

	Parameters:
	0: Object - unit - eventhandler was attached to.			(Used)
	1: String - weapon - Weapon fired							(Used)

	Returns:
	Nothing

	Example:
	ace_player addEventHandler ["Fired", {[_this select 0, _this select 1] call FUNC(DustHandler;}];
	See http://community.bistudio.com/wiki/ArmA_3:_Event_Handlers#Fired
*/
#include "script_component.hpp"
private ["_bullets", "_position", "_surface", "_found", "_weapon", "_cloudType", "_unit"];
EXPLODE_2_PVT(_this,_unit,_weapon);
if (_unit != ace_player) exitWith {true};
_cloudType = "";

if (rain > 0.1) exitWith {true};
if ((stance _unit) != "PRONE") exitWith {true};

if (isClass(configFile >> "CfgWeapons" >> _weapon >> "GunParticles" >> "FirstEffect")) then {
	_cloudType = getText(configFile >> "CfgWeapons" >> _weapon >> "GunParticles" >> "FirstEffect" >> "effectName");
} else {
	if (isClass(configFile >> "CfgWeapons" >> _weapon >> "GunParticles" >> "effect1")) then {
		_cloudType = getText(configFile >> "CfgWeapons" >> _weapon >> "GunParticles" >> "effect1" >> "effectName");
	};
};

if (_cloudType == "") exitWith {true};

_position = getPosATL _unit;

if (surfaceIsWater _position) exitWith {};
if ((_position select 2) > 0.2) exitWith {};

_surface = surfaceType _position;
_surface = ([_surface, "#"] call CBA_fnc_split) select 1;
_found = false;

_found = getNumber (ConfigFile >> "CfgSurfaces" >> _surface >> "dust") >= 0.1;

if (!_found) exitWith {};

_bullets = GETDUSTT(DBULLETS);

if ((diag_tickTime - GETDUSTT(DTIME)) > 1) then {
	_bullets = 0;
};

_bullets = _bullets + 1;
SETDUST(DBULLETS,_bullets);
SETDUST(DTIME,diag_tickTime);

if (GETDUSTT(DAMOUNT) < 2) then {
	private "_bulletsRequired";
	_bulletsRequired = 100;
	if (isNumber (ConfigFile >> _cloudType >> "ACE_Goggles_BulletCount")) then {
		_bulletsRequired = getNumber (ConfigFile >> _cloudType >> "ACE_Goggles_BulletCount");
	};

	if (_bulletsRequired <= _bullets) then {
		SETDUST(DACTIVE,true);
		call FUNC(applyDust);
	};
};
true
