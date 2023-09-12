(sde:clear)

#####################################################################################################################
#                                             Definition of dimensions variables:
(define A 0.05)
(define B 1)
(define C 0.1)
(define D 1.5)
(define E 0.15)

(define L_contact 12)
(define L_charge 16)
(define L_mult 20)
(define L_dev 30)

#                                                Definition of Doping variables

(define P_cont 5e19)
(define P_absorber 3e15)
(define P_charge 1e17)
(define P_multi 1e15)
(define N_cont 1e19)
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
(sdedr:define-refinement-size "RefinementDefinition.Si_charge" (/ L_mult 10) (/ B 10) (/ L_mult 100) (/ B 100))
(sdedr:define-refinement-placement "RefinementPlacement.Si_charge" "RefinementDefinition.Si_charge" (list "window" "RefEvalWin.Si_charge"))


#    Si Multiplication 

(sdedr:define-refeval-window "RefEvalWin.Si_mult" "Rectangle"  (position (* L_mult -0.5) (+ A B) 0) (position (* L_charge -0.5) (+ C (+ A B)) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_mult" (/ L_mult 10) (/ B 10) (/ L_mult 100) (/ B 100))
(sdedr:define-refinement-placement "RefinementPlacement.Si_mult" "RefinementDefinition.Si_mult" (list "window" "RefEvalWin.Si_mult"))

(sdedr:define-refeval-window "RefEvalWin.Si_mult" "Rectangle"  (position (* L_charge 0.5) (+ A B) 0) (position (* L_mult 0.5) (+ C (+ A B)) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_mult" (/ L_mult 10) (/ B 10) (/ L_mult 100) (/ B 100))
(sdedr:define-refinement-placement "RefinementPlacement.Si_mult" "RefinementDefinition.Si_mult" (list "window" "RefEvalWin.Si_mult"))

(sdedr:define-refeval-window "RefEvalWin.Si_mult" "Rectangle"  (position (* L_dev -0.5) (+ C (+ A B)) 0) (position (* L_dev 0.5) (+ D (+ C (+ A B))) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_mult" (/ L_mult 10) (/ B 10) (/ L_mult 100) (/ B 100))
(sdedr:define-refinement-placement "RefinementPlacement.Si_mult" "RefinementDefinition.Si_mult" (list "window" "RefEvalWin.Si_mult"))


#    Si contact

(sdedr:define-refeval-window "RefEvalWin.Si_contact" "Rectangle"  (position (* L_dev -0.5) (+ D (+ C (+ A B))) 0) (position (* L_dev 0.5) (+ E(+ D (+ C (+ A B)))) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_contact" (/ L_mult 10) (/ B 10) (/ L_mult 100) (/ B 100))
(sdedr:define-refinement-placement "RefinementPlacement.Si_contact" "RefinementDefinition.Si_contact" (list "window" "RefEvalWin.Si_contact"))


#####################################################################################################################



#                                                      Building the meshing

(sde:set-project-name "n1")
(sdesnmesh:iocontrols "outputFile" "n1")
(sde:set-meshing-command "snmesh")
(sde:set-project-name "n1")
(sdesnmesh:iocontrols "outputFile" "n1")
(sde:build-mesh "" "n1")
(system:command "svisual n1_msh.tdr &")
(sde:save-model "n1")

