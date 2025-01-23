





  
(sde:clear)

#####################################################################################################################
#Definition of dimensions variables:

(define t_Ge 0.23) ;Ge absorption layer thickness (p)[um]
(define t_Ox 0.005) ;Oxide layer thickness (p)[um]
(define t_Si 5) ;Si charge sheet thickness (p)[um]
(define t_Etch 0.0) ;Etch depth (p)[um]
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



#P contact
(sdegeo:create-rectangle (position (+ (- t_Etch t_Ge) t_Si) (* L_abs -0.25)  0) (position  (+ t_Ge t_Si) (* L_abs 0.25) 0) "Germanium" "p_contactt")

#Ge absorber
(sdegeo:create-rectangle (position (+ t_Ge t_Si) (+ (* L_abs -0.25) 2) 0) (position (+ t_Ge (+ t_Si (* 10 t_Ox))) (- (* L_abs 0.25) 2) 0) "Germanium" "p_contact")

#Ge absorber
(sdegeo:create-rectangle (position (+ t_Ge t_Si) (* L_abs -0.25) 0) (position (+ t_Ge (+ t_Si (* 10 t_Ox))) (+ 2 (* L_abs -0.25)) 0) "Germanium" "p_contact_left")

#Ge absorber
(sdegeo:create-rectangle (position (+ t_Ge t_Si) (- (* L_abs 0.25) 2) 0) (position (+ t_Ge (+ t_Si (* 10 t_Ox))) (* L_abs 0.25) 0) "Germanium" "p_contact_right")
#########################################################################################
#Si_charge_layer
(sdegeo:create-rectangle (position 0 (* L_Si -0.5) 0) (position t_Si (* L_Si 0.5) 0) "Silicon" "Si_layer")


#N contact
(sdegeo:create-rectangle (position t_Si (+ 5 (* L_Si -0.5)) 0) (position (+ t_Ox t_Si) (+ 5 (+ L_dop (* L_Si -0.5))) 0) "Silicon" "contact_left")

#N contact
(sdegeo:create-rectangle (position t_Si (- (* L_Si 0.5) 5) 0) (position (+ t_Ox t_Si) (- (- (* L_Si 0.5) L_dop) 5) 0) "Silicon" "contact_right")

#####################################################################################################################

#Definition of the contacts (n_contact, p_contact)
#Ground contact
#(sdegeo:define-contact-set "g_contact" 4  (color:rgb 0.5 0 0.5 ) "##")
#(sdegeo:set-current-contact-set "g_contact")
#(sdegeo:set-contact-edges (find-edge-id (position (* 0.4 (- 0 t_Si)) (* L_Si -0.2) 0)))

#N contact

(sdegeo:define-contact-set "n_contact_left" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "n_contact_left")
(sdegeo:set-contact-edges (find-edge-id (position (+ t_Ox t_Si) (+ 5 (* L_Si -0.45)) 0)))


#N contact

(sdegeo:define-contact-set "n_contact_right" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:set-current-contact-set "n_contact_right")
(sdegeo:set-contact-edges (find-edge-id (position (+ t_Ox t_Si) (- (* L_Si 0.45) 5) 0)))


#P contact

(sdegeo:define-contact-set "p_contact_center" 4  (color:rgb 0 0 1) "##")
(sdegeo:set-current-contact-set "p_contact_center")
(sdegeo:set-contact-edges (find-edge-id (position (+ t_Ge (+ t_Si (* 10 t_Ox))) (+ 6 (* L_abs -0.2)) 0)))
#####################################################################################################################

#Doping of Si substrate

(sdedr:define-constant-profile "Si_profile" "BoronActiveConcentration" 5e15)
(sdedr:define-constant-profile-region "Si_region" "Si_profile" "Si_layer")


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
#1.1 instead of (* 0.5 L_dop)

