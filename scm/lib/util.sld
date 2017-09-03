(define-library (lib util)

(export call-with-input-string call-with-output-string
        str prn debug

        ;; HACK: cyclone doesn't have those
        error-object? error-object-message error-object-irritants)

(import (scheme base))
(import (scheme write))

(begin

;; HACK: cyclone currently implements error the SICP way
(cond-expand
 (cyclone
  (define error-object? pair?)
  (define error-object-message car)
  (define error-object-irritants cdr))
 (else))

(define (call-with-input-string string proc)
  (let ((port (open-input-string string)))
    (dynamic-wind
        (lambda () #t)
        (lambda () (proc port))
        (lambda () (close-input-port port)))))

(define (call-with-output-string proc)
  (let ((port (open-output-string)))
    (dynamic-wind
        (lambda () #t)
        (lambda () (proc port) (get-output-string port))
        (lambda () (close-output-port port)))))

(define (str . items)
  (call-with-output-string
   (lambda (port)
     (for-each (lambda (item) (display item port)) items))))

(define (prn . items)
  (for-each write items)
  (newline))

(define (debug . items)
  (parameterize ((current-output-port (current-error-port)))
    (apply prn items)))

(define (intersperse items sep)
  (let loop ((items items)
             (acc '()))
    (if (null? items)
        (reverse acc)
        (let ((tail (cdr items)))
          (if (null? tail)
              (loop (cdr items) (cons (car items) acc))
              (loop (cdr items) (cons sep (cons (car items) acc))))))))

(define (string-intersperse items sep)
  (apply string-append (intersperse items sep)))

(define (list->alist items)
  (let loop ((items items)
             (acc '()))
    (if (null? items)
        (reverse acc)
        (let ((key (car items)))
          (when (null? (cdr items))
            (error "unbalanced list"))
          (let ((value (cadr items)))
            (loop (cddr items)
                  (cons (cons key value) acc)))))))

(define (alist->list items)
  (let loop ((items items)
             (acc '()))
    (if (null? items)
        (reverse acc)
        (let ((kv (car items)))
          (loop (cdr items)
                (cons (cdr kv) (cons (car kv) acc)))))))

)

)
