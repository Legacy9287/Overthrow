
private ["_carry","_supply"];
_carry = 0;
if(_this isKindOf "Bag_Base") then {
	_carry = getNumber(configfile >> "CfgVehicles" >> _this >> "maximumLoad");
}else{
	_supply = getText(configfile >> "CfgWeapons" >> _this >> "ItemInfo" >> "containerClass");
	_carry = getNumber(configfile >> "CfgVehicles" >> _supply >> "maximumLoad");
};
_carry;