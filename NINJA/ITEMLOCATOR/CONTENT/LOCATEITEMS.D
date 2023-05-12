/* 
 * Collect nearby items and draw spheres around the ones that are valid.
 */
func void Ninja_ItemLocator_LocateNearbyItems()
{
    const int distance = 0; // Distance in cm (set in call)
    var int arrPtr; arrPtr = MEM_ArrayCreate();
    var int herPtr; herPtr = _@(hero);

    // Engine functions to collect all vobs surrounding the player
    const int oCNpc__CreateVobList_G1 = 7040496; //0x6B6DF0
    const int oCNpc__CreateVobList_G2 = 7722800; //0x75D730

    // Engine call
    const int call = 0;
    if (CALL_Begin(call))
    {
        distance = mkf(Ninja_ItemLocator_radius);
        CALL_IntParam(_@(distance));
        CALL_PtrParam(_@(arrPtr));
        CALL__thiscall(_@(herPtr), MEMINT_SwitchG1G2(oCNpc__CreateVobList_G1, oCNpc__CreateVobList_G2));
        call = CALL_End();  
    };

    // Iterate over Vob array and draw spheres for valid items.
    repeat(i, MEM_ArraySize(arrPtr)); var int i;
        var int vobPtr; vobPtr = MEM_ArrayRead(arrPtr, i);
        if (Hlp_Is_oCItem(vobPtr))
        {
            var oCItem locatedItem; locatedItem = _^(vobPtr);
            var oCNpc her; her = Hlp_GetNpc(hero);

            // Skip non-focusable items (items in use by NPC)
            if ((locatedItem.flags & /*ITEM_NFOCUS (1<<23)*/ 8388608) == 8388608)
            {
                continue;
            };

            // Skip invalid items
            if (locatedItem.instanz < 0)
            {
                continue;
            };

            // Skip items the hero is interacting with
            if (vobPtr == her.interactItem)
            {
                continue;
            };

            var int color; color = Ninja_ItemLocator_GetItemColor(locatedItem.mainflag);
            // Skip items if its category is set to false
            if (color == (255<<24))
            {
                continue;
            };

            // Draw sphere around item
            Ninja_ItemLocator_DrawItemSphere(vobPtr, color);
        };
    end;

    // Free array
    MEM_ArrayFree(arrPtr);
};

/*
 * Called every frame. Checks if keyLocateItems is pressed to locate items.
 */
func void Ninja_ItemLocator_LocateNearbyItemsHook() 
{
    // Make sure hero is loaded and game isn't paused
    if (!Hlp_IsValidNpc(hero)) || (MEM_Game.pause_screen) 
    {
        return;
    };

    // If keyLocateItems is pressed, locate items and draw spheres
    if ((MEM_KeyPressed(MEM_GetKey("keyLocateItems")))) || (MEM_KeyPressed(MEM_GetSecondaryKey("keyLocateItems")))
    {
        Ninja_ItemLocator_LocateNearbyItems();
    };
};