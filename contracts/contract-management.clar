;; Contract Management Contract
;; Manages vendor contracts and agreements

(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_NOT_FOUND (err u301))
(define-constant ERR_INVALID_STATUS (err u302))

;; Data structures
(define-map contracts
  { contract-id: uint }
  {
    vendor-id: uint,
    title: (string-ascii 200),
    description: (string-ascii 1000),
    value: uint,
    start-date: uint,
    end-date: uint,
    status: (string-ascii 20),
    created-by: principal,
    created-at: uint
  }
)

(define-map contract-milestones
  { milestone-id: uint }
  {
    contract-id: uint,
    description: (string-ascii 500),
    due-date: uint,
    completed: bool,
    completion-date: (optional uint)
  }
)

(define-data-var next-contract-id uint u1)
(define-data-var next-milestone-id uint u1)

;; Public functions
(define-public (create-contract
  (vendor-id uint)
  (title (string-ascii 200))
  (description (string-ascii 1000))
  (value uint)
  (start-date uint)
  (end-date uint)
)
  (let ((contract-id (var-get next-contract-id)))
    (map-set contracts
      { contract-id: contract-id }
      {
        vendor-id: vendor-id,
        title: title,
        description: description,
        value: value,
        start-date: start-date,
        end-date: end-date,
        status: "draft",
        created-by: tx-sender,
        created-at: block-height
      }
    )

    (var-set next-contract-id (+ contract-id u1))
    (ok contract-id)
  )
)

(define-public (update-contract-status (contract-id uint) (new-status (string-ascii 20)))
  (let ((contract (unwrap! (map-get? contracts { contract-id: contract-id }) ERR_NOT_FOUND)))
    (asserts! (is-eq tx-sender (get created-by contract)) ERR_UNAUTHORIZED)

    (map-set contracts
      { contract-id: contract-id }
      (merge contract { status: new-status })
    )
    (ok true)
  )
)

(define-public (add-milestone
  (contract-id uint)
  (description (string-ascii 500))
  (due-date uint)
)
  (let (
    (milestone-id (var-get next-milestone-id))
    (contract (unwrap! (map-get? contracts { contract-id: contract-id }) ERR_NOT_FOUND))
  )
    (asserts! (is-eq tx-sender (get created-by contract)) ERR_UNAUTHORIZED)

    (map-set contract-milestones
      { milestone-id: milestone-id }
      {
        contract-id: contract-id,
        description: description,
        due-date: due-date,
        completed: false,
        completion-date: none
      }
    )

    (var-set next-milestone-id (+ milestone-id u1))
    (ok milestone-id)
  )
)

(define-public (complete-milestone (milestone-id uint))
  (let ((milestone (unwrap! (map-get? contract-milestones { milestone-id: milestone-id }) ERR_NOT_FOUND)))
    (map-set contract-milestones
      { milestone-id: milestone-id }
      (merge milestone {
        completed: true,
        completion-date: (some block-height)
      })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-contract (contract-id uint))
  (map-get? contracts { contract-id: contract-id })
)

(define-read-only (get-milestone (milestone-id uint))
  (map-get? contract-milestones { milestone-id: milestone-id })
)
