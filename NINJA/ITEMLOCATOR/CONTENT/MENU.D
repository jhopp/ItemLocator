/*
 * Guess localization (0 = EN, 1 = DE, 2 = PL, 3 = RU)
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes#localization
 */
func int Ninja_ItemLocator_GuessLocalization() {
    var int pan; pan = MEM_GetSymbol("MOBNAME_PAN");
    if (pan) {
        var zCPar_Symbol panSymb; panSymb = _^(pan);
        var string panName; panName = MEM_ReadString(panSymb.content);
        if (Hlp_StrCmp(panName, "Pfanne")) { // DE (Windows 1252)
            return 1;
        } else if (Hlp_StrCmp(panName, "Patelnia")) { // PL (Windows 1250)
            return 2;
        } else if (Hlp_StrCmp(panName, "���������")) { // RU (Windows 1251)
            return 3;
        };
    };
    return 0; // Otherwise EN
};

/*
 * Set localization indicator in menu scripts
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func void Ninja_ItemLocator_SetMenuLocalization() {
    const int zCPar_SymbolTable__GetSymbol_G1 = 7316336; //0x6FA370
    const int zCPar_SymbolTable__GetSymbol_G2 = 8011328; //0x7A3E40

    var string symbolName; symbolName = "NINJA_ITEMLOCATOR_LANG";
    var int symTab; symTab = MEM_ReadInt(menuParserPointerAddress) + 16;
    var int namePtr; namePtr = _@s(symbolName);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(namePtr));
        CALL_PutRetValTo(_@(symbPtr));
        CALL__thiscall(_@(symTab), MEMINT_SwitchG1G2(zCPar_SymbolTable__GetSymbol_G1, zCPar_SymbolTable__GetSymbol_G2));
        call = CALL_End();
    };

    var int symbPtr;
    if (symbPtr) {
        var zCPar_Symbol symb; symb = _^(symbPtr);
        symb.content = Ninja_ItemLocator_GuessLocalization();
    };
};

/*
 * Create menu item from script instance name
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func int Ninja_ItemLocator_CreateMenuItem(var string scriptName) {
    const int zCMenuItem__Create_G1 = 5052784; //0x4D1970
    const int zCMenuItem__Create_G2 = 5105600; //0x4DE7C0

    var int strPtr; strPtr = _@s(scriptName);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(strPtr));
        CALL_PutRetValTo(_@(ret));
        CALL__cdecl(MEMINT_SwitchG1G2(zCMenuItem__Create_G1,
                                      zCMenuItem__Create_G2));
        call = CALL_End();
    };

    var int ret;
    return +ret;
};

/*
 * Copy essential properties from one to another menu entry
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func void Ninja_ItemLocator_CopyMenuItemProperties(var int dstPtr, var int srcPtr) {
    if (!dstPtr) || (!srcPtr) {
        return;
    };

    var zCMenuItem src; src = _^(srcPtr);
    var zCMenuItem dst; dst = _^(dstPtr);

    dst.m_parPosX = src.m_parPosX;
    dst.m_parPosY = src.m_parPosY;
    dst.m_parDimX = src.m_parDimX;
    dst.m_parDimY = src.m_parDimY;
    dst.m_pFont = src.m_pFont;
    dst.m_pFontSel = src.m_pFontSel;
    dst.m_parBackPic = src.m_parBackPic;
};

/*
 * Get maximum menu item height
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func int Ninja_ItemLocator_MenuItemGetHeight(var int itmPtr) {
    if (!itmPtr) {
        return 0;
    };

    var zCMenuItem itm; itm = _^(itmPtr);
    var int fontPtr; fontPtr = itm.m_pFont;

    const int zCFont__GetFontY_G1 = 7209472; //0x6E0200
    const int zCFont__GetFontY_G2 = 7902432; //0x7894E0

    var int fontHeight;
    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PutRetValTo(_@(fontHeight));
        CALL__thiscall(_@(fontPtr), MEMINT_SwitchG1G2(zCFont__GetFontY_G1,
                                                      zCFont__GetFontY_G2));
        call = CALL_End();
    };

    // Transform to virtual pixels
    MEM_InitGlobalInst();
    var zCView screen; screen = _^(MEM_Game._zCSession_viewport);
    fontHeight *= 8192 / screen.psizey;

    if (fontHeight > itm.m_parDimY) {
        return fontHeight;
    } else {
        return itm.m_parDimY;
    };
};

/*
 * Insert value into array at specific position
 * Source: https://github.com/szapp/Ninja/wiki/Inject-Changes
 */
