# 🧩 Concurrencia en Bases de Datos — Resumen Completo

## ¿Qué es la concurrencia?
La concurrencia permite que varios usuarios o procesos accedan y modifiquen la base de datos al mismo tiempo.
- Sin control adecuado, pueden ocurrir inconsistencias o errores.

---

## 1️⃣ Problemas típicos

1. **Lectura sucia (Dirty Read)**: Leer datos no confirmados por otra transacción.
2. **Lectura no repetible (Non-Repeatable Read)**: Leer un dato, otro lo cambia y luego lees de nuevo y es diferente.
3. **Fantasmas (Phantom Reads)**: Consultas que muestran nuevas filas añadidas por otra transacción.
4. **Pérdida de actualización (Lost Update)**: Dos procesos modifican el mismo dato y uno sobrescribe al otro.

---

## 2️⃣ Cómo se controla

### 🔹 Bloqueos (Locks)
- **Fila o tabla** bloqueada hasta que la transacción haga commit o rollback.
- Tipos:
  - **Shared Lock (S)**: lectura permitida, no modificar.
  - **Exclusive Lock (X)**: solo quien bloquea puede modificar.

Ejemplo en MySQL:
```sql
SELECT * FROM cuentas WHERE id = 1 FOR UPDATE;
```
Bloquea la fila hasta que hagas **COMMIT** o **ROLLBACK**.

### 🔹 Niveles de aislamiento (Isolation Levels)
| Nivel | Qué permite ver | Problemas posibles |
|-------|----------------|------------------|
| READ UNCOMMITTED | Todo, incluso sin commit | Dirty Reads |
| READ COMMITTED | Solo datos confirmados | Non-Repeatable Reads |
| REPEATABLE READ | Datos vistos al inicio | Phantom Reads |
| SERIALIZABLE | Como si fueran secuenciales | Evita todos los problemas, más lento |

> MySQL por defecto usa **REPEATABLE READ**.

### 🔹 MVCC (Multi-Version Concurrency Control)
- Las lecturas no bloquean escrituras normales.
- Cada transacción ve una versión consistente de los datos al inicio.
- Permite alta concurrencia sin perder consistencia.

---

## 3️⃣ Resumen sencillo

- La concurrencia permite que varios usuarios trabajen al mismo tiempo.
- Riesgos: dirty reads, lost updates, etc.
- Soluciones: **bloqueos**, **niveles de aislamiento**, **MVCC**.
- Las transacciones con **COMMIT/ROLLBACK** son la base para mantener la consistencia.


# 📌 Recomendación práctica
Usa transacciones y niveles de aislamiento adecuados para:
- Evitar inconsistencias.
- Prevenir pérdida de datos.
- Mantener la integridad de la base de datos en sistemas concurrentes.

