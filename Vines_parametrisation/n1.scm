
;; Defined Parameters:

;; Contact Sets:
(sdegeo:define-contact-set "Top" 4 (color:rgb 1 0 0 )"##" )
(sdegeo:define-contact-set "Bottom" 4 (color:rgb 0 1 0 )"##" )

;; Work Planes:
(sde:workplanes-init-scm-binding)

;; Defined ACIS Refinements:
(sde:refinement-init-scm-binding)

;; Reference/Evaluation Windows:
(sdedr:define-refeval-window "RefEvalWin.Substrate" "Rectangle" (position 0 0 0) (position 65 0.5 0))
(sdedr:define-refeval-window "RefEvalWin.Multiplication" "Rectangle" (position 0 0.5 0) (position 65 1.9 0))
(sdedr:define-refeval-window "RefEvalWin.Charge_Sheet" "Rectangle" (position 20 1.9 0) (position 45 2 0))
(sdedr:define-refeval-window "RefEvalWin.Absorber" "Rectangle" (position 20 2 0) (position 45 3 0))
(sdedr:define-refeval-window "RefEvalWin.TopGe" "Rectangle" (position 20 3 0) (position 45 3.05 0))

;; Restore GUI session parameters:
(sde:set-window-position 0 0)
(sde:set-window-size 840 800)
(sde:set-window-style "Windows")
(sde:set-background-color 0 127 178 204 204 204)
(sde:scmwin-set-prefs "Liberation Sans" "Normal" 8 124 )
