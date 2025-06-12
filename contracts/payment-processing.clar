;; Payment Processing Contract
;; Handles vendor payments and invoicing

(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_NOT_FOUND (err u401))
(define-constant ERR_INSUFFICIENT_FUNDS (err u402))
(define-constant ERR_ALREADY_PAID (err u403))

;; Data structures
(define-map invoices
  { invoice-id: uint }
  {
    vendor-id: uint,
    contract-id: uint,
    amount: uint,
    description: (string-ascii 500),
    status: (string-ascii 20),
    due-date: uint,
    created-by: principal,
    created-at: uint
  }
)

(define-map payments
  { payment-id: uint }
  {
    invoice-id: uint,
    amount: uint,
    paid-by: principal,
    paid-at: uint,
    transaction-hash: (string-ascii 64)
  }
)

(define-data-var next-invoice-id uint u1)
(define-data-var next-payment-id uint u1)

;; Public functions
(define-public (create-invoice
  (vendor-id uint)
  (contract-id uint)
  (amount uint)
  (description (string-ascii 500))
  (due-date uint)
)
  (let ((invoice-id (var-get next-invoice-id)))
    (map-set invoices
      { invoice-id: invoice-id }
      {
        vendor-id: vendor-id,
        contract-id: contract-id,
        amount: amount,
        description: description,
        status: "pending",
        due-date: due-date,
        created-by: tx-sender,
        created-at: block-height
      }
    )

    (var-set next-invoice-id (+ invoice-id u1))
    (ok invoice-id)
  )
)

(define-public (process-payment (invoice-id uint) (transaction-hash (string-ascii 64)))
  (let (
    (invoice (unwrap! (map-get? invoices { invoice-id: invoice-id }) ERR_NOT_FOUND))
    (payment-id (var-get next-payment-id))
  )
    (asserts! (is-eq (get status invoice) "pending") ERR_ALREADY_PAID)

    ;; Create payment record
    (map-set payments
      { payment-id: payment-id }
      {
        invoice-id: invoice-id,
        amount: (get amount invoice),
        paid-by: tx-sender,
        paid-at: block-height,
        transaction-hash: transaction-hash
      }
    )

    ;; Update invoice status
    (map-set invoices
      { invoice-id: invoice-id }
      (merge invoice { status: "paid" })
    )

    (var-set next-payment-id (+ payment-id u1))
    (ok payment-id)
  )
)

(define-public (approve-invoice (invoice-id uint))
  (let ((invoice (unwrap! (map-get? invoices { invoice-id: invoice-id }) ERR_NOT_FOUND)))
    (map-set invoices
      { invoice-id: invoice-id }
      (merge invoice { status: "approved" })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-invoice (invoice-id uint))
  (map-get? invoices { invoice-id: invoice-id })
)

(define-read-only (get-payment (payment-id uint))
  (map-get? payments { payment-id: payment-id })
)

(define-read-only (get-vendor-total-payments (vendor-id uint))
  ;; This would require iteration in a real implementation
  ;; For simplicity, returning a placeholder
  (ok u0)
)
