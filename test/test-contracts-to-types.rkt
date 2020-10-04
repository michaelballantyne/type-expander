#lang type-expander
(require racket/contract/base
         type-expander/contracts-to-types
         typed/rackunit)

(begin
 (define-syntax-rule (check-written=? a b)
   (check-equal? (with-output-to-string (λ () a)) (format "~s\n" b)))
 (check-written=? (:contract→type (list/c 1 2 "str" (or/c integer? string?)))
                  '(List 1 2 "str" (U Integer String)))
 (check-written=? (:contract→type
                   (list/c integer? string? boolean? char? bytes?))
                  '(List Integer String Boolean Char Bytes))
 (check-written=? (:contract→type (*list/c integer? string? boolean?))
                  '(Rec R (U (Pairof Integer R) (List String Boolean))))
 (check-written=? (:contract→type (-> integer? boolean? string? symbol?))
                  '(-> Integer Boolean String Symbol))
 (check-written=? (:contract→type (-> integer? boolean? string? ... symbol?))
                  '(->* (Integer Boolean) #:rest String Symbol))
 (check-written=? (:contract→type (->* (integer? boolean?)
                                       (char?)
                                       #:rest (listof string?)
                                       symbol?))
                  '(->* (Integer Boolean) (Char) #:rest String Symbol))
 (check-written=? (:contract→type (->* (integer? boolean?)
                                       ()
                                       #:rest (listof string?)
                                       symbol?))
                  '(->* (Integer Boolean) () #:rest String Symbol))
 (check-written=? (:contract→type (->* (integer? boolean?)
                                       #:rest (listof string?)
                                       symbol?))
                  '(->* (Integer Boolean) #:rest String Symbol))
 (check-written=? (:contract→type (->* (integer? boolean?)
                                       symbol?))
                  '(->* (Integer Boolean) Symbol))
 (check-written=? (:contract→type (->* (integer? boolean?)
                                       (char?)
                                       symbol?))
                  '(->* (Integer Boolean) (Char) Symbol))
 (check-written=? (:contract→type (->* (integer? boolean?)
                                       ()
                                       symbol?))
                  '(->* (Integer Boolean) () Symbol))
 (check-written=? (:contract→type
                   (flat-rec-contract W (cons/c W W) number? string?))
                  '(Rec W (U (Pairof W W) Number String)))
 (check-written=? (:contract→type
                   (flat-rec-contract W
                                      (cons/c (flat-rec-contract R
                                                                 (cons/c W R)
                                                                 null?)
                                              W)
                                      number?
                                      string?))
                  '(Rec W (U (Pairof (Rec R (U (Pairof W R) Null)) W)
                             Number
                             String))))