func void Ninja_ItemLocator_ArrayInsertAtPos(var int zCArray_ptr,
                                             var int pos,
                                             var int value) {
    const int zCArray__InsertAtPos_G1 = 6267728; //0x5FA350
    const int zCArray__InsertAtPos_G2 = 6458144; //0x628B20

    var int valuePtr; valuePtr = _@(value);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_IntParam(_@(pos));
        CALL_PtrParam(_@(valuePtr));
        CALL__thiscall(_@(zCArray_ptr), MEMINT_SwitchG1G2(zCArray__InsertAtPos_G1,
                                                          zCArray__InsertAtPos_G2));
        call = CALL_End();
    };
};

/*
 * Menu initialization function called by Ninja when a menu is opened
 */
func void Ninja_ItemLocator_Menu(var int menuPtr)
{    
    MEM_InitAll();

    // Only on game start
    const int once = 0;
    if (!once) 
    {
        once = 1;     

        // Read INI Settings
        MEM_Info("Initializing ItemLocator entries in Gothic.ini.");

        // Set default Locate Items key if it doesn't exist yet
        if (!MEM_GothOptExists("KEYS", "keyLocateItems"))
        {
            MEM_SetKey("keyLocateItems", KEY_V);
        };

        // Set radius global constant.
        if (!MEM_GothOptExists("ITEMLOCATOR", "radius"))
        {   //if not present in .ini, add it with default value
            MEM_SetGothOpt("ITEMLOCATOR", "radius", "1100");
        };
        Ninja_ItemLocator_radius = STR_ToInt(MEM_GetGothOpt("ITEMLOCATOR", "radius"));


        // Set sphereSize global constant.
        if (!MEM_GothOptExists("ITEMLOCATOR", "sphereSize"))
        {   //if not present in .ini, add it with default value
            MEM_SetGothOpt("ITEMLOCATOR", "sphereSize", "20");
        };
        Ninja_ItemLocator_sphereSize = STR_ToInt(MEM_GetGothOpt("ITEMLOCATOR", "sphereSize"));

        // Set useItemMapColors global constant.
        if (!MEM_GothOptExists("ITEMLOCATOR", "useItemMapColors"))
        {   //if not present in .ini, add it with default value
            if (MEM_GothOptSectionExists("ITEMMAP"))
            {   // enabled by default if ItemMap is installed
                MEM_SetGothOpt("ITEMLOCATOR", "useItemMapColors", "1");
            }
            else
            {   // disabled by default if ItemMap is not installed
                MEM_SetGothOpt("ITEMLOCATOR", "useItemMapColors", "0");
            };
        };
        Ninja_ItemLocator_useItemMapColors = STR_ToInt(MEM_GetGothOpt("ITEMLOCATOR", "useItemMapColors"));

        var string inisection; inisection = "ITEMLOCATOR";
        if (STR_ToInt(MEM_GetGothOpt("ITEMLOCATOR", "useItemMapColors")) && MEM_GothOptSectionExists("ITEMMAP"))
        {
            // Set item category colors based on ItemMap settings
            inisection = "ITEMMAP";
        };
        // Set item category colors based on ini settings
        MEM_Info(ConcatStrings("Reading color settings from ", inisection));
        Ninja_ItemLocator_Colors[0] = Ninja_ItemLocator_ReadColor(inisection, "combat", Ninja_ItemLocator_Colors[0]);
        Ninja_ItemLocator_Colors[1] = Ninja_ItemLocator_ReadColor(inisection, "armor" , Ninja_ItemLocator_Colors[1]);
        Ninja_ItemLocator_Colors[2] = Ninja_ItemLocator_ReadColor(inisection, "rune"  , Ninja_ItemLocator_Colors[2]);
        Ninja_ItemLocator_Colors[3] = Ninja_ItemLocator_ReadColor(inisection, "magic" , Ninja_ItemLocator_Colors[3]);
        Ninja_ItemLocator_Colors[4] = Ninja_ItemLocator_ReadColor(inisection, "food"  , Ninja_ItemLocator_Colors[4]);
        Ninja_ItemLocator_Colors[5] = Ninja_ItemLocator_ReadColor(inisection, "potion", Ninja_ItemLocator_Colors[5]);
        Ninja_ItemLocator_Colors[6] = Ninja_ItemLocator_ReadColor(inisection, "docs"  , Ninja_ItemLocator_Colors[6]);
        Ninja_ItemLocator_Colors[7] = Ninja_ItemLocator_ReadColor(inisection, "other" , Ninja_ItemLocator_Colors[7]);

        // Register hook
        MEM_Info("Registering engine hook.");
        HookEngineF(zCWorld__AdvanceClock, 10, Ninja_ItemLocator_LocateNearbyItemsHook);

        // Set localization constant for the controls menu
        MEM_Info("Setting menu localization.");
        Ninja_ItemLocator_SetMenuLocalization();

        MEM_Info("Finished initializing ItemLocator.");
    };

    /* Source: https://github.com/szapp/Ninja/wiki/Inject-Changes */

    // Get menu and menu item list, corresponds to C_MENU_DEF.items[]
    var zCMenu menu; menu = _^(menuPtr);
    var int items; items = _@(menu.m_listItems_array);

    // Modify each menu by its name
    if (Hlp_StrCmp(menu.name, "MENU_OPT_CONTROLS")){

        // New menu instances (description and key binding)
        var string itm1Str; itm1Str = "MenuItem_Ninja_ItemLocator_KeyMenu";
        var string itm2Str; itm2Str = "MenuItem_Ninja_ItemLocator_InpMenu";

        // Get new items
        var int itm1; itm1 = MEM_GetMenuItemByString(itm1Str);
        var int itm2; itm2 = MEM_GetMenuItemByString(itm2Str);

        // If the new ones do not exist yet, create them the first time
        if (!itm1) {
            var zCMenuItem itm;
            itm1 = Ninja_ItemLocator_CreateMenuItem(itm1Str);
            itm2 = Ninja_ItemLocator_CreateMenuItem(itm2Str);

            // Copy properties of first key binding entry (left column)
            var int itmF_left; itmF_left = MEM_ArrayRead(items, 1);
            Ninja_ItemLocator_CopyMenuItemProperties(itm1, itmF_left);
            itm = _^(itmF_left);
            var int ypos_l; ypos_l = itm.m_parPosY;

            // Retrieve right column entry and copy its properties too
            var string rightname; rightname = itm.m_parOnSelAction_S;
            rightname = STR_SubStr(rightname, 4, STR_Len(rightname)-4);
            var int itmF_right; itmF_right = MEM_GetMenuItemByString(rightname);
            if (itmF_right) {
                Ninja_ItemLocator_CopyMenuItemProperties(itm2, itmF_right);
            } else { // If not found, copy from left column
                Ninja_ItemLocator_CopyMenuItemProperties(itm2, itmF_left);
                itm = _^(itm2);
                itm.m_parPosX += 2700; // Default x position
            };
            itm = _^(itmF_right);
            var int ypos_r; ypos_r = itm.m_parPosY;

            // Find "BACK" menu item by its action (to add the new ones above)
            const int index = 0;
            repeat(index, MEM_ArraySize(items));
                itm = _^(MEM_ArrayRead(items, index));
                if (itm.m_parOnSelAction == /*SEL_ACTION_BACK*/ 1)
                && (itm.m_parItemFlags & /*IT_SELECTABLE*/ 4) {
                    break;
                };
            end;
            var int y; y = itm.m_parPosY; // Obtain vertical position

            // Adjust height of new entries (just above the "BACK" option)
            itm = _^(itm1);
            itm.m_parPosY = y;
            itm = _^(itm2);
            itm.m_parPosY = y + (ypos_r - ypos_l); // Maintain possible difference

            // Get maximum height of new entries
            var int ystep; ystep = Ninja_ItemLocator_MenuItemGetHeight(itm1);
            var int ystep_r; ystep_r = Ninja_ItemLocator_MenuItemGetHeight(itm2);
            if (ystep_r > ystep) {
                ystep = ystep_r;
            };

            // Shift vertical positions of all following menu items below
            repeat(i, MEM_ArraySize(items) - index); var int i;
                itm = _^(MEM_ArrayRead(items, i + index));
                itm.m_parPosY += ystep;
            end;
        };

        // Add new entries at the correct position
        Ninja_ItemLocator_ArrayInsertAtPos(items, index, itm1);
        Ninja_ItemLocator_ArrayInsertAtPos(items, index+1, itm2);
    };
};
