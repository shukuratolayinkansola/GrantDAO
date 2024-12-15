;; Proposal Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))

;; Data Variables
(define-data-var proposal-count uint u0)

;; Data Maps
(define-map proposals
  { proposal-id: uint }
  {
    title: (string-ascii 100),
    description: (string-utf8 1000),
    requested-amount: uint,
    proposer: principal,
    status: (string-ascii 20)
  }
)

;; Public Functions
(define-public (submit-proposal (title (string-ascii 100)) (description (string-utf8 1000)) (requested-amount uint))
  (let
    (
      (new-proposal-id (+ (var-get proposal-count) u1))
    )
    (map-set proposals
      { proposal-id: new-proposal-id }
      {
        title: title,
        description: description,
        requested-amount: requested-amount,
        proposer: tx-sender,
        status: "submitted"
      }
    )
    (var-set proposal-count new-proposal-id)
    (ok new-proposal-id)
  )
)

(define-public (update-proposal-status (proposal-id uint) (new-status (string-ascii 20)))
  (let
    (
      (proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set proposals
      { proposal-id: proposal-id }
      (merge proposal { status: new-status })
    ))
  )
)

;; Read-only Functions
(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals { proposal-id: proposal-id })
)

(define-read-only (get-proposal-count)
  (ok (var-get proposal-count))
)

