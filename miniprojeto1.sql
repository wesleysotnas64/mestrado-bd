-- Miniprojeto 1: Modelagem e Análise de Dados Estruturados
-- Nome: [Seu Nome Completo]
-- Opção escolhida: [C]
-- SGBD utilizado: [PostgreSQL]
-- Data: [29-09-2026]

-- Para deixar o sistema um pouco mais completo, eu adicionei 2 tabelas.
-- Com elas ajuda a ter uma gama maior de CONSULTAS.
-- Tabelas adicionadas: ESPECIALIDADES e DOUTOR_ESPECIALIDADE

-- ===================================
-- 1. CRIAÇÃO DAS TABELAS (DDL)
-- ===================================

-- Armazena o catálogo centralizado de especialidades médicas 
-- para garantir a padronização e evitar textos duplicados no sistema.
CREATE TABLE IF NOT EXISTS specialties (
    specialty_id INT GENERATED ALWAYS AS IDENTITY, -- substitui o SERIAL (id automático) depreciado | Always impede a inserção manual
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (specialty_id)
);

-- Armazena os dados cadastrais e identificação profissional do médico, 
-- servindo de base para o vínculo com suas especialidades e a realização de consultas.
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT GENERATED ALWAYS AS IDENTITY,
    doctor_name VARCHAR(200) NOT NULL, -- Geramente médico tem nome grande
    doctor_license_number VARCHAR(20) NOT NULL UNIQUE, -- Adicionei o CRM (se for no Brasil) do médico 
	PRIMARY KEY (doctor_id)
);

-- Relaciona médicos e suas especialidades (N:N),
-- Um médico só pode exercer especialidades previamente cadastradas.
-- No front-end isso ajuda a selecionar as especialidades que o médico possui, na hora da consulta médica
-- Também ajuna nas consultas de análise de dados dentro do banco
CREATE TABLE IF NOT EXISTS doctor_specialty (
    doctor_id INT NOT NULL,
    specialty_id INT NOT NULL,
    PRIMARY KEY (doctor_id, specialty_id), -- Evita redundância (o mesmo médico com a mesma especialidade 2x)
    FOREIGN KEY (doctor_id) REFERENCES doctors (doctor_id) ON DELETE CASCADE, -- se um médico for deletado, a referência some aqui também. Evita dado "fantasma"
    FOREIGN KEY (specialty_id) REFERENCES specialties (specialty_id) ON DELETE RESTRICT -- bloqueia exclusão de uma especialidade se ainda houver médico com referência
);

-- Armazena as informações cadastrais dos pacientes que realizam consultas no sistema.
-- Mantive como na sugestão do PDF
CREATE TABLE IF NOT EXISTS patients (
    patient_id INT GENERATED ALWAYS AS IDENTITY,
    patient_name VARCHAR(200) NOT NULL,
    patient_birth_date DATE NOT NULL,
    patient_city VARCHAR(100) NOT NULL,
    PRIMARY KEY (patient_id)
);

-- Registra as consultas realizadas, vinculando o paciente ao medico e a especialidade exercida no atendimento.
-- Fiz uma alteração na tabela de consultas
-- Agora deve ser informado qual a especialidade

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT GENERATED ALWAYS AS IDENTITY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    specialty_id INT NOT NULL,
    appointment_date TIMESTAMP NOT NULL,
    appointment_price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (appointment_id),
    FOREIGN KEY (patient_id) REFERENCES patients (patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (doctor_id, specialty_id) REFERENCES doctor_specialty (doctor_id, specialty_id) ON DELETE RESTRICT 	-- Garante que a consulta só seja agendada para uma especialidade que o médico realmente atende
);

-- ===================================
-- 2. INSERÇÃO DOS DADOS (DML)
-- ===================================

