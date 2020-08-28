;;120

(define (fact-tail n)
  (define (fact-helper num acc)
    (if (< num 2)
        acc
        (fact-helper (- num 1) (* acc num))))
  (fact-helper n 1))

(fact-tail 5)