(sdedr:define-refeval-window "BaseLine.SourceD" 
  "Line" (position (- (+ t_Etch t_Si) 1.15) (- (- 0 center) (* 0.5 L_dop)) 0.0) (position (- (+ t_Etch t_Si) 1.15) (+ (- 0 center) (* 0.5 L_dop)) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source3"
  "Gauss.SourceDrainD" "BaseLine.SourceD" "Both" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainD"
  "BoronActiveConcentration" "PeakPos" 0 "PeakVal" 2e18
  "ValueAtDepth" 5e17 "Depth" 0.4 "Gauss" "Factor" 0.2)


#N shallow  

(sdedr:define-refeval-window "BaseLine.SourceNC" 
  "Line" (position (+ t_Etch t_Si) (- (- 0 center) (* 0.5 L_dop))  0.0) (position (+ t_Etch t_Si) (+ (- 0 center) (* 0.5 L_dop)) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source4"
  "Gauss.SourceDrainNC" "BaseLine.SourceNC" "Positive" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainNC"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 9e18
  "ValueAtDepth" 5e17 "Depth" 0.75 "Gauss" "Factor" 0.1)



#Depletion region left





(sdedr:define-refeval-window "BaseLine.SourceDRight" 
  "Line" (position (+ t_Ge (+ t_Si (* 10 t_Ox))) (- (* -0.25 L_abs) 1) 0.0) (position  (+ t_Ge (+ t_Si (* 10 t_Ox))) (+ (* -0.25 L_abs) 1) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.SourceDRight"
  "Gauss.SourceDrainDRight" "BaseLine.SourceDRight" "Positive" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainDRight"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 5.5e15
  "ValueAtDepth" 5e15 "Depth" 0.75 "Gauss" "Factor" 0.1)




#Right side

#P deep 

(sdedr:define-refeval-window "BaseLine.SourceDRR" 
  "Line" (position (- (+ t_Etch t_Si) 1.15) (- center (* 0.5 L_dop))  0.0) (position (- (+ t_Etch t_Si) 1.15) (+ center (* 0.5 L_dop)) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source3RR"
  "Gauss.SourceDrainDRR" "BaseLine.SourceDRR" "Both" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainDRR"
  "BoronActiveConcentration" "PeakPos" 0 "PeakVal" 2e18
  "ValueAtDepth" 5e17 "Depth" 0.4 "Gauss" "Factor" 0.2)


#N shallow  

(sdedr:define-refeval-window "BaseLine.SourceNCRR" 
  "Line" (position (+ t_Etch t_Si) (- center (* 0.5 L_dop))  0.0) (position (+ t_Etch t_Si) (+ center (* 0.5 L_dop)) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.Source4RR"
  "Gauss.SourceDrainNCRR" "BaseLine.SourceNCRR" "Positive" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainNCRR"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 9e18
  "ValueAtDepth" 5e17 "Depth" 0.75 "Gauss" "Factor" 0.1)



#Depletion region right


(sdedr:define-refeval-window "BaseLine.SourceDLRR" 
  "Line" (position (+ t_Ge (+ t_Si (* 10 t_Ox))) (- (* 0.25 L_abs) 1) 0.0) (position (+ t_Ge (+ t_Si (* 10 t_Ox))) (+ (* 0.25 L_abs) 1) 0.0))
#Definition of the doping (n,p)

(sdedr:define-analytical-profile-placement "PlaceAP.SourceDLRR"
  "Gauss.SourceDrainDLRR" "BaseLine.SourceDLRR" "Positive" "NoReplace" "Eval")

(sdedr:define-gaussian-profile "Gauss.SourceDrainDLRR"
  "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 5.5e15
  "ValueAtDepth" 5e15 "Depth" 0.75 "Gauss" "Factor" 0.1)




##########################################################################################




#Oxide layer
(sdedr:define-refeval-window "RefEvalWin.Oxideee_layer" "Rectangle"  (position t_Si (* L_abs -0.3) 0) (position (+ t_Ge (+ t_Si (* 10 t_Ox))) (* L_abs 0.3) 0) )
(sdedr:define-refinement-size "RefinementDefinition.Oxideee_layer" 0.005 0.5 0.001 0.1)
(sdedr:define-refinement-placement "RefinementPlacement.Oxideee_layer" "RefinementDefinition.Oxideee_layer" (list "window" "RefEvalWin.Oxideee_layer"))


#Si Multiplication layer

(sdedr:define-refeval-window "RefEvalWin.Si_multiplication_layer" "Rectangle"  (position 0 (* L_Si -0.5) 0) (position t_Si (* L_Si 0.5) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_multiplication_layer" 0.2 0.4 0.05 0.1 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_multiplication_layer" "RefinementDefinition.Si_multiplication_layer" (list "window" "RefEvalWin.Si_multiplication_layer"))



###########################


###########################

#P contact

(sdedr:define-refeval-window "RefEvalWin.Si_layer_left" "Rectangle"  (position t_Si (+ 2 (* L_Si -0.5)) 0) (position (+ t_Ox t_Si) (+ 2 (+ L_dop (* L_Si -0.5))) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_layer_left" 0.005 0.5 0.001 0.1 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_layer_left" "RefinementDefinition.Si_layer_left" (list "window" "RefEvalWin.Si_layer_left"))


#P contact

(sdedr:define-refeval-window "RefEvalWin.Si_layer_right" "Rectangle"  (position t_Si (- (* L_Si 0.5) 2) 0) (position (+ t_Ox t_Si) (- (- (* L_Si 0.5) L_dop) 2) 0))
(sdedr:define-refinement-size "RefinementDefinition.Si_layer_right" 0.005 0.5 0.001 0.1 )
(sdedr:define-refinement-placement "RefinementPlacement.Si_layer_right" "RefinementDefinition.Si_layer_right" (list "window" "RefEvalWin.Si_layer_right"))


(sdedr:define-refeval-window 
  "RefEvalWin_pn" "Rectangle"  (position 0 (* L_Si -0.5) 0)  (position t_Si (* L_Si 0.5) 0.0 ))
(sdedr:define-refinement-size "pn_define" 0.2 0.4 0.005 0.02)
(sdedr:define-refinement-placement "pn_refine" "pn_define" "RefEvalWin_pn" )
(sdedr:define-refinement-function 
  "pn_define" "DopingConcentration" "MaxTransDiff" 1)


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

