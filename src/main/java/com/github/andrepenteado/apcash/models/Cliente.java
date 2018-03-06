package com.github.andrepenteado.apcash.models;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.validation.constraints.NotBlank;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
@EqualsAndHashCode(of = { "nome", "cpf" })
@ToString(of = { "nome", "cpf" })
@Entity
@Table(name = "cliente")
public class Cliente implements Serializable {

    private static final long serialVersionUID = -8028984346313844118L;

    @Id
    @SequenceGenerator(name = "cliente_id_seq", sequenceName = "cliente_id_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "cliente_id_seq")
    @Column(name = "id", nullable = false)
    private Long id;

    @NotBlank
    @Column(name = "nome")
    private String nome;

    @NotBlank
    @Column(name = "cpf")
    private String cpf;

    @DateTimeFormat(pattern = "dd/MM/yyyy HH:mm")
    @Column(name = "data_cadastro")
    private LocalDateTime dataCadastro;

    @DateTimeFormat(pattern = "dd/MM/yyyy HH:mm")
    @Column(name = "data_ultima_atualizacao")
    private LocalDateTime dataUltimaAtualizacao;

    @DateTimeFormat(pattern = "dd/MM/yyyy")
    @Column(name = "data_nascimento")
    private LocalDate dataNascimento;

    @Column(name = "telefone")
    private String telefone;

    @Column(name = "celular")
    private String celular;

    @Column(name = "whatsapp")
    private Boolean whatsapp;

    @Column(name = "email")
    private String email;

    @Column(name = "profissao")
    private String profissao;

    @Column(name = "cep")
    private Long cep;

    @Column(name = "logradouro")
    private String logradouro;

    @Column(name = "numero")
    private String numero;

    @Column(name = "complemento")
    private String complemento;

    @Column(name = "bairro")
    private String bairro;

    @Column(name = "cidade")
    private String cidade;

    @Column(name = "estado")
    private String estado;

    @Column(name = "observacao")
    private String observacao;

    public String getDataCadastroFormatada() {
        if (getDataCadastro() == null) {
            return "novo";
        }
        return getDataCadastro().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public String getDataUltimaAtualizacaoFormatada() {
        if (getDataUltimaAtualizacao() == null) {
            return "não houve";
        }
        return getDataUltimaAtualizacao().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
