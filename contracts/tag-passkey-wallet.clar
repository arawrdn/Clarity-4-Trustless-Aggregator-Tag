;; tag-passkey-wallet.clar

;; --- Constants and Data ---
(define-constant ERR-INVALID-SIGNATURE u200)
(define-constant ERR-LOCKUP-ACTIVE u201)
(define-constant ERR-NOT-AUTHORIZED u202)
(define-constant TIME-LOCK-PERIOD u4320) ;; 72 hours in Stacks blocks (approx 10 min/block * 6 * 72)

(define-data-var primary-pubkey (buff 65) 0x0)
(define-data-var emergency-pubkey (buff 65) 0x0)
(define-data-var withdrawal-start-time uint u0)

;; --- Core Clarity 4.0 Functions ---

;; 1. Passkey Authentication (secp256r1-verify)
(define-read-only (verify-passkey-signature (message (buff 32)) (signature (buff 64)) (pubkey (buff 65)))
  ;; Verifies a signature made with a Passkey (secp256r1) against a message and registered public key.
  (secp256r1-verify message signature pubkey)
)

;; 2. Initiate Time-Locked Emergency Withdrawal (using emergency passkey)
(define-public (initiate-emergency-withdraw (message (buff 32)) (signature (buff 64)))
  (let 
    ((emergency-key (var-get emergency-pubkey))
     (is-valid-signature (verify-passkey-signature message signature emergency-key)))
    
    (asserts! is-valid-signature ERR-INVALID-SIGNATURE)
    
    ;; Start the time-lock period
    (ok (var-set withdrawal-start-time (stacks-block-time)))
  )
)

;; 3. Execute Withdrawal (after time lock)
(define-public (execute-withdrawal)
  (let 
    ((lockup-start (var-get withdrawal-start-time))
     (current-time (stacks-block-time)))
    
    ;; Check if the TIME-LOCK-PERIOD has passed
    (asserts! (> current-time (+ lockup-start TIME-LOCK-PERIOD)) ERR-LOCKUP-ACTIVE)
    
    ;; Perform actual asset transfer (e.g., to a pre-defined recovery address)
    (ok true)
  )
)

;; 4. Cancel Withdrawal (using primary passkey during time lock)
(define-public (cancel-emergency-withdrawal (message (buff 32)) (signature (buff 64)))
  (let 
    ((primary-key (var-get primary-pubkey))
     (is-valid-signature (verify-passkey-signature message signature primary-key))
     (lockup-start (var-get withdrawal-start-time))
     (current-time (stacks-block-time)))

    (asserts! is-valid-signature ERR-INVALID-SIGNATURE)
    
    ;; Must be called during the time-lock period
    (asserts! (and (> lockup-start u0) (<= current-time (+ lockup-start TIME-LOCK-PERIOD))) ERR-NOT-AUTHORIZED)

    ;; Reset the withdrawal state
    (ok (var-set withdrawal-start-time u0))
  )
)
