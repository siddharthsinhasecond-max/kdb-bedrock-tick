/schema.q table definition for the tick platform
/Author: Siddharth Sinha


/--- trade: one row per executed trade----
trade:([]
    time:`timestamp$();
    sym:`symbol$();
    price:`float$();
    size:`long$();
    side:`char$();
    tradeId:`long$();
    exchTime:`timestamp$())


/Q5: why are the time and sym the first 2 columns...?

