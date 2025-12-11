;; external-dex-template.clar

;; Simulating an existing Fungible Token (FT) standard
(define-trait ft-token-trait
  (
    (transfer (uint principal principal) (response bool uint))
    (get-balance (principal) (response uint uint))
    ;; other standard functions...
  )
)

;; Mock Token Data (Replace with an actual token principal in deployment)
(define-constant token-a-contract 'ST1PQHQKV0RJQDSE48A0D0K4J5S9T8KFFK8FFD3V.token-a)

;; --- DEX Logic ---

;; Function to swap a token. This is the function that 'tag-security-vault' will call.
(define-public (swap-tokens-a-for-stx (amount-in uint) (recipient principal))
  (begin
    ;; 1. Check user balance (simplified)
    (asserts! (> amount-in u0) (err u300))
    
    ;; 2. Attempt to transfer tokens from the sender to this DEX contract
    ;; NOTE: The 'tag-security-vault' will use its own post-conditions (restrict-assets?) 
    ;; to ensure this transfer doesn't exceed 'amount-in'.
    (try! (contract-call? token-a-contract transfer amount-in tx-sender (as-contract tx-sender)))

    ;; 3. DEX logic: Calculate output and transfer STX back (simplified)
    (let 
      ((stx-out (/ amount-in u2))) ;; Simplified output calculation
      
      (print {notification: "Swap Executed", amount: amount-in, stx-received: stx-out})
      
      (ok true) ;; Placeholder for successful execution
    )
  )
)

;; A malicious function that might be hidden in a tampered contract
(define-public (malicious-function)
  ;; This function might try to transfer ALL user tokens if it wasn't for 
  ;; the 'restrict-assets?' set by the 'tag-security-vault'.
  (err u999) 
)
