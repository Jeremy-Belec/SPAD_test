(sde:clear)

(sdeio:readbnd "sde_dvs.bnd")

(sdegeo:create-rectangle (position 0 0 0) (position 15 1 0) "Germanium" "Ge_contact_layer")

(sdegeo:create-rectangle (position -5 0 0) (position 20 -4 0) "Germanium" "Ge_absorption_layer")

(sdegeo:create-rectangle (position -5 -4 0) (position -2 -5 0) "Silicium" "Si_multiplication_layer")

(sdegeo:create-rectangle (position 17 -4 0) (position 20 -5 0) "Silicium" "Si_multiplication_layer")

(sdegeo:set-default-boolean "AB")

(sdegeo:create-rectangle (position -5 -5 0) (position 20 -10 0) "Silicium" "Si_multiplication_layer")

(sdegeo:set-default-boolean "ABA")

(sdegeo:create-rectangle (position -2 -4 0) (position 17 -5 0) "Silicium" "Si_charge_layer")

(sdegeo:create-rectangle (position -5 -10 0) (position 20 -12 0) "Silicium" "Si_contact_layer")
