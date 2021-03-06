private ["_unit"];

_unit = _this select 0;

removeAllWeapons _unit;
removeAllAssignedItems _unit;
removeGoggles _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeVest _unit;

{[_unit, (OT_faces_local call BIS_fnc_selectRandom)] remoteExec ["setAIFace", 0, _unit]};
{[_unit, "NoVoice"] remoteExec ["setAISpeaker", 0, _unit]};

_unit forceAddUniform (OT_clothes_carDealers call BIS_fnc_selectRandom);

_unit setvariable ["owner","self"];

_unit addEventHandler ["FiredNear", {
	_u = _this select 0;	
	_u setUnitPos "DOWN";
}];