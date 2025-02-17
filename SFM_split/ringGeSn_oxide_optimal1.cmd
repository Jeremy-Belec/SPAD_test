


  
(sde:clear)

#####################################################################################################################
#Definition of dimensions variables:

(define t_Ge 0.23) ;Ge absorption layer thickness (p)[um]
(define t_Ox 0.005) ;Oxide layer thickness (p)[um]
(define t_Si 2) ;Si charge sheet thickness (p)[um]
(define t_Etch 1) ;Etch depth (p)[um]
(define t_dop 0.3) ;doping profile thickness (n)[um]
(define t_contact 0.005) ;thickness of contacts (n)[um]
(define t_p 1) ;thickness p Si layer (n)[um]
(define t_n 3) ;thickness n wafer (n)[um]

(define L_abs 24) ;Length of Ge absorption layer [um]
(define L_Si 36) ;Length of Si multiplication region [um] 
(define L_dop 3.5) ;Length of Si doping profile [um] (length of device)
(define C (- (* L_Si 0.5) 5) )
(define D (- (- (* L_Si 0.5) L_dop) 5) )
(define center (* 0.5 (+ C D)) )

#Definition of Doping variables

(define P_side 1e18) ;P doping of absorber
(define dop_Ge 1e15) ;P doping of charge sheet
(define dop_Si 5e13) ;P doping of charge sheet
(define N_side 1e18) ;N doping of multiplication region

(define P_cont 1e19) ;P doping of absorber
(define N_cont 1e19) ;P doping of absorber
#####################################################################################################################

#Definition of the device

#Si etch
(sdegeo:create-rectangle (position (* L_abs -0.25) t_Si 0) (position (* L_abs 0.25) (+ (- t_Etch t_Ge) t_Si) 0) "Silicon" "Si_EtchC")

(sdegeo:create-rectangle (position (* L_Si -0.5) t_Si 0) (position (- (* L_abs -0.3) 1) (+ t_Etch t_Si) 0) "Silicon" "Si_Etch_Left")

(sdegeo:create-rectangle (position (+ (* L_abs 0.3) 1) t_Si 0) (position (* L_Si 0.5) (+ t_Etch t_Si) 0) "Silicon" "Si_Etch_Right")

#SiO2
(sdegeo:create-rectangle (position (- (* L_abs -0.25) 2) t_Si 0) (position (* L_abs -0.25) (+ t_Etch t_Si) 0) "SiO2" "SiO2_Etch")

(sdegeo:create-rectangle (position (* L_abs 0.25) t_Si 0) (position (+ (* L_abs 0.25) 2) (+ t_Etch t_Si) 0) "SiO2" "SiO2_Etch")


#P contact
(sdegeo:create-rectangle (position (* L_abs -0.25) (+ (- t_Etch t_Ge) t_Si) 0) (position (* L_abs 0.25) (+ t_Etch t_Si) 0) "Germanium" "p_contactt")

#Ge absorber
(sdegeo:create-rectangle (position (* L_abs -0.25) (+ t_Etch t_Si) 0) (position (* L_abs 0.25) (+ t_Etch (+ t_Si (* 10 t_Ox))) 0) "Germanium" "p_contact")

#Ge absorber
#(sdegeo:create-rectangle (position (* L_abs -0.25) (+ t_Etch t_Si) 0) (position (+ 2 (* L_abs #-0.25)) (+ t_Etch (+ t_Si (* 10 t_Ox))) 0) "Germanium" "p_contact_left")

#Ge absorber
#(sdegeo:create-rectangle (position (- (* L_abs 0.25) 2) (+ t_Etch t_Si) 0) (position (* L_abs #0.25) (+ t_Etch (+ t_Si (* 10 t_Ox))) 0) "Germanium" "p_contact_right")
#########################################################################################
#Si_charge_layer
(sdegeo:create-rectangle (position (* L_Si -0.5) 0 0) (position (* L_Si 0.5) t_Si 0) "Silicon" "Si_layer")