-- Inserção de 20 especialidades médicas mais comuns no Brasil
INSERT INTO specialties (specialty_name) VALUES
    ('Cardiologia'),             -- Cuida do coração e do sistema circulatório.
    ('Psiquiatria'),              -- Trata dos transtornos mentais e da saúde comportamental.
    ('Pediatria'),                -- Acompanha o desenvolvimento e a saúde de crianças e adolescentes.
    ('Ginecologia e Obstetrícia'), -- Cuida da saúde da mulher e do acompanhamento da gestação e parto.
    ('Dermatologia'),             -- Trata de doenças da pele, cabelos e unhas.
    ('Ortopedia e Traumatologia'),-- Trata lesões e doenças dos ossos, articulações e músculos.
    ('Clínica Médica'),           -- Atendimento geral a adultos e diagnóstico de diversas patologias.
    ('Oftalmologia'),             -- Diagnostica e trata doenças da visão e dos olhos.
    ('Otorrinolaringologia'),     -- Trata de doenças do ouvido, nariz e garganta.
    ('Neurologia'),               -- Cuida das doenças do sistema nervoso (cérebro e medula).
    ('Endocrinologia'),           -- Trata de distúrbios hormonais e metabólicos (como diabetes e tireoide).
    ('Gastroenterologia'),        -- Cuida do sistema digestivo (estômago, intestino e fígado).
    ('Urologia'),                 -- Trata do sistema urinário e do sistema reprodutor masculino.
    ('Geriatria'),                -- Especializada na prevenção e tratamento da saúde do idoso.
    ('Infectologia'),             -- Trata de doenças causadas por vírus, bactérias, fungos e parasitas.
    ('Pneumologia'),              -- Diagnostica e trata doenças do sistema respiratório e pulmões.
    ('Oncologia Clínica'),        -- Especializada no diagnóstico e tratamento do câncer.
    ('Nefrologia'),               -- Cuida da saúde dos rins e do sistema renal.
    ('Reumatologia'),             -- Trata de doenças inflamatórias nas articulações e tecidos autoimunes.
    ('Medicina de Família');      -- Atendimento contínuo e preventivo focado no indivíduo e na comunidade.

-- Inserção de 20 médicos fictícios com nomes cômicos e trocadilhos médicos
INSERT INTO doctors (doctor_name, doctor_license_number) VALUES
    ('Dr. Gilson Pé de Cabra da Silva', 'CRM-SP 102030'),    -- Especialista em traumas e alavancagens
    ('Dra. Melissa Cabelos Sedosos de Mais', 'CRM-RJ 203040'), -- Vaidosa até na hora do atendimento
    ('Dr. Chico Navalha Afiada', 'CRM-MG 304050'),             -- Precisão cirúrgica impecável
    ('Dra. Fernanda Ferreira da Bigorna', 'CRM-RS 405060'),    -- Tratamento pesado contra dores
    ('Dr. Carlos da Gaze Enrolada', 'CRM-PR 506070'),          -- Curativos que duram dias
    ('Dra. Paula Seringa Perversa', 'CRM-BA 607080'),          -- Mão pesada na hora da vacina
    ('Dr. Mário Martelo de Reflexo', 'CRM-PE 708090'),         -- O terror dos joelhos desavisados
    ('Dra. Beatriz Bico de Papagaio', 'CRM-CE 809010'),        -- Especializada nas próprias dores nas costas
    ('Dr. Roberto Raio-X Invisível', 'CRM-SC 901020'),         -- Enxerga através do paciente só de olhar
    ('Dra. Amanda Agulha Cega', 'CRM-GO 103050'),              -- Tenta achar a veia no feeling
    ('Dr. Zé da Pílula Mágica', 'CRM-PA 204060'),              -- Receita remédio pra tudo
    ('Dra. Valéria Estetoscópio Gelado', 'CRM-MA 305070'),     -- Arrepia o paciente no primeiro contato
    ('Dr. Jorge Junta Trincada', 'CRM-MT 406080'),             -- Ouve estalos a um quilômetro de distância
    ('Dra. Carla Cateter de Aço', 'CRM-MS 507090'),            -- Não erra um acesso nem no escuro
    ('Dr. Sérgio Sorinho Caseiro', 'CRM-PB 608010'),           -- Cura qualquer virose com hidratação
    ('Dra. Tânia Tira-Teima da Pressão', 'CRM-RN 709020'),     -- Mede a pressão três vezes só para ter certeza
    ('Dr. Ruy Bochecha Inchada', 'CRM-AL 801030'),             -- Sempre pronto para uma anestesia
    ('Dra. Helena Hipocrisia de Hipócrates', 'CRM-PI 902040'), -- Segue o juramento só quando é conveniente
    ('Dr. Bruno Bisturi Voador', 'CRM-SE 104060'),             -- Operações na velocidade da luz
    ('Dra. Rita Remédio Amargo', 'CRM-TO 205070');


