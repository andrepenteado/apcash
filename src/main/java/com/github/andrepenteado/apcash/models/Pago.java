package com.github.andrepenteado.apcash.models;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.NumberFormat;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Date;

@Data
@EqualsAndHashCode(of = { "pagar", "valorPago", "dataPagamento", "formaPagamento" })
@ToString(of = { "pagar", "valorPago", "dataPagamento", "formaPagamento" })
@Entity
@Table(name = "pago")
public class Pago implements Serializable {

    private static final long serialVersionUID = -4197428786908469146L;

    @Id
    @SequenceGenerator(name = "pago_id_seq", sequenceName = "pago_id_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "pago_id_seq")
    @Column(name = "id", nullable = false)
    private Long id;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "id_pagar", referencedColumnName = "id")
    private Pagar pagar;

    @NotNull
    @NumberFormat(pattern = "#,##0.00")
    @Column(name = "valor_pago")
    private BigDecimal valorPago;

    @NotNull
    @DateTimeFormat(pattern = "dd/MM/yyyy")
    @Column(name = "data_pagamento")
    private LocalDate dataPagamento;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "forma_pagamento")
    private TipoQuitacao formaPagamento;

    @Column(name = "observacao")
    private String observacao;

    public Date getDataPagamentoJsp() {
        return java.sql.Date.valueOf(this.dataPagamento);
    }
}
