# 🧩 Transacciones en MySQL --- Resumen Completo

## ¿Qué es una transacción?

Una transacción es un conjunto de operaciones SQL que se ejecutan como
si fueran una sola. - Si todo va bien → **COMMIT** (guardar cambios) -
Si algo falla → **ROLLBACK** (deshacer todo) - No es automático: **tú
decides** cuándo confirmar o revertir.

------------------------------------------------------------------------

# 🔧 Comandos básicos

``` sql
START TRANSACTION;   -- Inicia una transacción
COMMIT;              -- Confirma todos los cambios
ROLLBACK;            -- Revierte todos los cambios
```

------------------------------------------------------------------------

# 🧪 Ejemplo 1 --- Transferencia de dinero (seguro)

``` sql
START TRANSACTION;

UPDATE cuentas
SET saldo = saldo - 20
WHERE id = 1;

UPDATE cuentas
SET saldo = saldo + 20
WHERE id = 2;

COMMIT;
-- ROLLBACK;
```

------------------------------------------------------------------------

# 🧪 Ejemplo 2 --- Crear un pedido y sus productos

``` sql
START TRANSACTION;

INSERT INTO orders (customer_id, total)
VALUES (12, 59.90);

SET @order_id = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (@order_id, 4, 1);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (@order_id, 9, 2);

COMMIT;
```

------------------------------------------------------------------------

# 🧪 Ejemplo 3 --- Evitar doble reserva (FOR UPDATE)

``` sql
START TRANSACTION;

SELECT *
FROM asientos
WHERE id = 5
FOR UPDATE;

UPDATE asientos
SET ocupado = 1
WHERE id = 5;

COMMIT;
```

------------------------------------------------------------------------

# 🧑‍💻 Ejemplo en Python con try/except (gestión automática de commit/rollback)

``` python
import mysql.connector

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="tu_password",
    database="test"
)

cursor = conn.cursor()

try:
    conn.start_transaction()

    cursor.execute("UPDATE cuentas SET saldo = saldo - 20 WHERE id = 1")
    cursor.execute("UPDATE cuentas SET saldo = saldo + 20 WHERE id = 2")

    conn.commit()
    print("Transacción completada con éxito")

except Exception as e:
    conn.rollback()
    print("Error, se hizo rollback:", e)
```

### 📌 Notas del ejemplo en Python

-   `conn.start_transaction()` inicia la transacción manualmente.
-   Si una línea dentro del `try` falla → `except` activa `rollback()`.
-   Si todo va bien → `commit()`.
-   Muy usado en aplicaciones reales.

------------------------------------------------------------------------

# 🧠 Regla general

Usa transacciones siempre que varias operaciones: - dependan entre sí, -
no puedan quedar a medias, - afecten a varias tablas relacionadas, -
necesiten evitar inconsistencias.