-- Inserção de vínculos entre médicos e especialidades (N:N)
-- Cada médico (doctor_id de 1 a 20) possui entre 1 e 5 especialidades (specialty_id de 1 a 20).
INSERT INTO doctor_specialty (doctor_id, specialty_id) VALUES
    -- Dr. Gilson Pé de Cabra (ID 1) - Traumatologia e Cirurgia
    (1, 6),   -- Ortopedia e Traumatologia
    (1, 7),   -- Clínica Médica
    
    -- Dra. Melissa Cabelos Sedosos (ID 2) - Estética e Pele
    (2, 5),   -- Dermatologia
    
    -- Dr. Chico Navalha Afiada (ID 3) - Cirurgião e Geral
    (3, 7),   -- Clínica Médica
    (3, 13),  -- Urologia
    (3, 17),  -- Oncologia Clínica
    
    -- Dra. Fernanda Ferreira da Bigorna (ID 4) - Dor e Articulações
    (4, 6),   -- Ortopedia e Traumatologia
    (4, 19),  -- Reumatologia
    (4, 14),  -- Geriatria
    
    -- Dr. Carlos da Gaze Enrolada (ID 5) - Clínico e Infecto
    (5, 7),   -- Clínica Médica
    (5, 15),  -- Infectologia
    
    -- Dra. Paula Seringa Perversa (ID 6) - Crianças e Imunização
    (6, 3),   -- Pediatria
    (6, 20),  -- Medicina de Família
    (6, 15),  -- Infectologia
    (6, 1),   -- Cardiologia
    
    -- Dr. Mário Martelo de Reflexo (ID 7) - Nervos e Articulações
    (7, 10),  -- Neurologia
    (7, 6),   -- Ortopedia e Traumatologia
    
    -- Dra. Beatriz Bico de Papagaio (ID 8) - Idosos e Coluna
    (8, 14),  -- Geriatria
    (8, 19),  -- Reumatologia
    (8, 6),   -- Ortopedia e Traumatologia
    (8, 7),   -- Clínica Médica
    (8, 20),  -- Medicina de Família
    
    -- Dr. Roberto Raio-X Invisível (ID 9) - Diagnóstico e Cabeça
    (9, 10),  -- Neurologia
    (9, 8),   -- Oftalmologia
    
    -- Dra. Amanda Agulha Cega (ID 10) - Clínico Geral
    (10, 7),  -- Clínica Médica
    
    -- Dr. Zé da Pílula Mágica (ID 11) - Saúde Mental e Geral
    (11, 2),  -- Psiquiatria
    (11, 7),  -- Clínica Médica
    (11, 20), -- Medicina de Família
    
    -- Dra. Valéria Estetoscópio Gelado (ID 12) - Coração e Pulmão
    (12, 1),  -- Cardiologia
    (12, 16), -- Pneumologia
    (12, 7),  -- Clínica Médica
    
    -- Dr. Jorge Junta Trincada (ID 13) - Ossos e Músculos
    (13, 6),  -- Ortopedia e Traumatologia
    (13, 19), -- Reumatologia
    
    -- Dra. Carla Cateter de Aço (ID 14) - Rins e Vasos
    (14, 18), -- Nefrologia
    (14, 13), -- Urologia
    (14, 1),  -- Cardiologia
    (14, 7),  -- Clínica Médica
    
    -- Dr. Sérgio Sorinho Caseiro (ID 15) - Família e Crianças
    (15, 20), -- Medicina de Família
    (15, 3),  -- Pediatria
    
    -- Dra. Tânia Tira-Teima da Pressão (ID 16) - Coração e Rins
    (16, 1),  -- Cardiologia
    (16, 18), -- Nefrologia
    (16, 14), -- Geriatria
    (16, 7),  -- Clínica Médica
    
    -- Dr. Ruy Bochecha Inchada (ID 17) - Garganta e Face
    (17, 9),  -- Otorrinolaringologia
    
    -- Dra. Helena Hipocrisia de Hipócrates (ID 18) - Mente e Família
    (18, 2),  -- Psiquiatria
    (18, 20), -- Medicina de Família
    (18, 7),  -- Clínica Médica
    (18, 14), -- Geriatria
    
    -- Dr. Bruno Bisturi Voador (ID 19) - Digestivo e Abdômen
    (19, 12), -- Gastroenterologia
    (19, 13), -- Urologia
    (19, 17), -- Oncologia Clínica
    (19, 7),  -- Clínica Médica
    (19, 1),  -- Cardiologia
    
    -- Dra. Rita Remédio Amargo (ID 20) - Estômago e Pulmão
    (20, 12), -- Gastroenterologia
    (20, 16); -- Pneumologia

