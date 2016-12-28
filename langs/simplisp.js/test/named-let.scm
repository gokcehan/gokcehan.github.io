;;120

(define (fact-sugar n)
  (let fact-helper ((num n) (acc 1))
    (if (< num 2)
        acc
        (fact-helper (- num 1) (* acc num)))))

(fact-sugar 5)
