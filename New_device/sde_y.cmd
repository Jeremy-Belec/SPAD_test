(sde:clear)

#####################################################################################################################
#Definition of dimensions variables:

(define A 0.05) ;Ge contact thickness (p)[um]
(define B 1) ;Ge absorption layer thickness (p)[um]
(define C 0.1) ;Si charge sheet thickness (p)[um]
(define D 1.5) ;Si multiplication region thickness (n)[um]
(define E 0.15) ;Si contact thickness (n)[um]

(define L_contact 12) ;Length of Ge contact [um]
(define L_charge 16) ;Length of Si charge sheet [um]
(define L_mult 20) ;Length of Si multiplication region [um]
(define L_dev 30) ;Length of device [um]

#Definition of Doping variables

(define P_cont 5e19) ;P doping of P-contact
(define P_absorber 3e15) ;P doping of absorber
(define P_charge 1e17) ;P doping of charge sheet
(define N_multi 1e15) ;N doping of multiplication region
(define N_cont 1e19) ;N doping of N-contact
#####################################################################################################################

#Definition of the device


#Ge_contact_layer
(sdegeo:create-rectangle (position (* L_contact -0.5) 0 0) (position (* L_contact 0.5) A 0) "Germanium" "Ge_contact_layer")



#Ge_absorption_layer
(sdegeo:create-rectangle (position (* L_mult -0.5) A 0) (position (* L_mult 0.5) (+ A B) 0) "Germanium" "Ge_absorption_layer")


#Si_multiplication_layer
(sdegeo:create-rectangle (position (* L_dev -0.5) (+ C (+ A B)) 0) (position (* L_dev 0.5) (+ D (+ C (+ A B))) 0) "Silicon" "Si_multiplication_layer")

#Si_charge_layer
(sdegeo:create-rectangle (position (* L_charge -0.5) (+ A B) 0) (position (* L_charge 0.5) (+ C (+ A B)) 0) "Silicon" "Si_charge_layer")


#Si_contact_layer
(sdegeo:create-rectangle (position (* L_dev -0.5) (+ D (+ C (+ A B))) 0) (position (* L_dev 0.5) (+ E(+ D (+ C (+ A B)))) 0) "Silicon" "Si_contact_layer")



#####################################################################################################################

#Definition of the contacts (n_contact, p_contact)

#P contact

(sdegeo:define-contact-set "p_contact" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "p_contact")
(sdegeo:set-contact-edges (find-edge-id (position 0 0 0)))


#N contact

(sdegeo:define-contact-set "n_contact" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "n_contact")
(sdegeo:set-contact-edges (find-edge-id (position 0 (+ E(+ D (+ C (+ A B)))) 0)))

#####################################################################################################################

#Definition of the doping (n,p)



#Doping of p regions
(sdedr:define-constant-profile "p_contact_profile" "BoronActiveConcentration" P_cont)
(sdedr:define-constant-profile-region "p_contact_region" "p_contact_profile" "Ge_contact_layer")

(sdedr:define-constant-profile "p_contact_profile" "BoronActiveConcentration" P_absorber)
(sdedr:define-constant-profile-region "p_contact_region" "p_contact_profile" "Ge_absorption_layer")

(sdedr:define-constant-profile "p_charge_profile" "BoronActiveConcentration" P_charge)
(sdedr:define-constant-profile-region "p_charge_region" "p_charge_profile" "Si_charge_layer")

#Doping of n regions
(sdedr:define-constant-profile "n_contact_profile" "PhosphorusActiveConcentration" N_multi)
(sdedr:define-constant-profile-region "n_contact_region" "n_contact_profile" "Si_multiplication_layer")

(sdedr:define-constant-profile "n_contact_profile" "PhosphorusActiveConcentration" N_cont)
(sdedr:define-constant-profile-region "n_contact_region" "n_contact_profile" "Si_contact_layer")

#####################################################################################################################

#Definition of te meshing



#Ge Contact
(sdedr:define-refeval-window "RefEvalWin.Ge_contact_layer" "Rectangle"  (position (* L_contact -0.5) 0 0) (position (* L_contact 0.5) A 0))
(sdedr:define-refinement-size "RefinementDefinition.Ge_contact_layer" (/ L_contact 10) (/ A 10) (/ L_contact 100) (/ A 100) )
(sdedr:define-refinement-placement "RefinementPlacement.Ge_contact_layer" "RefinementDefinition.Ge_contact_layer" (list "window" "RefEvalWin.Ge_contact_layer"))


#Ge absorption layer
(sdedr:define-refeval-window "RefEvalWin.Ge_absorption_layer" "Rectangle"  (position (* L_mult -0.5) A 0) (position (* L_mult 0.5) (+ A B)  0) )
(sdedr:define-refinement-size "RefinementDefinition.Ge_absorption_layer"(/ L_mult 10) (/ B 10) (/ L_mult 100) (/ B 100) )
(sdedr:define-refinement-placement "RefinementPlacement.Ge_absorption_layer" "RefinementDefinition.Ge_absorption_layer" (list "window" "RefEvalWin.Ge_absorption_layer"))


#Si Charge sheet
(sdedr:define-refeval-window "RefEvalWin.Si_charge_layer" "Rectangle"  (position (* L_charge -0.5) (+ A B) 0) (position (* L_charge 0.5) (+ C (+ A B)) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_charge_layer" (/ L_mult 10) (/ C 10) (/ L_mult 100) (/ C 100) )
(sdedr:define-refinement-placement "RefinementPlacement.Si_charge_layer" "RefinementDefinition.Si_charge_layer" (list "window" "RefEvalWin.Si_charge_layer"))


#Si Multiplication 

(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer" "Rectangle"  (position (* L_dev -0.5) (+ C (+ A B)) 0) (position (* L_dev 0.5) (+ D (+ C (+ A B))) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer" (/ L_mult 10) (/ D 10) (/ L_mult 100) (/ D 100) )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer" "RefinementDefinition.Si_multiplication_layer" (list "window" "RefEvalWin.Si_mult3"))


#Si contact

(sdedr:define-refeval-window "RefEvalWin.Si_contact_layer" "Rectangle"  (position (* L_dev -0.5) (+ D (+ C (+ A B))) 0) (position (* L_dev 0.5) (+ E(+ D (+ C (+ A B)))) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_contact_layer" (/ L_mult 10) (/ E 10) (/ L_mult 100)(/ E 100) )
(sdedr:define-refinement-placement "RefinementPlacement.Si_contact_layer" "RefinementDefinition.Si_contact_layer" (list "window" "RefEvalWin.Si_contact_layer"))


#####################################################################################################################

;----------------------------------------------------------------------;
; Meshing building
;----------------------------------------------------------------------;
; Meshing the device structure
(sde:set-project-name "n@node@")
(sdesnmesh:iocontrols "outputFile" "n@node@")
(sde:set-meshing-command "snmesh")
(sde:set-project-name "n@node@")
(sdesnmesh:iocontrols "outputFile" "n@node@")
(sde:build-mesh "" "n@node@")
(system:command "svisual n@node@_msh.tdr &")
(sde:save-model "n@node@")


;(sde:set-project-name "sde_dvs")
;(sde:save-model "n1_mesh")

