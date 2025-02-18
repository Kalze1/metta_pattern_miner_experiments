!(bind! metta-random  (py-atom random))
!((py-dot metta-random randint) 1000 9999)

!((py-dot (py-atom )) 1 2)