#!/bin/bash
echo "Criando o banco e populando as tabelas"
date
mysql -uhuxley -p -Dhuxley-prod < data.sql
date
echo "Executando a migracao"
mysql -uhuxley -p -Dhuxley-prod < migration.sql
date
echo "Fim"
