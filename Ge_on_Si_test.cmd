(sde:clear)

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

(sdegeo:create-rectangle (position (* L_contact -0.5) 0 0) (position (* L_contact 0.5) (* A -1) 0) "Germanium" "Ge_contact_layer")

(sdegeo:create-rectangle (position (* L_mult -0.5) (* A -1) 0) (position (* L_mult 0.5) (- B (* A -1)) 0) "Germanium" "Ge_absorption_layer")

(sdegeo:create-rectangle (position (* L_mult -0.5) (- B (* A -1)) 0) (position (* L_charge -0.5) (- C (- B (* A -1))) 0) "Silicium" "Si_multiplication_layer")

(sdegeo:create-rectangle (position (* L_charge 0.5) (- B (* A -1)) 0) (position (* L_mult 0.5) (- C (- B (* A -1))) 0) "Silicium" "Si_multiplication_layer")

(sdegeo:set-default-boolean "AB")

(sdegeo:create-rectangle (position (* L_dev -0.5) (- C (- B (* A -1))) 0) (position (* L_dev 0.5) (- D (- C (- B (* A -1)))) 0) "Silicium" "Si_multiplication_layer")

(sdegeo:set-default-boolean "ABA")

(sdegeo:create-rectangle (position (* L_charge -0.5) (- B (* A -1)) 0) (position (* L_charge 0.5) (- C (- B (* A -1))) 0) "Silicium" "Si_charge_layer")

(sdegeo:create-rectangle (position (* L_dev -0.5) (- D (- C (- B (* A -1)))) 0) (position (* L_dev 0.5) (- E (- D (- C (- B (* A -1))))) 0) "Silicium" "Si_contact_layer")


#####################################################################################################################

#Definition of the contacts (n_contact, p_contact)

(sdegeo:define-contact-set "p_contact" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "p_contact")
(sdegeo:set-contact-edges (find-edge-id (position 0 0 0)))

(sdegeo:define-contact-set "n_contact" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "n_contact")
(sdegeo:set-contact-edges (find-edge-id (position 0 (- E (- D (- C (- B (* A -1))))) 0)))

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

#####################################################################################################################

#Definition of te meshing


