(sde:clear)
(sdegeo:set-auto-region-naming OFF)

;----------------------------------------------------------------------
(sde:clear)
; Setting parameters
; - lateral
(define Ltot   65)                  ; [um] Total device length
(define Labs   25)                  ; [um] Absorber length
(define Xabs1 (/ (- Ltot Labs) 2) ) 	; [um] x-Position first vertex absorber
(define Xabs2 (/ (+ Ltot Labs) 2) ) 	; [um] x-Position second vertex absorber

; - thickness
(define T_Substrate 0.5)		; [um] Thickness of substrate
(define T_Multiplication 1.4) 	; [um] Thickness of multiplication region
(define T_Charge_Sheet 0.1)	; [um] Thickness of charge sheet
(define T_Absorber 1) 		; [um] Thickness of absorber
(define T_TopGe 0.05)			; [um] Thickness of top Ge layer

; -position

(define ySubstrate T_Substrate)
(define yMultiplication (+ T_Multiplication T_Substrate) )
(define yCharge_Sheet (+ yMultiplication T_Charge_Sheet) )
(define yAbsorber (+ yCharge_Sheet T_Absorber) )
(define yTopGe (+ yAbsorber T_TopGe) )


;----------------------------------------------------------------------;
; Define structure
;----------------------------------------------------------------------;

(sdegeo:create-rectangle (position 0 0 0) (position Ltot ySubstrate 0) "Silicon" "Substrate")
(sdegeo:create-rectangle (position 0 ySubstrate 0) (position Ltot yMultiplication 0) "Silicon" "Multiplication")
(sdegeo:create-rectangle (position Xabs1 yMultiplication 0) (position Xabs2 yCharge_Sheet 0) "Silicon" "Charge_Sheet")
;(sde:set-default-material "Germanium")
(sdegeo:create-rectangle (position Xabs1 yCharge_Sheet 0) (position Xabs2 yAbsorber 0) "Germanium" "Absorber")
(sdegeo:create-rectangle (position Xabs1 yAbsorber 0) (position Xabs2 yTopGe 0) "Germanium" "TopGe")


(sdegeo:define-contact-set "Top" 4 (color:rgb 1 0 0) "##")
(sdegeo:define-contact-set "Bottom" 4 (color:rgb 0 1 0) "##")
(sdegeo:set-contact (find-edge-id (position Xabs1 yTopGe 0)) "Top")
(sdegeo:set-contact (find-edge-id (position Labs 0 0)) "Bottom")

;----------------------------------------------------------------------;
; Define doping profiles
;----------------------------------------------------------------------;

(sdedr:define-constant-profile "Const.Substrate" "PhosphorusActiveConcentration" 5e+19)
(sdedr:define-constant-profile-region "PlaceCD.Substrate" "Const.Substrate" "Substrate")

(sdedr:define-constant-profile "Const.Multiplication" "PhosphorusActiveConcentration" 1e+15)
(sdedr:define-constant-profile-region "PlaceCD.Multiplication" "Const.Multiplication" "Multiplication")

(sdedr:define-constant-profile "Const.Charge_Sheet" "BoronActiveConcentration" 1e+17)
(sdedr:define-constant-profile-region "PlaceCD.Charge_Sheet" "Const.Charge_Sheet" "Charge_Sheet")

(sdedr:define-constant-profile "Const.Absorber" "VacancyConcentration" 3e+15)
(sdedr:define-constant-profile-region "PlaceCD.Absorber" "Const.Absorber" "Absorber")

(sdedr:define-constant-profile "Const.TopGe" "BoronActiveConcentration" 5e+19)
(sdedr:define-constant-profile-region "PlaceCD.TopGe" "Const.TopGe" "TopGe")

;----------------------------------------------------------------------;
; Refinement Windows
;----------------------------------------------------------------------;

(sdedr:define-refeval-window "RefEvalWin.Substrate" "Rectangle"  (position 0 0 0) (position Ltot ySubstrate 0))
(sdedr:define-refinement-size "RefinementDefinition.Substrate" (/ Ltot 10) (/ T_Substrate 10) (/ Ltot 100) (/ T_Substrate 100))
(sdedr:define-refinement-placement "RefinementPlacement.Substrate" "RefinementDefinition.Substrate" (list "window" "RefEvalWin.Substrate"))

(sdedr:define-refeval-window "RefEvalWin.Multiplication" "Rectangle"  (position 0 ySubstrate 0) (position Ltot yMultiplication 0))
(sdedr:define-refinement-size "RefinementDefinition.Multiplication" (/ Ltot 10) (/ T_Multiplication 10) (/ Ltot 100) (/ T_Multiplication 100))
(sdedr:define-refinement-placement "RefinementPlacement.Multiplication" "RefinementDefinition.Multiplication" (list "window" "RefEvalWin.Multiplication"))

(sdedr:define-refeval-window "RefEvalWin.Charge_Sheet" "Rectangle"  (position Xabs1 yMultiplication 0) (position Xabs2 yCharge_Sheet 0))
(sdedr:define-refinement-size "RefinementDefinition.Charge_Sheet" (/ Labs 10) (/ T_Charge_Sheet 10) (/ Labs 100) (/ T_Charge_Sheet 100))
(sdedr:define-refinement-placement "RefinementPlacement.Charge_Sheet" "RefinementDefinition.Charge_Sheet" (list "window" "RefEvalWin.Charge_Sheet"))

(sdedr:define-refeval-window "RefEvalWin.Absorber" "Rectangle"  (position Xabs1 yCharge_Sheet 0) (position Xabs2 yAbsorber 0))
(sdedr:define-refinement-size "RefinementDefinition.Absorber" (/ Labs 10) (/ T_Absorber 10) (/ Labs 100) (/ T_Absorber 100))
(sdedr:define-refinement-placement "RefinementPlacement.Absorber" "RefinementDefinition.Absorber" (list "window" "RefEvalWin.Absorber"))

(sdedr:define-refeval-window "RefEvalWin.TopGe" "Rectangle"  (position Xabs1 yAbsorber 0) (position Xabs2 yTopGe 0))
(sdedr:define-refinement-size "RefinementDefinition.TopGe" (/ Labs 10) (/ T_TopGe 10) (/ Labs 100) (/ T_TopGe 100))
(sdedr:define-refinement-placement "RefinementPlacement.TopGe" "RefinementDefinition.TopGe" (list "window" "RefEvalWin.TopGe"))


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
;(sdesnmesh:iocontrols "outputFile" "sde_dvs")
;(sde:set-meshing-command "snmesh")
;(sde:set-project-name "sde_dvs")
;(sdesnmesh:iocontrols "outputFile" "sde_dvs")
;(sde:build-mesh "" "sde_dvs")
;(system:command "svisual sde_dvs_msh.tdr &")

