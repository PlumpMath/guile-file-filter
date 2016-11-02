(define-module (file filter)
  #:use-module (ice-9 optargs))

(define (with-input-port input proc)
  (call-with-values
      (lambda ()
        (proc input))
    (lambda vals
      (when (port-filename input)
            (close-input-port input))
      (apply values vals))))

(define (with-output-port output proc)
  (call-with-values
      (lambda ()
        (proc output))
    (lambda vals
      (when (port-filename output)
            (close-output-port output))
      (apply values vals))))

(define*-public (file-filter proc #:key (input (current-input-port)) (output (current-output-port)) (temporary-file #f) (keep-output? #f) (rename-hook (lambda (x) x)))
  (if (port? input)
      (unless (input-port? input)
              (error "INPUT is not input port"))
      (when (string? input)
            (set! input (open-input-file input))))
  (if (port? output)
      (unless (output-port? output)
              (error "OUTPUT is not output port"))
      (when (string? output)
            (set! output (open-output-file output))))

  (with-input-port input (lambda (input)
                           (with-output-port output (lambda (output)
                                                      (proc input output))))))
