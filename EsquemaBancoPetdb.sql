

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema petdb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `petdb` ;

-- -----------------------------------------------------
-- Schema petdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `petdb` DEFAULT CHARACTER SET utf8 ;
USE `petdb` ;

-- -----------------------------------------------------
-- Table `petdb`.`enderecos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`enderecos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `rua` VARCHAR(60) NOT NULL,
  `cep` VARCHAR(8) NOT NULL,
  `bairro` VARCHAR(45) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `uf` VARCHAR(2) CHARACTER SET 'ascii' NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`clientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(60) NOT NULL,
  `cpf` VARCHAR(11) NULL,
  `endereco_id` INT NOT NULL,
  PRIMARY KEY (`id`, `endereco_id`),
  INDEX `fk_endereco_idx` (`endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_endereco`
    FOREIGN KEY (`endereco_id`)
    REFERENCES `petdb`.`enderecos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`usuarios` (
  `id` INT NOT NULL,
  `nome` VARCHAR(15) NOT NULL,
  `senha` VARCHAR(20) NOT NULL,
  `login` VARCHAR(15) NOT NULL,
  `tipo` VARCHAR(15) NOT NULL COMMENT 'Para definir niveis de usuários, tipo: 1, 2, 3, etc e suas permisões ou acessos, como cadastrar/deletar outros usuários ou acessar relatórios de vendas',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`situacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`situacao` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(15) NULL COMMENT 'recebido; concluido; cancelado',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`pedidos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL,
  `observacao` VARCHAR(200) NULL,
  `usuario_id` INT NOT NULL,
  `clientes_id` INT NOT NULL,
  `situacao_id` INT NOT NULL,
  PRIMARY KEY (`id`, `usuario_id`, `clientes_id`, `situacao_id`),
  INDEX `fk_usuario_idx` (`usuario_id` ASC) VISIBLE,
  INDEX `fk_clientes_idx` (`clientes_id` ASC) INVISIBLE,
  INDEX `fk_situacao_idx` (`situacao_id` ASC) INVISIBLE,
  CONSTRAINT `fk_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `petdb`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_clientes`
    FOREIGN KEY (`clientes_id`)
    REFERENCES `petdb`.`clientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_situacao`
    FOREIGN KEY (`situacao_id`)
    REFERENCES `petdb`.`situacao` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`tamanhos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`tamanhos` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(3) NOT NULL COMMENT 'Tamanho do produto, PP, P, M, G, GG',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`marcas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`marcas` (
  `id` INT NOT NULL,
  `descricao` VARCHAR(50) NOT NULL COMMENT 'Marca do produto',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`animais`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`animais` (
  `id` INT NOT NULL,
  `tipo` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`produtos` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(250) NOT NULL,
  `foto` VARCHAR(50) NULL,
  `preco_custo` FLOAT NOT NULL,
  `preco_venda` FLOAT NOT NULL,
  `modelo` VARCHAR(45) NOT NULL,
  `cod_barras` VARCHAR(13) NULL,
  `porcentagem` FLOAT NULL,
  `quantidade` INT NULL DEFAULT 0,
  `usuario_id` INT NOT NULL,
  `tamanho_id` INT NOT NULL,
  `marca_id` INT NOT NULL,
  `animal_id` INT NOT NULL,
  PRIMARY KEY (`id`, `usuario_id`, `tamanho_id`, `marca_id`, `animal_id`),
  INDEX `fk_usuario_idx` (`usuario_id` ASC) VISIBLE,
  INDEX `fk_tamanho_idx` (`tamanho_id` ASC) VISIBLE,
  INDEX `fk_marca_idx` (`marca_id` ASC) VISIBLE,
  INDEX `fk_animal_idx` (`animal_id` ASC) VISIBLE,
  INDEX `nome_idx` (`nome` ASC) VISIBLE,
  CONSTRAINT `fk_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `petdb`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tamanho`
    FOREIGN KEY (`tamanho_id`)
    REFERENCES `petdb`.`tamanhos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_marca`
    FOREIGN KEY (`marca_id`)
    REFERENCES `petdb`.`marcas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_animal`
    FOREIGN KEY (`animal_id`)
    REFERENCES `petdb`.`animais` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`pets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`pets` (
  `id` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `raca` VARCHAR(45) NULL,
  `porte` VARCHAR(10) NULL,
  `genero` VARCHAR(1) NULL,
  `cliente_id` INT NULL,
  `clientes_id` INT NOT NULL,
  `clientes_endereco_id` INT NOT NULL,
  `animais_id` INT NOT NULL,
  PRIMARY KEY (`id`, `clientes_id`, `clientes_endereco_id`, `animais_id`),
  INDEX `fk_pets_clientes1_idx` (`clientes_id` ASC, `clientes_endereco_id` ASC) VISIBLE,
  INDEX `fk_pets_animais1_idx` (`animais_id` ASC) VISIBLE,
  CONSTRAINT `fk_pets_clientes1`
    FOREIGN KEY (`clientes_id` , `clientes_endereco_id`)
    REFERENCES `petdb`.`clientes` (`id` , `endereco_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pets_animais1`
    FOREIGN KEY (`animais_id`)
    REFERENCES `petdb`.`animais` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`telefones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`telefones` (
  `id` INT NOT NULL DEFAULT 0,
  `telefone` VARCHAR(11) NULL,
  `clientes_id` INT NOT NULL,
  `clientes_endereco_id` INT NOT NULL,
  PRIMARY KEY (`id`, `clientes_id`, `clientes_endereco_id`),
  INDEX `fk_telefones_clientes1_idx` (`clientes_id` ASC, `clientes_endereco_id` ASC) VISIBLE,
  CONSTRAINT `fk_telefones_clientes1`
    FOREIGN KEY (`clientes_id` , `clientes_endereco_id`)
    REFERENCES `petdb`.`clientes` (`id` , `endereco_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `petdb`.`pedido_produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petdb`.`pedido_produto` (
  `pedido_id` INT NOT NULL,
  `produto_id` INT NOT NULL,
  `quantidade` INT NULL,
  `preco` FLOAT NULL,
  `total` FLOAT NULL,
  PRIMARY KEY (`pedido_id`, `produto_id`),
  INDEX `fk_produto_idx` (`produto_id` ASC) INVISIBLE,
  INDEX `fk_pedido_idx` (`pedido_id` ASC) VISIBLE,
  CONSTRAINT `fk_pedido`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `petdb`.`pedidos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produto`
    FOREIGN KEY (`produto_id`)
    REFERENCES `petdb`.`produtos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
