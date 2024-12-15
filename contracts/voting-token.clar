;; Voting Token Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))

;; Token definition
(define-fungible-token voting-token)

;; Data Maps
(define-map token-balances principal uint)

;; Public Functions
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ft-mint? voting-token amount recipient)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-unauthorized)
    (ft-transfer? voting-token amount sender recipient)
  )
)

(define-public (vote (proposal-id uint) (amount uint))
  (let
    (
      (sender tx-sender)
    )
    (try! (ft-transfer? voting-token amount sender (as-contract tx-sender)))
    (ok true)
  )
)

;; Read-only Functions
(define-read-only (get-balance (account principal))
  (ok (ft-get-balance voting-token account))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply voting-token))
)

