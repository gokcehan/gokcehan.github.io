;;3

(define sum-curry
  (lambda (x)
    (lambda (y)
      (+ x y))))

((sum-curry 1) 2)
