/* This file includes all of ItemLocator's constants and global variables. */

/* Radius within which items will be considered 'nearby' in cm.*/
const int Ninja_ItemLocator_radius = 1100;

/* Radius of the spheres that mark nearby items. */
const int Ninja_ItemLocator_sphereSize = 20;

/* Whether or not ItemMap's Gothic.ini color settings should be used. If this is enabled
 * without ItemMap being installed, ItemLocator's own settings will be used.
 */
const int Ninja_ItemLocator_useItemMapColors = 0;

/* Color table (defaults) */
const int    Ninja_ItemLocator_NumItemCat = 8; // INV_CAT_MAX-1
const int    Ninja_ItemLocator_NumColors  = Ninja_ItemLocator_NumItemCat+1;
const int    Ninja_ItemLocator_Colors[Ninja_ItemLocator_NumColors] = {
    13369344, // COMBAT weapons and ammunition  #CC0000 red
    16729882, // ARMOR  armor                   #FF471A orange
    4671441,  // RUNE   runes and scrolls       #4747D1 blue/purple
    15120384, // MAGIC  belts and jewellery     #E6B800 yellow
    2663464,  // FOOD   food and plants         #28A428 green
    52479,    // POTION potions                 #00CCFF cyan
    16777113, // DOCS   documents and tablets   #FFFF99 faint yellow/white
    8421504,  // OTHER  other                   #808080 gray
    8343854   // CHEST  #7F512E brown
};