#N contact
(sdegeo:create-rectangle (position (+ 5 (* L_Si -0.5)) (+ t_Etch t_Si) 0) (position (+ 5 (+ L_dop (* L_Si -0.5))) (+ t_Ox (+ t_Etch t_Si)) 0) "Silicon" "contact_left")

#N contact
(sdegeo:create-rectangle (position (- (* L_Si 0.5) 5) (+ t_Etch t_Si) 0) (position (- (- (* L_Si 0.5) L_dop) 5) (+ t_Ox (+ t_Etch t_Si)) 0) "Silicon" "contact_right")

#####################################################################################################################

#Definition of the contacts (n_contact, p_contact)
#Ground contact
#(sdegeo:define-contact-set "g_contact" 4  (color:rgb 0.5 0 0.5 ) "##")
#(sdegeo:set-current-contact-set "g_contact")
#(sdegeo:set-contact-edges (find-edge-id (position (* L_Si -0.2) (* 0.4 (- 0 t_Si)) 0)))

#N contact

(sdegeo:define-contact-set "n_contact_left" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "n_contact_left")
(sdegeo:set-contact-edges (find-edge-id (position (+ 5 (* L_Si -0.45)) (+ t_Etch (+ t_Ox t_Si)) 0)))


#N contact

(sdegeo:define-contact-set "n_contact_right" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "n_contact_right")
(sdegeo:set-contact-edges (find-edge-id (position (- (* L_Si 0.45) 5) (+ t_Etch (+ t_Ox t_Si)) 0)))


#P contact

(sdegeo:define-contact-set "p_contact_center" 4  (color:rgb 0 0 1) "##")
(sdegeo:set-current-contact-set "p_contact_center")
(sdegeo:set-contact-edges (find-edge-id (position (+ 6 (* L_abs -0.2)) (+ t_Etch (+ t_Si (* 10 t_Ox))) 0)))
#####################################################################################################################

#Doping of Si substrate

(sdedr:define-constant-profile "Si_profile" "BoronActiveConcentration" 1e15)
(sdedr:define-constant-profile-region "Si_region" "Si_profile" "Si_layer")

(sdedr:define-constant-profile "Si_profileEC" "BoronActiveConcentration" 1e15)
(sdedr:define-constant-profile-region "Si_regionEC" "Si_profileEC" "Si_EtchC")

(sdedr:define-constant-profile "Si_profileEL" "BoronActiveConcentration" 1e15)
(sdedr:define-constant-profile-region "Si_regionEL" "Si_profileEL" "Si_Etch_Left")

(sdedr:define-constant-profile "Si_profileER" "BoronActiveConcentration" 1e15)
(sdedr:define-constant-profile-region "Si_regionER" "Si_profileER" "Si_Etch_Right")



#Doping of Si Contacts
(sdedr:define-constant-profile "Si_profileCL" "PhosphorusActiveConcentration" 5e19)
(sdedr:define-constant-profile-region "Si_regionCL" "Si_profileCL" "contact_left")

(sdedr:define-constant-profile "Si_profileCR" "PhosphorusActiveConcentration" 5e19)
(sdedr:define-constant-profile-region "Si_regionCR" "Si_profileCR" "contact_right")


#Doping of Ge contact
(sdedr:define-constant-profile "Si_profileCC" "BoronActiveConcentration" 5e18)
(sdedr:define-constant-profile-region "Si_regionCC" "Si_profileCC" "p_contact")

#Doping of Ge contact
#(sdedr:define-constant-profile "Si_profileCCL" "BoronActiveConcentration" 5e16)
#(sdedr:define-constant-profile-region "Si_regionCCL" "Si_profileCCL" "p_contact_left")

#Doping of Ge contact
#(sdedr:define-constant-profile "Si_profileCCR" "BoronActiveConcentration" 5e16)
#(sdedr:define-constant-profile-region "Si_regionCCR" "Si_profileCCR" "p_contact_right")

