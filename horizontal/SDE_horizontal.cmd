

  
(sde:clear)

#####################################################################################################################
#Definition of dimensions variables:

(define t_Ge 0.5) ;Ge absorption layer thickness (p)[um]
(define t_Ox 0.003) ;Oxide layer thickness (p)[um]
(define t_Si 1) ;Si charge sheet thickness (p)[um]
(define t_dop 0.5) ;doping profile thickness (n)[um]
(define t_contact 0.05) ;thickness of contacts (n)[um]


(define L_abs 25) ;Length of Ge absorption layer [um]
(define L_Si 60) ;Length of Si multiplication region [um] 
(define L_dop 10) ;Length of Si doping profile [um] (length of device)


#Definition of Doping variables

(define P_side 1e18) ;P doping of absorber
(define dop_Ge 1e16) ;P doping of charge sheet
(define dop_Si 5e13) ;P doping of charge sheet
(define N_side 1e18) ;N doping of multiplication region

(define P_cont 1e19) ;P doping of absorber
(define N_cont 1e19) ;P doping of absorber
#####################################################################################################################

#Definition of the device


#Ge layer
(sdegeo:create-rectangle (position (* L_abs -0.5) 0 0) (position (* L_abs 0.5) t_Ge 0) "Germanium" "Ge_contact_layer")



#Oxide layer
(sdegeo:create-rectangle (position (* L_abs -0.5) t_Ge 0) (position (* L_abs 0.5) (+ t_Ge t_Ox) 0) "SiO2" "Oxide_layer")


#Si_charge_layer
(sdegeo:create-rectangle (position (* L_Si -0.5) (+ t_Ox t_Ge) 0) (position (* L_Si 0.5) (+ t_Si (+ t_Ox t_Ge)) 0) "Silicon" "Si_charge_layer")

#P contact
(sdegeo:create-rectangle (position (* L_Si -0.5) (+ -t_contact (+ t_Ox t_Ge) 0) (position (+ L_dop (* L_Si -0.5)) (+ t_Ox t_Ge) 0) "Silicon" "Si_P_cont_layer")

#N contact
(sdegeo:create-rectangle (position (* L_Si 0.5) (+ -t_contact (+ t_Ox t_Ge) 0) (position (+ -L_dop (* L_Si 0.5)) (+ t_Ox t_Ge) 0) "Silicon" "Si_N_cont_layer")


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

(sdedr:define-constant-profile "n_contact_profile" "PhosphorusActiveConcentration" N_multi)
(sdedr:define-constant-profile-region "n_contact_region" "n_contact_profile" "Si_multiplication_layer2")

(sdedr:define-constant-profile "n_contact_profile" "PhosphorusActiveConcentration" N_multi)
(sdedr:define-constant-profile-region "n_contact_region" "n_contact_profile" "Si_multiplication_layer3")

(sdedr:define-constant-profile "n_contact_profile" "PhosphorusActiveConcentration" N_cont)
(sdedr:define-constant-profile-region "n_contact_region" "n_contact_profile" "Si_contact_layer")

#####################################################################################################################

#Definition of te meshing



#Ge Contact
(sdedr:define-refeval-window "RefEvalWin.Ge_contact_layer" "Rectangle"  (position (* L_contact -0.5) 0 0) (position (* L_contact 0.5) A 0))
(sdedr:define-refinement-size "RefinementDefinition.Ge_contact_layer" (/ L_contact 5) (/ A 5) (/ L_contact 10) (/ A 10) )
(sdedr:define-refinement-placement "RefinementPlacement.Ge_contact_layer" "RefinementDefinition.Ge_contact_layer" (list "window" "RefEvalWin.Ge_contact_layer"))


#Ge absorption layer
(sdedr:define-refeval-window "RefEvalWin.Ge_absorption_layer" "Rectangle"  (position (* L_abs -0.5) A 0) (position (* L_abs 0.5) (+ A B)  0) )
(sdedr:define-refinement-size "RefinementDefinition.Ge_absorption_layer"(/ L_mult 40) (/ B 40) (/ L_mult 100) (/ B 60) )
(sdedr:define-refinement-placement "RefinementPlacement.Ge_absorption_layer" "RefinementDefinition.Ge_absorption_layer" (list "window" "RefEvalWin.Ge_absorption_layer"))




#Si Charge sheet
(sdedr:define-refeval-window "RefEvalWin.Si_charge_layer" "Rectangle"  (position (* L_charge -0.5) (+ A B) 0) (position (* L_charge 0.5) (+ C (+ A B)) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_charge_layer" (/ L_mult 50) (/ C 10) (/ L_mult 100) (/ C 40) )
(sdedr:define-refinement-placement "RefinementPlacement.Si_charge_layer" "RefinementDefinition.Si_charge_layer" (list "window" "RefEvalWin.Si_charge_layer"))


#Si Multiplication 

(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer" "Rectangle"  (position (* L_mult -0.5) (+ C (+ A B)) 0) (position (* L_mult 0.5) (+ D (+ C (+ A B))) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer" (/ L_mult 50) (/ D 20) (/ L_mult 100) (/ D 50) )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer" "RefinementDefinition.Si_multiplication_layer" (list "window" "RefEvalWin.Si_multiplication_layer"))


(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer2" "Rectangle"  (position (* L_charge -0.5) (+ A B) 0) (position (* L_abs -0.5) (+ C (+ A B))  0) )
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer2"(/ (* 0.5 (- L_abs L_charge)) 20) (/ C 20) (/ (* 0.5 (- L_abs L_charge)) 70) (/ C 50) )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer2" "RefinementDefinition.Si_multiplication_layer2" (list "window" "RefEvalWin.Si_multiplication_layer2"))

(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer3" "Rectangle"  (position (* L_charge 0.5) (+ A B) 0) (position (* L_abs 0.5) (+ C (+ A B))  0) )
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer3"(/ (* 0.5 (- L_abs L_charge)) 20) (/ C 20) (/ (* 0.5 (- L_abs L_charge)) 70) (/ C 50) )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer3" "RefinementDefinition.Si_multiplication_layer3" (list "window" "RefEvalWin.Si_multiplication_layer3"))




#Si contact

(sdedr:define-refeval-window "RefEvalWin.Si_contact_layer" "Rectangle"  (position (* L_mult -0.5) (+ D (+ C (+ A B))) 0) (position (* L_mult 0.5) (+ E(+ D (+ C (+ A B)))) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_contact_layer" (/ L_mult 5) (/ E 5) (/ L_mult 15)(/ E 10) )
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
