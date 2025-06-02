;; Decision Making Protocol Contract
;; Manages collective intelligence governance

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_PROPOSAL_NOT_FOUND (err u201))
(define-constant ERR_VOTING_ENDED (err u202))
(define-constant ERR_ALREADY_VOTED (err u203))
(define-constant ERR_INVALID_VOTE (err u204))

;; Proposal data structure
(define-map proposals
  { proposal-id: uint }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    proposer: principal,
    community-id: uint,
    votes-for: uint,
    votes-against: uint,
    voting-end: uint,
    is-executed: bool,
    created-at: uint
  }
)

;; Vote tracking
(define-map votes
  { proposal-id: uint, voter: principal }
  { vote: bool, weight: uint }
)

;; Proposal counter
(define-data-var proposal-counter uint u0)

;; Create proposal
(define-public (create-proposal
  (title (string-ascii 100))
  (description (string-ascii 500))
  (community-id uint)
  (voting-duration uint)
)
  (let ((proposal-id (+ (var-get proposal-counter) u1)))
    (map-set proposals
      { proposal-id: proposal-id }
      {
        title: title,
        description: description,
        proposer: tx-sender,
        community-id: community-id,
        votes-for: u0,
        votes-against: u0,
        voting-end: (+ block-height voting-duration),
        is-executed: false,
        created-at: block-height
      }
    )
    (var-set proposal-counter proposal-id)
    (ok proposal-id)
  )
)

;; Cast vote
(define-public (cast-vote (proposal-id uint) (vote bool) (weight uint))
  (let (
    (proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) ERR_PROPOSAL_NOT_FOUND))
    (existing-vote (map-get? votes { proposal-id: proposal-id, voter: tx-sender }))
  )
    (asserts! (is-none existing-vote) ERR_ALREADY_VOTED)
    (asserts! (< block-height (get voting-end proposal)) ERR_VOTING_ENDED)
    (asserts! (> weight u0) ERR_INVALID_VOTE)

    (map-set votes
      { proposal-id: proposal-id, voter: tx-sender }
      { vote: vote, weight: weight }
    )

    (if vote
      (map-set proposals
        { proposal-id: proposal-id }
        (merge proposal { votes-for: (+ (get votes-for proposal) weight) })
      )
      (map-set proposals
        { proposal-id: proposal-id }
        (merge proposal { votes-against: (+ (get votes-against proposal) weight) })
      )
    )
    (ok true)
  )
)

;; Execute proposal
(define-public (execute-proposal (proposal-id uint))
  (let ((proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) ERR_PROPOSAL_NOT_FOUND)))
    (asserts! (>= block-height (get voting-end proposal)) ERR_VOTING_ENDED)
    (asserts! (not (get is-executed proposal)) ERR_UNAUTHORIZED)
    (asserts! (> (get votes-for proposal) (get votes-against proposal)) ERR_UNAUTHORIZED)

    (map-set proposals
      { proposal-id: proposal-id }
      (merge proposal { is-executed: true })
    )
    (ok true)
  )
)

;; Get proposal info
(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals { proposal-id: proposal-id })
)

;; Get vote info
(define-read-only (get-vote (proposal-id uint) (voter principal))
  (map-get? votes { proposal-id: proposal-id, voter: voter })
)

;; Check if proposal passed
(define-read-only (proposal-passed (proposal-id uint))
  (let ((proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) (err false))))
    (ok (> (get votes-for proposal) (get votes-against proposal)))
  )
)
