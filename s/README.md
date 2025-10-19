# JobPortal - Spring Boot

Projeto gerado pelo assistente. Estrutura mínima para rodar um servidor REST com JWT e PostgreSQL.

## Como usar

1. Criar banco:
```sql
CREATE DATABASE TecCS;
CREATE USER jobuser WITH ENCRYPTED PASSWORD 'jobpass';
GRANT ALL PRIVILEGES ON DATABASE jobportal TO jobuser;
```

2. Ajustar `src/main/resources/application.yml`.

3. Rodar:
```
./mvnw spring-boot:run
```

API endpoints: /login, /logout, /users, /companies, /jobs
