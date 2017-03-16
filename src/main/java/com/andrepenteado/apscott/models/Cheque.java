
package com.andrepenteado.apscott.models;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotBlank;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(of = { "numero", "nome", "valor", "data" })
@ToString(of = { "numero", "nome", "valor", "data" })
@Entity
@Table(name = "cheque")
public class Cheque implements Serializable {

    private static final long serialVersionUID = 44393616612232895L;

    @Id
    @SequenceGenerator(name = "cheque_id_seq", sequenceName = "cheque_id_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "cheque_id_seq")
    @Column(name = "id", nullable = false)
    private Long id;

    @NotNull
    @Column(name = "numero")
    private Long numero;

    @NotBlank
    @Column(name = "nome")
    private String nome;

    @NotNull
    @Column(name = "valor")
    private BigDecimal valor;

    @NotNull
    @Temporal(TemporalType.DATE)
    @Column(name = "data")
    private Date data;

    @Enumerated(EnumType.STRING)
    @Column(name = "situacao")
    private SituacaoCheque situacao;
}