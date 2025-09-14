atribut-atribut dari tabel Pemesanan, Order Item, dan Pembayaran

- Pemesanan:
    - id [PK]
    - status
    - created_at
    - order_number
    - status
    - total
    - subtotal
    - note
    - updated_at
    - user_id [FK]
    - merchant_id [FK]
    - alamat_id [FK]

- Order Item:
    - id [PK]
    - created_at
    - nama_product
    - harga_product
    - jumlah
    - subtotal
    - product_id [FK]
    - order_id [FK]

- Pembayaran:
    - id [PK]
    - created_at
    - paid_ammount
    - method
    - status
    - provider_ref
    - paid_at
    - order_id [FK]