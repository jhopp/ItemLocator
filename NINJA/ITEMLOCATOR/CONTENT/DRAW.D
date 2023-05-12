/*
 * Draws a sphere around an item.
 */
func void Ninja_ItemLocator_DrawItemSphere(var int vobPtr, var int color)
{
    var oCItem nearbyItem; nearbyItem = _^(vobPtr);
        
    var int sphere[4]; 
    sphere[0] = nearbyItem._zCVob_trafoObjToWorld[3];
    sphere[1] = nearbyItem._zCVob_trafoObjToWorld[7];
    sphere[2] = nearbyItem._zCVob_trafoObjToWorld[11];
    sphere[3] = mkf(Ninja_ItemLocator_sphereSize);

    const int cPtr = 0;
    const int sPtr = 0;
    const int call = 0;
    if (CALL_Begin(call))
    {
        cPtr = _@(color);
        sPtr = _@(sphere);
        CALL_IntParam(_@(cPtr));
        CALL__thiscall(_@(sPtr), zTBSphere3D__Draw);
        call = CALL_End();
    };
};
