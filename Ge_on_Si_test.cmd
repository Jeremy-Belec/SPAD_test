(sde:clear)

#####################################################################################################################
#                                             Definition of dimensions variables:
(define A 0.05)        #  Ge contact thickness (p)                  [μm]
(define B 1)            #  Ge absorption layer thickness (p)        [μm]
(define C 0.1)          #  Si charge sheet thickness (p)            [μm]
(define D 1.5)          #  Si multiplication region thickness (n)    [μm]
(define E 0.15)          #  Si contact thickness (n)                [μm]

(define L_contact 12)      #Length of Ge contact              [μm]
(define L_charge 16)        #Length of Si charge sheet        [μm]
(define L_mult 20)          #Length of Si multiplication region    [μm]
(define L_dev 30)            #Length of device                [μm]

#                                                Definition of Doping variables

(define P_cont 5e19)      #    P doping of P-contact
(define P_absorber 3e15)    #    P doping of absorber
(define P_charge 1e17)      #    P doping of charge sheet
(define N_multi 1e15)      #    N doping of multiplication region
(define N_cont 1e19)      #     N doping of N-contact
#####################################################################################################################

#                                                   Definition of the device


#      Ge_contact_layer
(sdegeo:create-rectangle (position (* L_contact -0.5) 0 0) (position (* L_contact 0.5) A 0) "Germanium" "Ge_contact_layer")



#      Ge_absorption_layer
(sdegeo:create-rectangle (position (* L_mult -0.5) A 0) (position (* L_mult 0.5) (+ A B) 0) "Germanium" "Ge_absorption_layer")


#      Si_multiplication_layer
(sdegeo:create-rectangle (position (* L_mult -0.5) (+ A B) 0) (position (* L_charge -0.5) (+ C (+ A B)) 0) "Silicium" "Si_multiplication_layer")

(sdegeo:create-rectangle (position (* L_charge 0.5) (+ A B) 0) (position (* L_mult 0.5) (+ C (+ A B)) 0) "Silicium" "Si_multiplication_layer")

(sdegeo:set-default-boolean "AB")

(sdegeo:create-rectangle (position (* L_dev -0.5) (+ C (+ A B)) 0) (position (* L_dev 0.5) (+ D (+ C (+ A B))) 0) "Silicium" "Si_multiplication_layer")

(sdegeo:set-default-boolean "ABA")


#      Si_charge_layer
(sdegeo:create-rectangle (position (* L_charge -0.5) (+ A B) 0) (position (* L_charge 0.5) (+ C (+ A B)) 0) "Silicium" "Si_charge_layer")


#      Si_contact_layer
(sdegeo:create-rectangle (position (* L_dev -0.5) (+ D (+ C (+ A B))) 0) (position (* L_dev 0.5) (+ E(+ D (+ C (+ A B)))) 0) "Silicium" "Si_contact_layer")



#####################################################################################################################

#                                      Definition of the contacts (n_contact, p_contact)

#    P contact

(sdegeo:define-contact-set "p_contact" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "p_contact")
(sdegeo:set-contact-edges (find-edge-id (position 0 0 0)))


#    N contact

(sdegeo:define-contact-set "n_contact" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "n_contact")
(sdegeo:set-contact-edges (find-edge-id (position 0 (+ E(+ D (+ C (+ A B)))) 0)))

#####################################################################################################################

#                                               Definition of the doping (n,p)



#    Doping of p regions
(sdedr:define-constant-profile "p_contact_profile" "BoronActiveConcentration" P_cont)
(sdedr:define-constant-profile-region "p_contact_region" "p_contact_profile" "Ge_contact_layer")

(sdedr:define-constant-profile "p_contact_profile" "BoronActiveConcentration" P_absorber)
(sdedr:define-constant-profile-region "p_contact_region" "p_contact_profile" "Ge_absorption_layer")

(sdedr:define-constant-profile "p_charge_profile" "BoronActiveConcentration" P_charge)
(sdedr:define-constant-profile-region "p_charge_region" "p_charge_profile" "Si_charge_layer")

