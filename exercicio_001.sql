CREATE TABLE Livros (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    ano_publicacao INT,
    genero VARCHAR(50)
);

SELECT * FROM Livros;

-- 1. Limpa os registros existentes e reseta o contador do ID SERIAL
TRUNCATE TABLE Livros RESTART IDENTITY;

-- 2. Povoa a tabela com uma lista ampliada e diversificada de títulos
INSERT INTO Livros (titulo, autor, ano_publicacao, genero) VALUES
-- J.R.R. Tolkien
('A Sociedade do Anel', 'J.R.R. Tolkien', 1954, 'Fantasia'),
('As Duas Torres', 'J.R.R. Tolkien', 1954, 'Fantasia'),
('O Retorno do Rei', 'J.R.R. Tolkien', 1955, 'Fantasia'),
('O Hobbit', 'J.R.R. Tolkien', 1937, 'Fantasia'),
('O Silmarillion', 'J.R.R. Tolkien', 1977, 'Fantasia'),
('Contos Inacabados', 'J.R.R. Tolkien', 1980, 'Fantasia'),

-- C.S. Lewis (As Crônicas de Nárnia)
('O Sobrinho do Mago', 'C.S. Lewis', 1955, 'Fantasia'),
('O Leão, a Feiticeira e o Guarda-Roupa', 'C.S. Lewis', 1950, 'Fantasia'),
('O Cavalo e seu Menino', 'C.S. Lewis', 1954, 'Fantasia'),
('Príncipe Caspian', 'C.S. Lewis', 1951, 'Fantasia'),
('A Viagem do Peregrino da Alvorada', 'C.S. Lewis', 1952, 'Fantasia'),
('A Cadeira de Prata', 'C.S. Lewis', 1953, 'Fantasia'),
('A Última Batalha', 'C.S. Lewis', 1956, 'Fantasia'),

-- George R.R. Martin (As Crônicas de Gelo e Fogo)
('A Guerra dos Tronos', 'George R.R. Martin', 1996, 'Fantasia'),
('A Fúria dos Reis', 'George R.R. Martin', 1998, 'Fantasia'),
('A Tormenta de Espadas', 'George R.R. Martin', 2000, 'Fantasia'),

-- Filosofia, Estratégia e Clássicos
('A Arte da Guerra', 'Sun Tzu', -500, 'Estratégia'),
('O Livro dos Cinco Anéis', 'Miyamoto Musashi', 1645, 'Estratégia'),
('Walden ou A Vida nos Bosques', 'Henry David Thoreau', 1854, 'Filosofia'),

-- Literatura Brasileira
('O Quinze', 'Rachel de Queiroz', 1930, 'Romance'),
('Vidas Secas', 'Graciliano Ramos', 1938, 'Romance'),
('Dom Casmurro', 'Machado de Assis', 1899, 'Romance'),
('Grande Sertão: Veredas', 'João Guimarães Rosa', 1956, 'Romance'),
('A Hora da Estrela', 'Clarice Lispector', 1977, 'Romance'),

-- Dystopia / Ficção Científica
('1984', 'George Orwell', 1949, 'Ficção Científica'),
('A Revolução dos Bichos', 'George Orwell', 1945, 'Sátira Política');

-- Consulta 1: Listar todos os livros e todas as suas informações.
SELECT * FROM Livros;

-- Consulta 2: Encontrar o título e o ano de publicação dos livros de George Orwell.
SELECT titulo, ano_publicacao FROM Livros WHERE autor = 'George Orwell';

-- Consulta 3: Listar o título e o autor dos livros publicados após 1950.
SELECT titulo, autor, ano_publicacao FROM Livros WHERE ano_publicacao > 1950;

-- Verificar o número total de livros cadastrados
SELECT COUNT(*) AS total_livros FROM Livros;

-- Listar apenas os livros de Fantasia ordenados pelo ano de publicação
SELECT titulo, autor, ano_publicacao 
FROM Livros 
WHERE genero = 'Fantasia' 
ORDER BY ano_publicacao ASC;

-- Listar apenas os livros de Fantasia ordenados pelo titulo
SELECT titulo, autor, ano_publicacao 
FROM Livros 
WHERE genero = 'Fantasia' 
ORDER BY titulo ASC;

-- Listando apenas os autores
SELECT autor 
FROM Livros
GROUP BY autor
ORDER BY autor ASC;

-- Listando autores e a quantidade de obras
SELECT autor, COUNT(*) AS quantidade_livros
FROM Livros
GROUP BY autor
ORDER BY quantidade_livros DESC;





