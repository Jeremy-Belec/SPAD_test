

  
(sde:clear)

#####################################################################################################################
#Definition of dimensions variables:

(define t_Ge 0.1) ;Ge absorption layer thickness (p)[um]
(define t_Ox 0.002) ;Oxide layer thickness (p)[um]
(define t_Si 0.5) ;Si charge sheet thickness (p)[um]
(define t_dop 0.3) ;doping profile thickness (n)[um]
(define t_contact 0.005) ;thickness of contacts (n)[um]


(define L_abs 12) ;Length of Ge absorption layer [um]
(define L_Si 22) ;Length of Si multiplication region [um] 
(define L_dop 3.5) ;Length of Si doping profile [um] (length of device)


#Definition of Doping variables

(define P_side 1e18) ;P doping of absorber
(define dop_Ge 1e15) ;P doping of charge sheet
(define dop_Si 5e13) ;P doping of charge sheet
(define N_side 1e18) ;N doping of multiplication region

(define P_cont 1e19) ;P doping of absorber
(define N_cont 1e19) ;P doping of absorber
#####################################################################################################################

#Definition of the device


#Ge layer
(sdegeo:create-rectangle (position (* L_abs -0.5) 0 0) (position (* L_abs 0.5) t_Ge 0) "Germanium" "Ge_layer")



#Oxide layer
(sdegeo:create-rectangle (position (* L_abs -0.5) t_Ge 0) (position (* L_abs 0.5) (+ t_Ge t_Ox) 0) "SiO2" "Oxide_layer")


#Si_charge_layer
(sdegeo:create-rectangle (position (* L_Si -0.5) (+ t_Ox t_Ge) 0) (position (* L_Si 0.5) (+ t_Si (+ t_Ox t_Ge)) 0) "Silicon" "Si_layer")




#P contact
(sdegeo:create-rectangle (position (* L_Si -0.5) (- (+ t_Ox t_Ge) t_contact) 0) (position (+ L_dop (* L_Si -0.5)) (+ t_Ox t_Ge) 0) "Gold" "P_cont_layer")

#N contact
(sdegeo:create-rectangle (position (* L_Si 0.5) (- (+ t_Ox t_Ge) t_contact) 0) (position (- (* L_Si 0.5) L_dop) (+ t_Ox t_Ge) 0) "Gold" "N_cont_layer")


#####################################################################################################################

#Definition of the contacts (n_contact, p_contact)

#P contact

(sdegeo:define-contact-set "p_contact" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "p_contact")
(sdegeo:set-contact-edges (find-edge-id (position (* L_Si -0.5) (- (+ t_Ox t_Ge) t_contact) 0)))


#N contact

(sdegeo:define-contact-set "n_contact" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "n_contact")
(sdegeo:set-contact-edges (find-edge-id (position (* L_Si 0.5) (- (+ t_Ox t_Ge) t_contact) 0)))

#####################################################################################################################

#N side

(sdedr:define-refeval-window "BaseLine.SourceN" 
  "Line" (position (- (* L_Si 0.5) L_dop 0.5) (+ t_Ox t_Ge) 0.0) (position (* L_Si 0.5) (+ t_Ox t_Ge) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source1"
  "Gauss.SourceDrainN" "BaseLine.SourceN" "Positive" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainN"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 5e18
  "ValueAtDepth" 5e16 "Depth" 0.5 "Gauss" "Factor" 0.8)


#P side

(sdedr:define-refeval-window "BaseLine.SourceP" 
  "Line" (position (* L_Si -0.5) (+ t_Ox t_Ge) 0.0) (position (+ L_dop (* L_Si -0.5)) (+ t_Ox t_Ge) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source2"
  "Gauss.SourceDrainP" "BaseLine.SourceP" "Positive" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainP"
  "BoronActiveConcentration" "PeakPos" 0 "PeakVal" 5e18
  "ValueAtDepth" 5e16 "Depth" 0.5 "Gauss" "Factor" 1.1)



#Doping of Ge region
(sdedr:define-constant-profile "Ge_profile" "BoronActiveConcentration" 9e16)
(sdedr:define-constant-profile-region "Ge_region" "Ge_profile" "Ge_layer")




#Doping of Si region
(sdedr:define-constant-profile "Si_profile" "PhosphorusActiveConcentration" 1e16)
(sdedr:define-constant-profile-region "Si_region" "Si_profile" "Si_layer")




##########################################################################################

#Ge 
(sdedr:define-refeval-window "RefEvalWin.Ge_layer" "Rectangle"  (position (* L_abs -0.5) 0 0) (position (* L_abs 0.5) t_Ge 0))
(sdedr:define-refinement-size "RefinementDefinition.Ge_layer" 0.1 0.025 0.02 0.002 )
(sdedr:define-refinement-placement "RefinementPlacement.Ge_layer" "RefinementDefinition.Ge_layer" (list "window" "RefEvalWin.Ge_layer"))



#Oxide layer
(sdedr:define-refeval-window "RefEvalWin.Oxide_layer" "Rectangle"  (position (* L_abs -0.5) t_Ge 0) (position (* L_abs 0.5) (+ t_Ge t_Ox)  0) )
(sdedr:define-refinement-size "RefinementDefinition.Oxide_layer" 0.1 0.001 0.02 0.0005 )
(sdedr:define-refinement-placement "RefinementPlacement.Oxide_layer" "RefinementDefinition.Oxide_layer" (list "window" "RefEvalWin.Oxide_layer"))



#Si Multiplication layer

(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer" "Rectangle"  (position (* L_Si -0.5) (+ t_Ox t_Ge) 0) (position (* L_Si 0.5) (+ t_Si (+ t_Ox t_Ge)) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer" 0.1 0.05 0.02 0.002 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer" "RefinementDefinition.Si_multiplication_layer" (list "window" "RefEvalWin.Si_multiplication_layer"))


#P contact

(sdedr:define-refeval-window "RefEvalWin.P_contact_layer" "Rectangle"  (position (* L_Si -0.5) (- (+ t_Ox t_Ge) t_contact) 0) (position (+ L_dop (* L_Si -0.5)) (+ t_Ox t_Ge) 0))
(sdedr:define-refinement-size "RefinementDefinition.P_contact_layer" 0.5 0.005 0.1 0.001 )
(sdedr:define-refinement-placement "RefinementPlacement.P_contact_layer" "RefinementDefinition.P_contact_layer" (list "window" "RefEvalWin.P_contact_layer"))


#N contact

(sdedr:define-refeval-window "RefEvalWin.N_contact_layer" "Rectangle"  (position (* L_Si 0.5) (- (+ t_Ox t_Ge) t_contact) 0) (position (- (* L_Si 0.5) L_dop) (+ t_Ox t_Ge) 0))
(sdedr:define-refinement-size "RefinementDefinition.N_contact_layer" 0.5 0.005 0.1 0.001 )
(sdedr:define-refinement-placement "RefinementPlacement.N_contact_layer" "RefinementDefinition.N_contact_layer" (list "window" "RefEvalWin.N_contact_layer"))

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