-- Inserção de 20 pacientes fictícios com nomes cômicos relacionados a sintomas e problemas de saúde
INSERT INTO patients (patient_name, patient_birth_date, patient_city) VALUES
    ('Danilo Dói Aqui', '1990-05-12', 'São Paulo'),            -- Sente dor, mas nunca sabe explicar onde
    ('Maria Machucada', '1985-11-23', 'Rio de Janeiro'),        -- Frequenta a emergência toda semana
    ('Fernando Febre da Silva', '1998-03-30', 'Belo Horizonte'), -- Vive com o termômetro debaixo do braço
    ('Joana Fratura Exposta', '1979-08-14', 'Curitiba'),        -- Praticante de esportes radicais e desastrada
    ('Claudio Colesterol Alto', '1968-01-05', 'Porto Alegre'),   -- Não abre mão de uma feijoada
    ('Paula Pressão Alta', '1975-09-18', 'Salvador'),           -- Se estressa até com vento caindo
    ('Gerson Gasto do Estômago', '1992-07-07', 'Recife'),       -- Viciado em café e pimenta
    ('Tânia Tontura Constante', '1988-12-01', 'Fortaleza'),     -- Levanta rápido demais e vê estrelas
    ('Renato Rinite Alérgica', '2001-04-22', 'Brasília'),       -- Espirra só de olhar para um tapete
    ('Sônia Soluço Sem Fim', '1995-10-10', 'Goiânia'),          -- Já tentou todos os sustos e simpatias
    ('Vitor Virose de Verão', '2003-02-15', 'Florianópolis'),   -- Todo início de ano pega a mesma virose
    ('Helena Hipocondria Profunda', '1982-06-19', 'Campinas'),   -- Pesquisa os sintomas no Google e acha que tem 3 dias de vida
    ('Bruno Bico de Papagaio', '1965-03-08', 'Manaus'),         -- Reclama da coluna a cada 5 minutos
    ('Carla Cãibra Noturna', '1997-11-04', 'Belém'),            -- Acorda a casa inteira gritando de madrugada
    ('Sérgio Suor Frio', '1980-05-27', 'Vitória'),              -- Entra em pânico só de ver a seringa
    ('Patricia Pele Descascando', '1994-08-31', 'Natal'),       -- Esqueceu de passar protetor solar na praia
    ('Lucas Laringite Aguda', '2000-01-19', 'João Pessoa'),     -- Perde a voz toda vez que vai a um show
    ('Denise Dente Sensível', '1991-09-12', 'Maceió'),          -- Não pode tomar sorvete sem chorar
    ('Marcos Músculo Distendido', '1986-12-25', 'São Luís'),    -- Achou que ainda tinha 18 anos no futebol de domingo
    ('Aline Insônia Pesada', '1993-04-03', 'Teresina');         -- Conta carneirinhos até as 5 da manhã

