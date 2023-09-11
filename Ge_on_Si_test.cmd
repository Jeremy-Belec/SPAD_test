(sde:clear)

(sdeio:readbnd "sde_dvs.bnd")

#####################################################################################################################
#Definition of dimensions variables:
(define A 1)
(define B 3)
(define C 1)
(define D 8)
(define E 1)

(define L_contact 12)
(define L_charge 16)
(define L_mult 20)
(define L_dev 30)

#Definition of Doping variables

(define P_cont 1e19)
(define P_charge 1e17)
(define N_cont 1e19)
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

#Doping of p regions
(sdedr:define-constant-profile "p_contact_profile" "BoronActiveConcentration" P_cont)
(sdedr:define-constant-profile-region "p_contact_region" "p_contact_profile" "Ge_contact_layer")

(sdedr:define-constant-profile "p_charge_profile" "BoronActiveConcentration" P_charge)
(sdedr:define-constant-profile-region "p_charge_region" "p_charge_profile" "Si_charge_layer")

#Doping of n regions
(sdedr:define-constant-profile "n_contact_profile" "PhosphorusActiveConcentration" N_cont)
(sdedr:define-constant-profile-region "n_contact_region" "n_contact_profile" "Si_contact_layer")




