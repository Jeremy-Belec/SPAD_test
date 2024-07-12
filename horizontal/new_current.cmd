


  
(sde:clear)

#####################################################################################################################
#Definition of dimensions variables:

(define t_Ge 0.8) ;Ge absorption layer thickness (p)[um]
(define t_Ox 0.005) ;Oxide layer thickness (p)[um]
(define t_Si 4) ;Si charge sheet thickness (p)[um]
(define t_dop 0.3) ;doping profile thickness (n)[um]
(define t_contact 0.005) ;thickness of contacts (n)[um]
(define t_p 1) ;thickness p Si layer (n)[um]
(define t_n 3) ;thickness n wafer (n)[um]

(define L_abs 22) ;Length of Ge absorption layer [um]
(define L_Si 40) ;Length of Si multiplication region [um] 
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

#N contact
(sdegeo:create-rectangle (position (* L_abs -0.3) t_Si 0) (position (* L_abs 0.3) (+ t_Ge t_Si) 0) "Germanium" "n_contactt")

#N contact
(sdegeo:create-rectangle (position (* L_abs -0.3) (+ t_Ge t_Si) 0) (position (* L_abs 0.3) (+ t_Ge (+ t_Si (* 10 t_Ox))) 0) "Germanium" "n_contact")


#Si_charge_layer
(sdegeo:create-rectangle (position (* L_Si -0.5) 0 0) (position (* L_Si 0.5) t_Si 0) "Silicon" "Si_layer")



#P contact
(sdegeo:create-rectangle (position (+ 5 (* L_Si -0.5)) t_Si 0) (position (+ 5 (+ L_dop (* L_Si -0.5))) (+ t_Ox t_Si) 0) "Silicon" "contact_left")

#P contact
(sdegeo:create-rectangle (position (- (* L_Si 0.5) 5) t_Si 0) (position (- (- (* L_Si 0.5) L_dop) 5) (+ t_Ox t_Si) 0) "Silicon" "contact_right")

#####################################################################################################################

#Definition of the contacts (n_contact, p_contact)
#Ground contact
#(sdegeo:define-contact-set "g_contact" 4  (color:rgb 0.5 0 0.5 ) "##")
#(sdegeo:set-current-contact-set "g_contact")
#(sdegeo:set-contact-edges (find-edge-id (position (* L_Si -0.2) (* 0.4 (- 0 t_Si)) 0)))

#P contact

(sdegeo:define-contact-set "p_contact_left" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "p_contact_left")
(sdegeo:set-contact-edges (find-edge-id (position (+ 5 (* L_Si -0.45)) (+ t_Ox t_Si) 0)))


#P contact

(sdegeo:define-contact-set "p_contact_right" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "p_contact_right")
(sdegeo:set-contact-edges (find-edge-id (position (- (* L_Si 0.45) 5) (+ t_Ox t_Si) 0)))


#N contact

(sdegeo:define-contact-set "n_contact_center" 4  (color:rgb 0 0 1) "##")
(sdegeo:set-current-contact-set "n_contact_center")
(sdegeo:set-contact-edges (find-edge-id (position (* L_abs -0.2) (+ t_Ge (+ t_Si (* 10 t_Ox))) 0)))
#####################################################################################################################

#Doping of Si region
(sdedr:define-constant-profile "Si_profile" "PhosphorusActiveConcentration" 5e15)
(sdedr:define-constant-profile-region "Si_region" "Si_profile" "Si_layer")



#Doping of Si region
(sdedr:define-constant-profile "Si_profileCL" "PhosphorusActiveConcentration" 5e15)
(sdedr:define-constant-profile-region "Si_regionCL" "Si_profileCL" "contact_left")

#Doping of Si region
(sdedr:define-constant-profile "Si_profileCR" "PhosphorusActiveConcentration" 5e15)
(sdedr:define-constant-profile-region "Si_regionCR" "Si_profileCR" "contact_right")


#Doping of Ge region
(sdedr:define-constant-profile "Si_profileCC" "BoronActiveConcentration" 5e19)
(sdedr:define-constant-profile-region "Si_regionCC" "Si_profileCC" "n_contact")

#Doping of Ge region
(sdedr:define-constant-profile "Si_profileCCC" "BoronActiveConcentration" 5e16)
(sdedr:define-constant-profile-region "Si_regionCCC" "Si_profileCCC" "n_contactt")


#N center

