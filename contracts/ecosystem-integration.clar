;; Ecosystem Integration Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))

;; Data Maps
(define-map integrated-organizations
  { org-id: (string-ascii 64) }
  {
    name: (string-ascii 100),
    website: (string-ascii 100),
    api-key: (buff 32),
    status: (string-ascii 20)
  }
)

;; Public Functions
(define-public (register-organization (org-id (string-ascii 64)) (name (string-ascii 100)) (website (string-ascii 100)) (api-key (buff 32)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set integrated-organizations
      { org-id: org-id }
      {
        name: name,
        website: website,
        api-key: api-key,
        status: "active"
      }
    ))
  )
)

(define-public (update-organization-status (org-id (string-ascii 64)) (new-status (string-ascii 20)))
  (let
    (
      (org (unwrap! (map-get? integrated-organizations { org-id: org-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set integrated-organizations
      { org-id: org-id }
      (merge org { status: new-status })
    ))
  )
)

(define-public (submit-external-proposal (org-id (string-ascii 64)) (external-id (string-ascii 64)) (title (string-ascii 100)) (description (string-utf8 1000)) (requested-amount uint))
  (let
    (
      (org (unwrap! (map-get? integrated-organizations { org-id: org-id }) err-not-found))
    )
    (asserts! (is-eq (get status org) "active") err-unauthorized)
    ;; Here we would typically verify the API key and make an external API call
    ;; For simplicity, we'll just call the submit-proposal function from the proposal contract
    (contract-call? .proposal submit-proposal title description requested-amount)
  )
)

;; Read-only Functions
(define-read-only (get-organization (org-id (string-ascii 64)))
  (map-get? integrated-organizations { org-id: org-id })
)

