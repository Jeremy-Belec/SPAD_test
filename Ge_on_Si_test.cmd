(sde:clear)

(sdeio:readbnd "sde_dvs.bnd")

#####################################################################################################################
#Definition of variables:
(define A 1)
(define B 3)
(define C 1)
(define D 8)
(define E 1)

(define L_contact 12)
(define L_charge 16)
(define L_mult 20)
(define L_dev 30)


#####################################################################################################################


#Definition of the device

(sdegeo:create-rectangle (position (-0.5*L_contact) 0 0) (position (0.5*L_contact) (-A) 0) "Germanium" "Ge_contact_layer")

(sdegeo:create-rectangle (position (-0.5*L_mult) (-A) 0) (position (0.5*L_mult) (-A-B) 0) "Germanium" "Ge_absorption_layer")

(sdegeo:create-rectangle (position (-0.5*L_mult) (-A-B) 0) (position (-0.5*L_charge) (-A-B-C) 0) "Silicium" "Si_multiplication_layer")

(sdegeo:create-rectangle (position (0.5*L_charge) (-A-B) 0) (position (0.5*L_mult) (-A-B-C) 0) "Silicium" "Si_multiplication_layer")

(sdegeo:set-default-boolean "AB")

(sdegeo:create-rectangle (position (-0.5*L_dev) (-A-B-C) 0) (position (0.5*L_dev) (-A-B-C-D) 0) "Silicium" "Si_multiplication_layer")

(sdegeo:set-default-boolean "ABA")

(sdegeo:create-rectangle (position (-0.5*L_charge) (-A-B) 0) (position (0.5*L_charge (-A-B-C) 0) "Silicium" "Si_charge_layer")

(sdegeo:create-rectangle (position (-0.5*L_dev) (-A-B-C-D) 0) (position (0.5*L_dev) (-A-B-C-D-E) 0) "Silicium" "Si_contact_layer")


#####################################################################################################################

#Definition of the contacts (anode, cathode)

(sdegeo:define-contact-set "anode" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "p_contact")
(sdegeo:set-contact-edges (find-edge-id (position 0 0 0)))

(sdegeo:define-contact-set "cathode" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "n_contact")
(sdegeo:set-contact-edges (find-edge-id (position 0 (-A - B - C - D - E) 0)))

#####################################################################################################################

#Definition of the doping (n,p)





