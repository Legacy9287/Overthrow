private ["_town","_posTown","_groups","_group","_numNATO","_pop","_count","_range"];
if (!isServer) exitwith {};

_count = 0;
_town = _this;

private _abandoned = server getVariable ["NATOabandoned",[]];
if (_town in _abandoned) exitWith {};

_posTown = server getVariable _town;

_groups = [];

_numNATO = server getVariable format["garrison%1",_town];
_count = 0;
_range = 300;
_pergroup = 4;
			
while {_count < _numNATO} do {
	_groupcount = 0;
	_group = createGroup west;				
	_groups pushBack _group;
	
	_start = [[[_posTown,_range]]] call BIS_fnc_randomPos;
	_civ = _group createUnit [OT_NATO_Unit_PoliceCommander, _start, [],0, "NONE"];
	_civ setVariable ["garrison",_town,false];
	[_civ] joinSilent _group;
	_civ setRank "CORPORAL";
	_civ setBehaviour "SAFE";
	[_civ,_town] call initGendarm;
	_count = _count + 1;
	_groupcount = _groupcount + 1;

	while {(_groupcount < _pergroup) and (_count < _numNATO)} do {							
		_pos = [[[_start,50]]] call BIS_fnc_randomPos;
		
		_civ = _group createUnit [OT_NATO_Unit_Police, _pos, [],0, "NONE"];
		_civ setVariable ["garrison",_town,false];
		[_civ] joinSilent _group;
		_civ setRank "PRIVATE";
		[_civ,_town] call initGendarm;
		_civ setBehaviour "SAFE";
		
		_groupcount = _groupcount + 1;
		_count = _count + 1;

	};				
	_group call initGendarmPatrol;		
	_range = _range + 50;
};



_groups