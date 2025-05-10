- subir infra com terraform plan e aplpy
- criar base no cloudsql
- CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome_completo VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    endereco TEXT NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
- gcloud compute ssh --zone "us-central1-a" "vm-web" --tunnel-through-iap --project "protech-sandbox"