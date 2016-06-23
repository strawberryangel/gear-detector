// This is a quick hack to demonstrate the concept. It sucks.

string EVIL_NAME = "Progeny";

integer detectProgeny(key avatar)
{
	list AttachedNames;
	list AttachedUUIDs = llGetAttachedList(avatar);
	integer i;

	integer isEvil = FALSE;
	integer count = llGetListLength(AttachedUUIDs);

	while (i < count )
	{
		key uuid = llList2Key(AttachedUUIDs,i);
		list temp = llGetObjectDetails(uuid, [OBJECT_NAME]);
		string name = llList2String(temp,0);

		if(llSubStringIndex(name, EVIL_NAME) >= 0)
		{
			isEvil = TRUE;
			i = count;
		}

		i++;
	}

	return isEvil;
}

restartScan()
{
	llSensorRepeat("", "", AGENT_BY_LEGACY_NAME, 96.0, PI, 20.0);
}


default
{
	sensor(integer total_number)
	{
		integer i = 0;
		while(i < total_number)
		{
			key avatar = llDetectedKey(i++);
			if(detectProgeny(avatar))
			{
				string username = llGetUsername(avatar);
				string display = llGetDisplayName(avatar);
				llOwnerSay("Alert: " + display + " (" + username + ") is evil.");
			}
		}

		restartScan();
	}
	state_entry()
	{
		restartScan();
	}
	touch_start(integer total_number)
	{
		llSensor("", "", AGENT_BY_LEGACY_NAME, 96.0, PI);
	}
}