-- Inserção de 20 consultas médicas fictícias
-- NOTA DE INTEGRIDADE: As combinações (doctor_id, specialty_id) correspondem exatamente 
-- aos vínculos previamente registrados na tabela doctor_specialty.
INSERT INTO appointments (patient_id, doctor_id, specialty_id, appointment_date, appointment_price) VALUES
    -- 1. Danilo Dói Aqui (Patient 1) com Dr. Gilson (Doctor 1) em Ortopedia (Specialty 6)
    (1, 1, 6, '2026-09-01 08:30:00', 250.00),

    -- 2. Maria Machucada (Patient 2) com Dra. Melissa (Doctor 2) em Dermatologia (Specialty 5)
    (2, 2, 5, '2026-09-02 09:15:00', 300.00),

    -- 3. Fernando Febre (Patient 3) com Dr. Chico Navalha (Doctor 3) em Clínica Médica (Specialty 7)
    (3, 3, 7, '2026-09-02 10:00:00', 180.00),

    -- 4. Joana Fratura (Patient 4) com Dra. Fernanda (Doctor 4) em Reumatologia (Specialty 19)
    (4, 4, 19, '2026-09-03 11:30:00', 280.00),

    -- 5. Claudio Colesterol (Patient 5) com Dr. Carlos (Doctor 5) em Infectologia (Specialty 15)
    (5, 5, 15, '2026-09-04 14:00:00', 220.00),

    -- 6. Paula Pressão (Patient 6) com Dra. Paula Seringa (Doctor 6) em Cardiologia (Specialty 1)
    (6, 6, 1, '2026-09-05 15:00:00', 350.00),

    -- 7. Gerson Gasto (Patient 7) com Dr. Mário Martelo (Doctor 7) em Neurologia (Specialty 10)
    (7, 7, 10, '2026-09-08 08:00:00', 310.00),

    -- 8. Tânia Tontura (Patient 8) com Dra. Beatriz (Doctor 8) em Geriatria (Specialty 14)
    (8, 8, 14, '2026-09-08 10:30:00', 260.00),

    -- 9. Renato Rinite (Patient 9) com Dr. Roberto Raio-X (Doctor 9) em Oftalmologia (Specialty 8)
    (9, 9, 8, '2026-09-09 13:30:00', 200.00),

    -- 10. Sônia Soluço (Patient 10) com Dra. Amanda Agulha (Doctor 10) em Clínica Médica (Specialty 7)
    (10, 10, 7, '2026-09-10 09:00:00', 150.00),

    -- 11. Vitor Virose (Patient 11) com Dr. Zé da Pílula (Doctor 11) em Psiquiatria (Specialty 2)
    (11, 11, 2, '2026-09-11 16:00:00', 320.00),

    -- 12. Helena Hipocondria (Patient 12) com Dra. Valéria (Doctor 12) em Pneumologia (Specialty 16)
    (12, 12, 16, '2026-09-14 08:30:00', 270.00),

    -- 13. Bruno Bico de Papagaio (Patient 13) com Dr. Jorge Junta (Doctor 13) em Ortopedia (Specialty 6)
    (13, 13, 6, '2026-09-15 10:00:00', 290.00),

    -- 14. Carla Cãibra (Patient 14) com Dra. Carla Cateter (Doctor 14) em Nefrologia (Specialty 18)
    (14, 14, 18, '2026-09-16 11:00:00', 330.00),

    -- 15. Sérgio Suor Frio (Patient 15) com Dr. Sérgio Sorinho (Doctor 15) em Pediatria (Specialty 3)
    (15, 15, 3, '2026-09-17 14:30:00', 190.00),

    -- 16. Patricia Pele (Patient 16) com Dra. Tânia Tira-Teima (Doctor 16) em Cardiologia (Specialty 1)
    (16, 16, 1, '2026-09-18 15:30:00', 350.00),

    -- 17. Lucas Laringite (Patient 17) com Dr. Ruy Bochecha (Doctor 17) em Otorrinolaringologia (Specialty 9)
    (17, 17, 9, '2026-09-21 09:30:00', 240.00),

    -- 18. Denise Dente (Patient 18) com Dra. Helena Hipocrisia (Doctor 18) em Medicina de Família (Specialty 20)
    (18, 18, 20, '2026-09-22 10:30:00', 160.00),

    -- 19. Marcos Músculo (Patient 19) com Dr. Bruno Bisturi (Doctor 19) em Gastroenterologia (Specialty 12)
    (19, 19, 12, '2026-09-23 13:00:00', 300.00),

    -- 20. Aline Insônia (Patient 20) com Dra. Rita Remédio (Doctor 20) em Pneumologia (Specialty 16)
    (20, 20, 16, '2026-09-24 16:30:00', 280.00);

-- ===================================
-- 3. CONSULTAS ANALÍTICAS (QUERIES)
-- ===================================

-- Consulta geral de cada tabela
SELECT * FROM specialties;
SELECT * FROM doctors;

SELECT * FROM doctor_specialty;
SELECT 
    d.doctor_name,
    d.doctor_license_number,
    s.specialty_name
FROM doctor_specialty ds
JOIN doctors d ON ds.doctor_id = d.doctor_id
JOIN specialties s ON ds.specialty_id = s.specialty_id
ORDER BY d.doctor_name, s.specialty_name;

SELECT * FROM patients;

SELECT * FROM appointments;

SELECT
	a.appointment_id,
	p.patient_name,
	d.doctor_name,
	s.specialty_name,
	a.appointment_price,
	a.appointment_date
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN specialties s ON a.specialty_id = s.specialty_id
ORDER BY a.appointment_date ASC; 