(sdedr:define-refeval-window "BaseLine.SourceD" 
  "Line" (position (* L_abs -0.27) t_Si 0.0) (position (* L_abs 0.27) t_Si 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source3"
  "Gauss.SourceDrainD" "BaseLine.SourceD" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainD"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 5e18
  "ValueAtDepth" 5e13 "Depth" 1 "Gauss" "Factor" 0.35)


#P side center

(sdedr:define-refeval-window "BaseLine.SourceNC" 
  "Line" (position (* L_abs -0.4) t_Si 0.0) (position (* L_abs 0.4) t_Si 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source4"
  "Gauss.SourceDrainNC" "BaseLine.SourceNC" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainNC"
  "BoronActiveConcentration" "PeakPos" 0 "PeakVal" 7e18
  "ValueAtDepth" 5e13 "Depth" 0.30 "Gauss" "Factor" 0.35)



#			Depletion region


(sdedr:define-refeval-window "BaseLine.SourceDL" 
  "Line" (position (* L_abs 0.27) t_Si 0.0) (position (* L_abs 0.5) t_Si 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.SourceDL"
  "Gauss.SourceDrainDL" "BaseLine.SourceDL" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainDL"
  "BoronActiveConcentration" "PeakPos" 0 "PeakVal" 5e15
  "ValueAtDepth" 5e13 "Depth" 0.75 "Gauss" "Factor" 0.05)



(sdedr:define-refeval-window "BaseLine.SourceDRight" 
  "Line" (position (* L_abs -0.5) t_Si 0.0) (position (* L_abs -0.27) t_Si 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.SourceDRight"
  "Gauss.SourceDrainDRight" "BaseLine.SourceDRight" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainDRight"
  "BoronActiveConcentration" "PeakPos" 0 "PeakVal" 5e15
  "ValueAtDepth" 5e13 "Depth" 0.75 "Gauss" "Factor" 0.05)

##				Sinker


#Left

(sdedr:define-refeval-window "BaseLine.Source_Sinker_left" 
  "Line" (position (+ 5 (* L_Si -0.5)) t_Si 0) (position (+ 5 (+ L_dop (* L_Si -0.5))) t_Si 0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source_Sinker_left"
  "Gauss.SourceDrain_Sinker_left" "BaseLine.Source_Sinker_left" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrain_Sinker_left"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 5e17
  "ValueAtDepth" 5e13 "Depth" 0.75 "Gauss" "Factor" 0.35)

# Right

(sdedr:define-refeval-window "BaseLine.Source_Sinker_rightt" 
  "Line" (position (- (- (* L_Si 0.5) L_dop) 5) t_Si 0) (position (- (* L_Si 0.5) 5) t_Si 0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source_Sinker_rightt"
  "Gauss.SourceDrain_Sinker_rightt" "BaseLine.Source_Sinker_rightt" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrain_Sinker_rightt"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 5e17
  "ValueAtDepth" 5e13 "Depth" 0.75 "Gauss" "Factor" 0.35)


##########################################################################################



#Oxide layer
(sdedr:define-refeval-window "RefEvalWin.Oxide_layer" "Rectangle"  (position (* L_abs -0.3) t_Si 0) (position (* L_abs 0.3) (+ t_Si t_Ge)  0) )
(sdedr:define-refinement-size "RefinementDefinition.Oxide_layer" 0.5 0.005 0.1 0.001)
(sdedr:define-refinement-placement "RefinementPlacement.Oxide_layer" "RefinementDefinition.Oxide_layer" (list "window" "RefEvalWin.Oxide_layer"))

#Oxide layer
(sdedr:define-refeval-window "RefEvalWin.Oxidee_layer" "Rectangle"  (position (* L_abs -0.3) (+ t_Si t_Ge) 0) (position (* L_abs 0.3) (+ t_Ge (+ t_Si (* 10 t_Ox)))  0) )
(sdedr:define-refinement-size "RefinementDefinition.Oxidee_layer" 0.5 0.005 0.1 0.001)
(sdedr:define-refinement-placement "RefinementPlacement.Oxidee_layer" "RefinementDefinition.Oxidee_layer" (list "window" "RefEvalWin.Oxidee_layer"))


#Si Multiplication layer

(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer" "Rectangle"  (position (* L_Si -0.5) 0 0) (position (* L_Si 0.5) t_Si 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer" 0.5 0.1 0.1 0.05 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer" "RefinementDefinition.Si_multiplication_layer" (list "window" "RefEvalWin.Si_multiplication_layer"))




#P contact

(sdedr:define-refeval-window "RefEvalWin.Si_layer_left" "Rectangle"  (position (+ 5 (* L_Si -0.5)) t_Si 0) (position (+ 5 (+ L_dop (* L_Si -0.5))) (+ t_Ox t_Si) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_layer_left" 0.5 0.005 0.1 0.001 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_layer_left" "RefinementDefinition.Si_layer_left" (list "window" "RefEvalWin.Si_layer_left"))


#P contact

(sdedr:define-refeval-window "RefEvalWin.Si_layer_right" "Rectangle"  (position (- (* L_Si 0.5) 5) t_Si 0) (position (- (- (* L_Si 0.5) L_dop) 5) (+ t_Ox t_Si) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_layer_right" 0.5 0.005 0.1 0.001 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_layer_right" "RefinementDefinition.Si_layer_right" (list "window" "RefEvalWin.Si_layer_right"))



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
