-- MySQL Script generated by MySQL Workbench
-- qui 26 ago 2021 23:36:35
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `CalendarioAcademico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CalendarioAcademico` ;

CREATE TABLE IF NOT EXISTS `CalendarioAcademico` (
  `Ano` INT NOT NULL,
  `Semestre` INT NOT NULL,
  `Inicio` DATE NOT NULL,
  `Fim` DATE NOT NULL,
  PRIMARY KEY (`Ano`, `Semestre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aluno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aluno` ;

CREATE TABLE IF NOT EXISTS `Aluno` (
  `Matricula` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Sobrenome` VARCHAR(45) NOT NULL,
  `DataNascimento` DATE NOT NULL,
  PRIMARY KEY (`Matricula`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Equipamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Equipamento` ;

CREATE TABLE IF NOT EXISTS `Equipamento` (
  `Patrimonio` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Patrimonio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Atividade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Atividade` ;

CREATE TABLE IF NOT EXISTS `Atividade` (
  `idAtividade` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAtividade`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Componentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Componentes` ;

CREATE TABLE IF NOT EXISTS `Componentes` (
  `idComponentes` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idComponentes`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Emprestimo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Emprestimo` ;

CREATE TABLE IF NOT EXISTS `Emprestimo` (
  `idEmprestimo` INT NOT NULL AUTO_INCREMENT,
  `Matricula` INT NOT NULL,
  `idAtividade` INT NOT NULL,
  `DataEmprestimo` DATE NOT NULL,
  `DataPrevisaoEntrega` DATE NOT NULL,
  `DataDevolucao` DATE NULL,
  `QuantidadeRenovacao` INT NULL,
  PRIMARY KEY (`idEmprestimo`, `Matricula`),
  INDEX `fk_Aluno_has_Equipamento_Aluno1_idx` (`Matricula` ASC) VISIBLE,
  INDEX `fk_Emprestimo_Atividade1_idx` (`idAtividade` ASC) VISIBLE,
  CONSTRAINT `fk_Aluno_has_Equipamento_Aluno1`
    FOREIGN KEY (`Matricula`)
    REFERENCES `Aluno` (`Matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Emprestimo_Atividade1`
    FOREIGN KEY (`idAtividade`)
    REFERENCES `Atividade` (`idAtividade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aluno_Atividade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aluno_Atividade` ;

CREATE TABLE IF NOT EXISTS `Aluno_Atividade` (
  `Matricula` INT NOT NULL,
  `idAtividade` INT NOT NULL,
  PRIMARY KEY (`Matricula`, `idAtividade`),
  INDEX `fk_Aluno_has_Atividade_Atividade1_idx` (`idAtividade` ASC) VISIBLE,
  INDEX `fk_Aluno_has_Atividade_Aluno1_idx` (`Matricula` ASC) VISIBLE,
  CONSTRAINT `fk_Aluno_has_Atividade_Aluno1`
    FOREIGN KEY (`Matricula`)
    REFERENCES `Aluno` (`Matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Aluno_has_Atividade_Atividade1`
    FOREIGN KEY (`idAtividade`)
    REFERENCES `Atividade` (`idAtividade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Componentes_Equipamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Componentes_Equipamento` ;

CREATE TABLE IF NOT EXISTS `Componentes_Equipamento` (
  `idComponentes` INT NOT NULL,
  `Patrimonio` INT NOT NULL,
  PRIMARY KEY (`idComponentes`, `Patrimonio`),
  INDEX `fk_Componentes_has_Equipamento_Equipamento1_idx` (`Patrimonio` ASC) VISIBLE,
  INDEX `fk_Componentes_has_Equipamento_Componentes1_idx` (`idComponentes` ASC) VISIBLE,
  CONSTRAINT `fk_Componentes_has_Equipamento_Componentes1`
    FOREIGN KEY (`idComponentes`)
    REFERENCES `Componentes` (`idComponentes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Componentes_has_Equipamento_Equipamento1`
    FOREIGN KEY (`Patrimonio`)
    REFERENCES `Equipamento` (`Patrimonio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Status` ;

CREATE TABLE IF NOT EXISTS `Status` (
  `Ano` INT NOT NULL,
  `Semestre` INT NOT NULL,
  `Matricula` INT NOT NULL,
  `Situação` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Ano`, `Semestre`, `Matricula`),
  INDEX `fk_CalendarioAcademico_has_Aluno_Aluno1_idx` (`Matricula` ASC) VISIBLE,
  INDEX `fk_CalendarioAcademico_has_Aluno_CalendarioAcademico1_idx` (`Ano` ASC, `Semestre` ASC) VISIBLE,
  CONSTRAINT `fk_CalendarioAcademico_has_Aluno_CalendarioAcademico1`
    FOREIGN KEY (`Ano` , `Semestre`)
    REFERENCES `CalendarioAcademico` (`Ano` , `Semestre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CalendarioAcademico_has_Aluno_Aluno1`
    FOREIGN KEY (`Matricula`)
    REFERENCES `Aluno` (`Matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Emprestimo_Equipamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Emprestimo_Equipamento` ;

CREATE TABLE IF NOT EXISTS `Emprestimo_Equipamento` (
  `idEmprestimo` INT NOT NULL,
  `Matricula` INT NOT NULL,
  `Patrimonio` INT NOT NULL,
  PRIMARY KEY (`idEmprestimo`, `Matricula`, `Patrimonio`),
  INDEX `fk_Emprestimo_has_Equipamento_Equipamento1_idx` (`Patrimonio` ASC) VISIBLE,
  INDEX `fk_Emprestimo_has_Equipamento_Emprestimo1_idx` (`idEmprestimo` ASC, `Matricula` ASC) VISIBLE,
  CONSTRAINT `fk_Emprestimo_has_Equipamento_Emprestimo1`
    FOREIGN KEY (`idEmprestimo` , `Matricula`)
    REFERENCES `Emprestimo` (`idEmprestimo` , `Matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Emprestimo_has_Equipamento_Equipamento1`
    FOREIGN KEY (`Patrimonio`)
    REFERENCES `Equipamento` (`Patrimonio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Data for table `CalendarioAcademico`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `CalendarioAcademico` (`Ano`, `Semestre`, `Inicio`, `Fim`) VALUES (2020, 1, '2020-02-11', '2020-06-13');
INSERT INTO `CalendarioAcademico` (`Ano`, `Semestre`, `Inicio`, `Fim`) VALUES (2020, 2, '2020-07-07', '2020-12-19');
INSERT INTO `CalendarioAcademico` (`Ano`, `Semestre`, `Inicio`, `Fim`) VALUES (2021, 1, '2021-05-10', '2021-09-15');
INSERT INTO `CalendarioAcademico` (`Ano`, `Semestre`, `Inicio`, `Fim`) VALUES (2021, 2, '2021-10-06', '2021-12-23');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Aluno`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `Aluno` (`Matricula`, `Nome`, `Sobrenome`, `DataNascimento`) VALUES (201810015, 'Rafael', 'Santos', '1990-12-12');
INSERT INTO `Aluno` (`Matricula`, `Nome`, `Sobrenome`, `DataNascimento`) VALUES (201610002, 'Pietro', 'Alves', '1993-06-15');
INSERT INTO `Aluno` (`Matricula`, `Nome`, `Sobrenome`, `DataNascimento`) VALUES (201920020, 'Joana', 'Costa', '1998-03-01');
INSERT INTO `Aluno` (`Matricula`, `Nome`, `Sobrenome`, `DataNascimento`) VALUES (202020080, 'Tony', 'Stark', '1994-05-29');
INSERT INTO `Aluno` (`Matricula`, `Nome`, `Sobrenome`, `DataNascimento`) VALUES (202010060, 'Bianca', 'Lopes', '1999-05-21');
INSERT INTO `Aluno` (`Matricula`, `Nome`, `Sobrenome`, `DataNascimento`) VALUES (201910016, 'Caio', 'Santana', '1998-06-05');
INSERT INTO `Aluno` (`Matricula`, `Nome`, `Sobrenome`, `DataNascimento`) VALUES (201820018, 'Rebeca', 'Vieira', '2000-09-16');
INSERT INTO `Aluno` (`Matricula`, `Nome`, `Sobrenome`, `DataNascimento`) VALUES (201820014, 'Maya', 'Savelli', '1999-02-03');
INSERT INTO `Aluno` (`Matricula`, `Nome`, `Sobrenome`, `DataNascimento`) VALUES (201910039, 'Peter', 'Parker', '1996-08-10');
INSERT INTO `Aluno` (`Matricula`, `Nome`, `Sobrenome`, `DataNascimento`) VALUES (201920999, 'Nicole', 'Medina', '1998-11-13');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Equipamento`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (2511, 'Papilio One 250K FPGA');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (2512, 'Kit Basic Arduino');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (2513, 'Kit Arduino Advanced');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (2514, 'Mini Kit Arduino');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (2515, 'Kit Raspberry Pi Basic');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (2516, 'Kit Raspberry Pi Mega');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (2517, 'Placa FPGA Altera Cyclone II EP2C5T144');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (2518, 'Lego Mindstorms Education');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (2519, 'Kit Raspberry Pi Basic');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (2520, 'Kit Basic Arduino');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (3001, 'Ferro de Solda');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (3002, 'Fenolite');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (3003, 'Alicate');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (3004, 'Cabo de Rede');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (3005, 'Cabo HDMI');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (3006, 'Cabo USB');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (3007, 'Mouse ');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (3008, 'Teclado');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (3009, 'Estanho');
INSERT INTO `Equipamento` (`Patrimonio`, `Nome`) VALUES (3010, 'Chave fenda ');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Atividade`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `Atividade` (`idAtividade`, `Nome`) VALUES (1, 'Atividade de ensino');
INSERT INTO `Atividade` (`idAtividade`, `Nome`) VALUES (2, 'Projetos de pesquisa');
INSERT INTO `Atividade` (`idAtividade`, `Nome`) VALUES (3, 'Projetos de extensão ');
INSERT INTO `Atividade` (`idAtividade`, `Nome`) VALUES (4, 'Trabalho de conclusão de curso');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Componentes`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (1, 'Cabo HDMI');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (2, 'Cartão de Memória 16GB MicroSd');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (4, 'Dissipador de Calor Autoadesivo ');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (5, 'Cristal 16Mhz');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (6, 'Chave Táctil Push-Button');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (7, 'Resistor 10K');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (8, 'Capacitor 22pF');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (9, 'Cabo USB');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (10, 'Fonte');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (11, 'Protoboard 830 Pontos');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (12, 'Sensor de Luz LDR');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (13, 'Sensor de Temperatura NTC');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (14, 'LED Vermelho');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (15, 'LED Verde');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (16, 'LED RGB');
INSERT INTO `Componentes` (`idComponentes`, `Nome`) VALUES (17, 'Motor de Passo 5v');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Emprestimo`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `Emprestimo` (`idEmprestimo`, `Matricula`, `idAtividade`, `DataEmprestimo`, `DataPrevisaoEntrega`, `DataDevolucao`, `QuantidadeRenovacao`) VALUES (1, 201610002, 1, '2021-05-11', '2021-05-26', '2021-05-24', NULL);
INSERT INTO `Emprestimo` (`idEmprestimo`, `Matricula`, `idAtividade`, `DataEmprestimo`, `DataPrevisaoEntrega`, `DataDevolucao`, `QuantidadeRenovacao`) VALUES (2, 201920020, 1, '2021-06-07', '2021-06-22', '2021-06-22', NULL);
INSERT INTO `Emprestimo` (`idEmprestimo`, `Matricula`, `idAtividade`, `DataEmprestimo`, `DataPrevisaoEntrega`, `DataDevolucao`, `QuantidadeRenovacao`) VALUES (3, 202020080, 1, '2021-06-23', '2021-07-08', '2021-07-08', NULL);
INSERT INTO `Emprestimo` (`idEmprestimo`, `Matricula`, `idAtividade`, `DataEmprestimo`, `DataPrevisaoEntrega`, `DataDevolucao`, `QuantidadeRenovacao`) VALUES (4, 202010060, 1, '2021-07-15', '2021-07-30', '2021-07-29', NULL);
INSERT INTO `Emprestimo` (`idEmprestimo`, `Matricula`, `idAtividade`, `DataEmprestimo`, `DataPrevisaoEntrega`, `DataDevolucao`, `QuantidadeRenovacao`) VALUES (5, 201810015, 1, '2021-08-02', '2021-08-17', NULL, NULL);
INSERT INTO `Emprestimo` (`idEmprestimo`, `Matricula`, `idAtividade`, `DataEmprestimo`, `DataPrevisaoEntrega`, `DataDevolucao`, `QuantidadeRenovacao`) VALUES (6, 201910016, 1, '2021-08-17', '2021-09-01', NULL, NULL);
INSERT INTO `Emprestimo` (`idEmprestimo`, `Matricula`, `idAtividade`, `DataEmprestimo`, `DataPrevisaoEntrega`, `DataDevolucao`, `QuantidadeRenovacao`) VALUES (7, 201610002, 4, '2021-05-12', '2021-09-15', NULL, NULL);
INSERT INTO `Emprestimo` (`idEmprestimo`, `Matricula`, `idAtividade`, `DataEmprestimo`, `DataPrevisaoEntrega`, `DataDevolucao`, `QuantidadeRenovacao`) VALUES (8, 201820018, 2, '2021-06-09', '2021-09-15', NULL, NULL);
INSERT INTO `Emprestimo` (`idEmprestimo`, `Matricula`, `idAtividade`, `DataEmprestimo`, `DataPrevisaoEntrega`, `DataDevolucao`, `QuantidadeRenovacao`) VALUES (9, 201820014, 3, '2021-07-13', '2021-09-15', NULL, NULL);
INSERT INTO `Emprestimo` (`idEmprestimo`, `Matricula`, `idAtividade`, `DataEmprestimo`, `DataPrevisaoEntrega`, `DataDevolucao`, `QuantidadeRenovacao`) VALUES (10, 201910039, 1, '2021-08-18', '2021-09-02', NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `Aluno_Atividade`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `Aluno_Atividade` (`Matricula`, `idAtividade`) VALUES (201810015, 1);
INSERT INTO `Aluno_Atividade` (`Matricula`, `idAtividade`) VALUES (201610002, 4);
INSERT INTO `Aluno_Atividade` (`Matricula`, `idAtividade`) VALUES (201920020, 2);
INSERT INTO `Aluno_Atividade` (`Matricula`, `idAtividade`) VALUES (202020080, 3);
INSERT INTO `Aluno_Atividade` (`Matricula`, `idAtividade`) VALUES (202010060, 1);
INSERT INTO `Aluno_Atividade` (`Matricula`, `idAtividade`) VALUES (201910016, 2);
INSERT INTO `Aluno_Atividade` (`Matricula`, `idAtividade`) VALUES (201820018, 3);
INSERT INTO `Aluno_Atividade` (`Matricula`, `idAtividade`) VALUES (201910039, 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `Componentes_Equipamento`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (1, 2516);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (2, 2516);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (10, 2516);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (4, 2516);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (10, 2515);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (4, 2515);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (5, 2514);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (6, 2514);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (7, 2514);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (8, 2514);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (9, 2513);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (10, 2513);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (11, 2513);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (12, 2513);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (13, 2513);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (14, 2513);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (15, 2513);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (16, 2513);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (17, 2513);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (9, 2512);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (10, 2512);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (10, 2517);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (10, 2511);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (9, 2511);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (9, 2520);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (10, 2520);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (4, 2519);
INSERT INTO `Componentes_Equipamento` (`idComponentes`, `Patrimonio`) VALUES (10, 2519);

COMMIT;


-- -----------------------------------------------------
-- Data for table `Status`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `Status` (`Ano`, `Semestre`, `Matricula`, `Situação`) VALUES (2021, 1, 201810015, 'Cursando');
INSERT INTO `Status` (`Ano`, `Semestre`, `Matricula`, `Situação`) VALUES (2021, 1, 201610002, 'Cursando');
INSERT INTO `Status` (`Ano`, `Semestre`, `Matricula`, `Situação`) VALUES (2021, 1, 201920020, 'Cursando');
INSERT INTO `Status` (`Ano`, `Semestre`, `Matricula`, `Situação`) VALUES (2021, 1, 202020080, 'Cursando');
INSERT INTO `Status` (`Ano`, `Semestre`, `Matricula`, `Situação`) VALUES (2021, 1, 202010060, 'Cursando');
INSERT INTO `Status` (`Ano`, `Semestre`, `Matricula`, `Situação`) VALUES (2021, 1, 201910016, 'Cursando');
INSERT INTO `Status` (`Ano`, `Semestre`, `Matricula`, `Situação`) VALUES (2021, 1, 201820018, 'Cursando');
INSERT INTO `Status` (`Ano`, `Semestre`, `Matricula`, `Situação`) VALUES (2021, 1, 201820014, 'Trancado');
INSERT INTO `Status` (`Ano`, `Semestre`, `Matricula`, `Situação`) VALUES (2021, 1, 201910039, 'Cursando');
INSERT INTO `Status` (`Ano`, `Semestre`, `Matricula`, `Situação`) VALUES (2021, 1, 201920999, 'Trancado');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Emprestimo_Equipamento`
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (1, 201610002, 2516);
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (2, 201920020, 3010);
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (3, 202020080, 3004);
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (4, 202010060, 3001);
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (5, 201810015, 2518);
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (6, 201910016, 2514);
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (7, 201610002, 2517);
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (8, 201820018, 3007);
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (8, 201820018, 2515);
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (9, 201820014, 2512);
INSERT INTO `Emprestimo_Equipamento` (`idEmprestimo`, `Matricula`, `Patrimonio`) VALUES (10, 201910039, 3005);

COMMIT;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