#Doping of Ge absorber
(sdedr:define-constant-profile "Si_profileCCC" "BoronActiveConcentration" 5e16)
(sdedr:define-constant-profile-region "Si_regionCCC" "Si_profileCCC" "p_contactt")

#Left side

#P deep 

(sdedr:define-refeval-window "BaseLine.SourceD" 
  "Line" (position (- (- 0 center) 1) (+ t_Etch t_Si) 0.0) (position (+ (- 0 center) 1) (+ t_Etch t_Si) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source3"
  "Gauss.SourceDrainD" "BaseLine.SourceD" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainD"
  "BoronActiveConcentration" "PeakPos" 0 "PeakVal" 2e18
  "ValueAtDepth" 5e13 "Depth" 1 "Gauss" "Factor" 0.2)


#N shallow  

(sdedr:define-refeval-window "BaseLine.SourceNC" 
  "Line" (position (- (- 0 center) (* 0.5 L_dop)) (+ t_Etch t_Si) 0.0) (position (+ (- 0 center) (* 0.5 L_dop)) (+ t_Etch t_Si) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source4"
  "Gauss.SourceDrainNC" "BaseLine.SourceNC" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainNC"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 5e19
  "ValueAtDepth" 5e13 "Depth" 0.67 "Gauss" "Factor" 0.1)



#Depletion region left


(sdedr:define-refeval-window "BaseLine.SourceDL" 
  "Line" (position (- (- (- 0 center) 1) 4) (+ t_Etch t_Si) 0.0) (position (- (- 0 center) 1) (+ t_Etch t_Si) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.SourceDL"
  "Gauss.SourceDrainDL" "BaseLine.SourceDL" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainDL"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 4e15
  "ValueAtDepth" 5e13 "Depth" 1.5 "Gauss" "Factor" 0.35)





#Right side

#P deep 

(sdedr:define-refeval-window "BaseLine.SourceDRR" 
  "Line" (position (- center 1) (+ t_Etch t_Si) 0.0) (position (+ center 1) (+ t_Etch t_Si) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source3RR"
  "Gauss.SourceDrainDRR" "BaseLine.SourceDRR" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainDRR"
  "BoronActiveConcentration" "PeakPos" 0 "PeakVal" 2e18
  "ValueAtDepth" 5e13 "Depth" 1 "Gauss" "Factor" 0.2)


#N shallow  

(sdedr:define-refeval-window "BaseLine.SourceNCRR" 
  "Line" (position (- center (* 0.5 L_dop)) (+ t_Etch t_Si) 0.0) (position (+ center (* 0.5 L_dop)) (+ t_Etch t_Si) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source4RR"
  "Gauss.SourceDrainNCRR" "BaseLine.SourceNCRR" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainNCRR"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 5e19
  "ValueAtDepth" 5e13 "Depth" 0.67 "Gauss" "Factor" 0.1)



#Depletion region right




(sdedr:define-refeval-window "BaseLine.SourceDRightRR" 
  "Line" (position (+ center 1) (+ t_Etch t_Si) 0.0) (position (+ 4 (+ center 1)) (+ t_Etch t_Si) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.SourceDRightRR"
  "Gauss.SourceDrainDRightRR" "BaseLine.SourceDRightRR" "Negative" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainDRightRR"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 4e15
  "ValueAtDepth" 5e13 "Depth" 1.5 "Gauss" "Factor" 0.35)



##########################################################################################



#Oxide layer
(sdedr:define-refeval-window "RefEvalWin.Oxide_layer" "Rectangle"  (position (* L_abs -0.3) t_Si 0) (position (* L_abs 0.3) (+ (- t_Etch t_Ge) t_Si) 0) )
(sdedr:define-refinement-size "RefinementDefinition.Oxide_layer" 0.5 0.005 0.1 0.001)
(sdedr:define-refinement-placement "RefinementPlacement.Oxide_layer" "RefinementDefinition.Oxide_layer" (list "window" "RefEvalWin.Oxide_layer"))

#Oxide layer
(sdedr:define-refeval-window "RefEvalWin.Oxidee_layer" "Rectangle"  (position (* L_abs -0.3) (+ (- t_Etch t_Ge) t_Si) 0) (position (* L_abs 0.3) (+ t_Etch t_Si) 0) )
(sdedr:define-refinement-size "RefinementDefinition.Oxidee_layer" 0.5 0.005 0.1 0.001)
(sdedr:define-refinement-placement "RefinementPlacement.Oxidee_layer" "RefinementDefinition.Oxidee_layer" (list "window" "RefEvalWin.Oxidee_layer"))

#Oxide layer
(sdedr:define-refeval-window "RefEvalWin.Oxideee_layer" "Rectangle"  (position (* L_abs -0.3) (+ t_Etch t_Si) 0) (position (* L_abs 0.3) (+ t_Etch (+ t_Si (* 10 t_Ox))) 0) )
(sdedr:define-refinement-size "RefinementDefinition.Oxideee_layer" 0.5 0.005 0.1 0.001)
(sdedr:define-refinement-placement "RefinementPlacement.Oxideee_layer" "RefinementDefinition.Oxideee_layer" (list "window" "RefEvalWin.Oxideee_layer"))


#Si Multiplication layer

(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer" "Rectangle"  (position (* L_Si -0.5) 0 0) (position (* L_Si 0.5) t_Si 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer" 0.2 0.1 0.1 0.05 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer" "RefinementDefinition.Si_multiplication_layer" (list "window" "RefEvalWin.Si_multiplication_layer"))

(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer_EL" "Rectangle"  (position (+ (* L_abs 0.3) 1) t_Si 0) (position (* L_Si 0.5) (+ t_Si t_Etch) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer_EL" 0.5 0.1 0.1 0.05 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer_EL" "RefinementDefinition.Si_multiplication_layer_EL" (list "window" "RefEvalWin.Si_multiplication_layer_EL"))

(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer_ER" "Rectangle"  (position (* L_Si -0.5) t_Si 0) (position (- (* L_abs -0.3) 1) (+ t_Si t_Etch) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer_ER" 0.5 0.1 0.1 0.05 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer_ER" "RefinementDefinition.Si_multiplication_layer_ER" (list "window" "RefEvalWin.Si_multiplication_layer_ER"))

###########################
#SiO2
(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer_SiO2L" "Rectangle"  (position (- (* L_abs -0.25) 2) t_Si 0) (position (* L_abs -0.25) (+ t_Etch t_Si) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer_SiO2L" 0.5 0.1 0.1 0.05 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer_SiO2L" "RefinementDefinition.Si_multiplication_layer_SiO2L" (list "window" "RefEvalWin.Si_multiplication_layer_SiO2L"))


(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer_SiO2R" "Rectangle"  (position (* L_abs 0.25) t_Si 0) (position (+ (* L_abs 0.25) 2) (+ t_Etch t_Si) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer_SiO2R" 0.5 0.1 0.1 0.05 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer_SiO2R" "RefinementDefinition.Si_multiplication_layer_SiO2R" (list "window" "RefEvalWin.Si_multiplication_layer_SiO2R"))



###########################

#P contact

(sdedr:define-refeval-window "RefEvalWin.Si_layer_left" "Rectangle"  (position (+ 2 (* L_Si -0.5)) t_Si 0) (position (+ 2 (+ L_dop (* L_Si -0.5))) (+ t_Ox t_Si) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_layer_left" 0.5 0.005 0.1 0.001 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_layer_left" "RefinementDefinition.Si_layer_left" (list "window" "RefEvalWin.Si_layer_left"))


#P contact

(sdedr:define-refeval-window "RefEvalWin.Si_layer_right" "Rectangle"  (position (- (* L_Si 0.5) 2) t_Si 0) (position (- (- (* L_Si 0.5) L_dop) 2) (+ t_Ox t_Si) 0))
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
