const int NINJA_ITEMLOCATOR_LANG = 0; // Will be set automatically

instance MenuItem_Ninja_ItemLocator_KeyMenu(C_MENU_ITEM_DEF)
{
    // Set the text display according to the language
    if (NINJA_ITEMLOCATOR_LANG == 1)
    { // DE (Windows 1252)
        text[0] = "Gegenst�nde Orten";
        text[1] = "Taste ENTF zum L�schen und RETURN zum definieren.";

        onSelAction[0]      	= /*SEL_ACTION_EXECCOMMANDS*/ 7;
        onSelAction_S[0]    	= "RUN MenuItem_Ninja_ItemLocator_InpMenu";
    }
    else if (NINJA_ITEMLOCATOR_LANG == 2)
    { // PL (Windows 1250)
        text[0] = "Zlokalizowa� Przedmioty";
        text[1] = "DEL - usuwa, ENTER - przypisuje klawisz.";

        onSelAction[0]      	= /*SEL_ACTION_EXECCOMMANDS*/ 7;
        onSelAction_S[0]    	= "RUN MenuItem_Ninja_ItemLocator_InpMenu";
    }
    else if (NINJA_ITEMLOCATOR_LANG == 3)
    { // RU (Windows 1251)
        text[0] = "������� ��������";
        text[1] = "������� DEL, ����� �������� ���� ��� ENTER, ����� ��������������.";

        onSelAction[0]      	= /*SEL_ACTION_EXECCOMMANDS*/ 7;
        onSelAction_S[0]    	= "RUN MenuItem_Ninja_ItemLocator_InpMenu";
    }
    else
    { // EN
        text[0] = "Locate Items";
        text[1] = "Press DEL to remove and ENTER to define a key.";

        onSelAction[0]      	= /*SEL_ACTION_EXECCOMMANDS*/ 7;
        onSelAction_S[0]    	= "RUN MenuItem_Ninja_ItemLocator_InpMenu";
    };
};

instance MenuItem_Ninja_ItemLocator_InpMenu(C_MENU_ITEM_DEF)
{
    // Set the text display according to the language
    if (NINJA_ITEMLOCATOR_LANG == 1)
    { // DE (Windows 1252)
        type       	 			= /*MENU_ITEM_INPUT*/ 3;
        text[1]     			= "Gew�nschte Taste bet�tigen.";

        onChgSetOption          = "keyLocateItems";
        onChgSetOptionSection   = "KEYS";
        flags                   = flags & ~/*IT_SELECTABLE*/ 4;
    }
    else if (NINJA_ITEMLOCATOR_LANG == 2)
    { // PL (Windows 1250)
        type       	 			= /*MENU_ITEM_INPUT*/ 3;
        text[1]     			= "Naci�nij ��dany klawisz.";

        onChgSetOption          = "keyLocateItems";
        onChgSetOptionSection   = "KEYS";
        flags                   = flags & ~/*IT_SELECTABLE*/ 4;
    }
    else if (NINJA_ITEMLOCATOR_LANG == 3)
    { // RU (Windows 1251)
        type       	 			= /*MENU_ITEM_INPUT*/ 3;
        text[1]     			= "����������, ������� ������� ��� ����� ��������.";

        onChgSetOption          = "keyLocateItems";
        onChgSetOptionSection   = "KEYS";
        flags                   = flags & ~/*IT_SELECTABLE*/ 4;
    }
    else
    { // EN
        type       	 			= /*MENU_ITEM_INPUT*/ 3;
        text[1]     			= "Press the desired key.";

        onChgSetOption          = "keyLocateItems";
        onChgSetOptionSection   = "KEYS";
        flags                   = flags & ~/*IT_SELECTABLE*/ 4;
    };
};
