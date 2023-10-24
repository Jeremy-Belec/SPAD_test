#Si_multiplication_layer
(sdegeo:create-rectangle (position (* L_mult -0.5) (+ A B) 0) (position (* L_charge -0.5) (+ C (+ A B)) 0) "Silicon" "Si_multiplication_layer")

(sdegeo:create-rectangle (position (* L_charge 0.5) (+ A B) 0) (position (* L_mult 0.5) (+ C (+ A B)) 0) "Silicon" "Si_multiplication_layer")

(sdegeo:set-default-boolean "AB")

(sdegeo:create-rectangle (position (* L_dev -0.5) (+ C (+ A B)) 0) (position (* L_dev 0.5) (+ D (+ C (+ A B))) 0) "Silicon" "Si_multiplication_layer")

(sdegeo:set-default-boolean "ABA")

  
