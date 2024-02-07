

// Gun store Robbery

private _robbed = false;
private _coolDown = time - 60;
private _isActive = missionNamespace getVariable ["_isActive", false];
private _getCooldown = missionNamespace getVariable ["_onCooldown", time - 60];
private _i = 15;
private _gunList = ["arifle_CTAR_blk_F", "arifle_AK12U_lush_holo_snds_pointer_F", "sgun_HunterShotgun_01_sawedoff_F", "SMG_05_F", "hgun_P07_khk_Snds_F"];
private _ammoList = ["30Rnd_580x42_Mag_F", "30Rnd_762x39_AK12_Lush_Mag_F", "2Rnd_12Gauge_Slug", "30Rnd_9x21_Mag_SMG_02", "16Rnd_9x21_Mag"];
private _weaponChose = random 4;

if ((time - _getCooldown) < 60) exitWith {
	hint"Recently robbed, come back later";
};
if (missionNamespace getVariable ["_isActive", false]) exitWith {};
missionNamespace setVariable ["_isActive", true];
while { _i>0 } do {
	_i = _i - 1;
	if !(alive player) exitWith {
		hint"You're leaking blood homie, he aint scared of you";
		uiSleep 5;
		hintSilent "";
	};
	if ((player distance civGun)>10) exitWith {
		hint"You ran away homie! You must stay within 10m";
		uiSleep 5;
		hintSilent "";
	};
	if ((weapons player) isEqualTo []) exitWith {
		hint"First time? You dropped your gun holmes! He aint scared of you now!";
		uiSleep 5;
		hintSilent "";
	};
	if (_i isEqualTo 1) exitWith {
		hint"GRAB THE GUN BEFORE THE CASE LOCKS!";
		_robbed = true;
		uiSleep 5;
		hintSilent"";
	};
	uiSleep 1;
	hint format ["Robbery Countdown %1", _i];
	if (_i isEqualTo 14) then {
		player playMove "";
	};
};
if (_robbed isEqualTo true) then {
	private _gun = _gunList select _weaponChose;
	private _ammo = _ammoList select _weaponChose;
	gunStoreRobbery addWeaponCargo [_gun, 1];
	gunStoreRobbery addMagazineCargo [_ammo, 3];
	missionNamespace setVariable ["_onCooldown", time];
	missionNamespace setVariable ["_isActive", false];
	uiSleep 120;
	clearWeaponCargo gunStoreRobbery;
	clearMagazineCargo gunStoreRobbery;
};

