private ["_buildings","_building","_gotbuilding","_price","_lease","_sell","_totaloccupants"];

_buildings =  _this nearObjects ["Building",30];
_gotbuilding = false;
_building = objNULL;
_price = 0;
_lease = 0;
_sell = 0;
_totaloccupants = 0;
_sorted = [_buildings,[_this],{_x distance _input0},"ASCEND"] call BIS_fnc_SortBy;

if(!isNil "modeTarget") then {
	_sorted = _sorted - [modeTarget];
};

{
	if ((typeof _x) in OT_allBuyableBuildings) exitWith {
		_gotbuilding = true;
		_town = (getpos _x) call nearestTown;
		_stability = ((server getVariable format["stability%1",_town]) / 100);
		_population = server getVariable format["population%1",_town];
		if(_population > 1000) then {_population = 1000};
		_population = (_population / 1000);
		_totaloccupants = 1;
				
		_baseprice = 400;
		_type = typeof _x;
		if !(_type in OT_spawnHouses) then {
			call {
				if(_type in OT_lowPopHouses) exitWith {_baseprice = 1000;_totaloccupants=4};
				if(_type in OT_mansions) exitWith {_baseprice = 25000;_totaloccupants=5;};
				if(_type in OT_medPopHouses) exitWith {_baseprice = 2000;_totaloccupants=6};
				if(_type in OT_highPopHouses) exitWith {_baseprice = 15000;_totaloccupants=12};
				if(_type in OT_hugePopHouses) exitWith {_baseprice = 25000;_totaloccupants=50};
				if(_type == OT_warehouse) exitWith {_baseprice = 3000;_totaloccupants=0};
			};				
		};
		_price = round(_baseprice + ((_baseprice * _stability * _population) * (1+OT_standardMarkup)));
		_sell = round(_baseprice + (_baseprice * _stability * _population));
		_lease = round((_stability * _population) * (_baseprice * _totaloccupants * 0.06));
		if !(_town in (server getvariable ["NATOabandoned",[]])) then {_lease = round(_lease * 0.4)};
		if(_lease < 1) then {_lease = 1};
		
		_building = _x;
	};
}foreach(_sorted);
_ret = false;
if(_gotbuilding) then {
	_ret = [_building,_price,_sell,_lease,_totaloccupants];
};
_ret