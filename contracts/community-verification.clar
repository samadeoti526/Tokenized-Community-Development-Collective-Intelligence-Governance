;; Community Verification Contract
;; Validates collective intelligence communities

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_COMMUNITY_EXISTS (err u101))
(define-constant ERR_COMMUNITY_NOT_FOUND (err u102))
(define-constant ERR_INVALID_THRESHOLD (err u103))

;; Community data structure
(define-map communities
  { community-id: uint }
  {
    name: (string-ascii 50),
    creator: principal,
    members-count: uint,
    verification-threshold: uint,
    is-verified: bool,
    created-at: uint
  }
)

;; Member verification tracking
(define-map member-verifications
  { community-id: uint, member: principal }
  { verified-by: (list 10 principal), verification-count: uint }
)

;; Community counter
(define-data-var community-counter uint u0)

;; Create new community
(define-public (create-community (name (string-ascii 50)) (verification-threshold uint))
  (let ((community-id (+ (var-get community-counter) u1)))
    (asserts! (> verification-threshold u0) ERR_INVALID_THRESHOLD)
    (asserts! (<= verification-threshold u10) ERR_INVALID_THRESHOLD)
    (map-set communities
      { community-id: community-id }
      {
        name: name,
        creator: tx-sender,
        members-count: u1,
        verification-threshold: verification-threshold,
        is-verified: false,
        created-at: block-height
      }
    )
    (var-set community-counter community-id)
    (ok community-id)
  )
)

;; Verify community member
(define-public (verify-member (community-id uint) (member principal))
  (let (
    (community (unwrap! (map-get? communities { community-id: community-id }) ERR_COMMUNITY_NOT_FOUND))
    (current-verification (default-to
      { verified-by: (list), verification-count: u0 }
      (map-get? member-verifications { community-id: community-id, member: member })
    ))
  )
    (asserts! (not (is-eq tx-sender member)) ERR_UNAUTHORIZED)
    (let ((updated-verifiers (unwrap! (as-max-len? (append (get verified-by current-verification) tx-sender) u10) ERR_UNAUTHORIZED)))
      (map-set member-verifications
        { community-id: community-id, member: member }
        {
          verified-by: updated-verifiers,
          verification-count: (+ (get verification-count current-verification) u1)
        }
      )
      (ok true)
    )
  )
)

;; Get community info
(define-read-only (get-community (community-id uint))
  (map-get? communities { community-id: community-id })
)

;; Get member verification status
(define-read-only (get-member-verification (community-id uint) (member principal))
  (map-get? member-verifications { community-id: community-id, member: member })
)

;; Check if member is verified
(define-read-only (is-member-verified (community-id uint) (member principal))
  (let (
    (community (unwrap! (map-get? communities { community-id: community-id }) (err false)))
    (verification (default-to
      { verified-by: (list), verification-count: u0 }
      (map-get? member-verifications { community-id: community-id, member: member })
    ))
  )
    (ok (>= (get verification-count verification) (get verification-threshold community)))
  )
)