#    Doping of n regions
(sdedr:define-constant-profile "n_contact_profile" "PhosphorusActiveConcentration" N_multi)
(sdedr:define-constant-profile-region "n_contact_region" "n_contact_profile" "Si_multiplication_layer")

(sdedr:define-constant-profile "n_contact_profile" "PhosphorusActiveConcentration" N_cont)
(sdedr:define-constant-profile-region "n_contact_region" "n_contact_profile" "Si_contact_layer")

#####################################################################################################################

#                                                     Definition of te meshing



#    Ge Contact
(sdedr:define-refeval-window "RefEvalWin.Contact" "Rectangle"  (position (* L_contact -0.5) 0 0) (position (* L_contact 0.5) A 0))
(sdedr:define-refinement-size "RefinementDefinition.Contact" (/ L_contact 10) (/ A 10) (/ L_contact 100) (/ A 100))
(sdedr:define-refinement-placement "RefinementPlacement.Contact" "RefinementDefinition.Contact" (list "window" "RefEvalWin.Contact"))


#    Ge absorption layer
(sdedr:define-refeval-window "RefEvalWin.Ge_absorption" "Rectangle"  (position (* L_mult -0.5) A 0) (position (* L_mult 0.5) (+ A B) 0))
(sdedr:define-refinement-size "RefinementDefinition.Ge_absorption" (/ L_mult 10) (/ B 10) (/ L_mult 100) (/ B 100))
(sdedr:define-refinement-placement "RefinementPlacement.Ge_absorption" "RefinementDefinition.Ge_absorption" (list "window" "RefEvalWin.Ge_absorption"))


#    Si Charge sheet
(sdedr:define-refeval-window "RefEvalWin.Si_charge" "Rectangle"  (position (* L_charge -0.5) (+ A B) 0) (position (* L_charge 0.5) (+ C (+ A B)) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_charge" (/ L_mult 10) (/ B 10) (/ L_mult 100) (/ C 100))
(sdedr:define-refinement-placement "RefinementPlacement.Si_charge" "RefinementDefinition.Si_charge" (list "window" "RefEvalWin.Si_charge"))


#    Si Multiplication 

(sdedr:define-refeval-window "RefEvalWin.Si_mult" "Rectangle"  (position (* L_mult -0.5) (+ A B) 0) (position (* L_charge -0.5) (+ C (+ A B)) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_mult" (/ L_mult 10) (/ C 10) (/ L_mult 100) (/ C 100))
(sdedr:define-refinement-placement "RefinementPlacement.Si_mult" "RefinementDefinition.Si_mult" (list "window" "RefEvalWin.Si_mult"))

(sdedr:define-refeval-window "RefEvalWin.Si_mult2" "Rectangle"  (position (* L_charge 0.5) (+ A B) 0) (position (* L_mult 0.5) (+ C (+ A B)) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_mult2" (/ L_mult 10) (/ C 10) (/ L_mult 100) (/ C 100))
(sdedr:define-refinement-placement "RefinementPlacement.Si_mult2" "RefinementDefinition.Si_mult2" (list "window" "RefEvalWin.Si_mult2"))

(sdedr:define-refeval-window "RefEvalWin.Si_mult3" "Rectangle"  (position (* L_dev -0.5) (+ C (+ A B)) 0) (position (* L_dev 0.5) (+ D (+ C (+ A B))) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_mult3" (/ L_mult 10) (/ D 10) (/ L_mult 100) (/ D 100))
(sdedr:define-refinement-placement "RefinementPlacement.Si_mult3" "RefinementDefinition.Si_mult3" (list "window" "RefEvalWin.Si_mult3"))


#    Si contact

(sdedr:define-refeval-window "RefEvalWin.Si_contact" "Rectangle"  (position (* L_dev -0.5) (+ D (+ C (+ A B))) 0) (position (* L_dev 0.5) (+ E(+ D (+ C (+ A B)))) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_contact" (/ L_mult 10) (/ E 10) (/ L_mult 100) (/ E 100))
(sdedr:define-refinement-placement "RefinementPlacement.Si_contact" "RefinementDefinition.Si_contact" (list "window" "RefEvalWin.Si_contact"))


#####################################################################################################################



#                                                      Building the meshing

(sde:build-mesh "snmesh" " " "n@node@_msh")
