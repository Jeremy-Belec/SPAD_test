(sde:clear)
(sdegeo:set-auto-region-naming OFF)

;----------------------------------------------------------------------;
; Define structure
;----------------------------------------------------------------------;

(sdegeo:create-rectangle (position 0 -0.5 0) (position 65 0 0) "Silicon" "Substrate")
(sdegeo:create-rectangle (position 0 0 0) (position 65 1.4 0) "Silicon" "Multiplication")
(sdegeo:create-rectangle (position 20 1.4 0) (position 45 1.5 0) "Silicon" "Charge_Sheet")
(sde:set-default-material "Germanium")
(sdegeo:create-rectangle (position 20 1.5 0) (position 45 2.5 0) "Germanium" "Absorber")
(sdegeo:create-rectangle (position 20 2.5 0) (position 45 2.55 0) "Germanium" "TopGe")


;----------------------------------------------------------------------;
; Define electrodes
;----------------------------------------------------------------------;

(sdegeo:define-contact-set "Top" 4 (color:rgb 1 0 0) "##")
(sdegeo:define-contact-set "Bottom" 4 (color:rgb 0 1 0) "##")
(sdegeo:set-contact (find-edge-id (position 25 2.55 0)) "Top")
(sdegeo:set-contact (find-edge-id (position 10 -0.5 0)) "Bottom")

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

(sdedr:define-refeval-window "RefEvalWin.Substrate" "Rectangle"  (position 0 0 0) (position 60 -0.5 0))
(sdedr:define-refinement-size "RefinementDefinition.Substrate" 6 0.05 0.06 0.005)
(sdedr:define-refinement-placement "RefinementPlacement.Substrate" "RefinementDefinition.Substrate" (list "window" "RefEvalWin.Substrate"))

(sdedr:define-refeval-window "RefEvalWin.Multiplication" "Rectangle"  (position 0 0 0) (position 60 1.4 0))
(sdedr:define-refinement-size "RefinementDefinition.Multiplication" 6 0.14 0.06 0.014)
(sdedr:define-refinement-placement "RefinementPlacement.Multiplication" "RefinementDefinition.Multiplication" (list "window" "RefEvalWin.Multiplication"))

(sdedr:define-refeval-window "RefEvalWin.Charge_Sheet" "Rectangle"  (position 20 1.4 0) (position 45 1.5 0))
(sdedr:define-refinement-size "RefinementDefinition.Charge_Sheet" 2.5 0.01 0.25 0.001)
(sdedr:define-refinement-placement "RefinementPlacement.Charge_Sheet" "RefinementDefinition.Charge_Sheet" (list "window" "RefEvalWin.Charge_Sheet"))

(sdedr:define-refeval-window "RefEvalWin.Absorber" "Rectangle"  (position 20 1.5 0) (position 60 2.5 0))
(sdedr:define-refinement-size "RefinementDefinition.Absorber" 2.5 0.1 0.25 0.01)
(sdedr:define-refinement-placement "RefinementPlacement.Absorber" "RefinementDefinitison.Absorber" (list "window" "RefEvalWin.Absorber"))

(sdedr:define-refeval-window "RefEvalWin.TopGe" "Rectangle"  (position 20 2.5 0) (position 60 2.55 0))
(sdedr:define-refinement-size "RefinementDefinition.TopGe" 0.005 0.1 0.0005 0.01)
(sdedr:define-refinement-placement "RefinementPlacement.TopGe" "RefinementDefinition.TopGe" (list "window" "RefEvalWin.TopGe"))

;----------------------------------------------------------------------;
; Meshing building
;----------------------------------------------------------------------;

(sde:set-project-name "sde_dvs")
(sdesnmesh:iocontrols "outputFile" "sde_dvs")
(sde:set-meshing-command "snmesh")
(sde:set-project-name "sde_dvs")
(sdesnmesh:iocontrols "outputFile" "sde_dvs")
(sde:build-mesh "" "sde_dvs")
(system:command "svisual sde_dvs_msh.tdr &")
