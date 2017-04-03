
package com.github.andrepenteado.apscott.models;

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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.NumberFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(of = { "receber", "valorRecebido", "dataRecebimento", "formaRecebimento" })
@ToString(of = { "receber", "valorRecebido", "formaRecebimento" })
@Entity
@Table(name = "recebido")
public class Recebido implements Serializable {

    private static final long serialVersionUID = -4197428786908469146L;

    @Id
    @SequenceGenerator(name = "recebido_id_seq", sequenceName = "recebido_id_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "recebido_id_seq")
    @Column(name = "id", nullable = false)
    private Long id;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "id_receber", referencedColumnName = "id")
    private Receber receber;

    @NotNull
    @NumberFormat(pattern = "#,##0.00")
    @Column(name = "valor_recebido")
    private BigDecimal valorRecebido;

    @NotNull
    @Temporal(TemporalType.DATE)
    @DateTimeFormat(pattern = "dd/MM/yyyy")
    @Column(name = "data_recebimento")
    private Date dataRecebimento;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "forma_recebimento")
    private TipoQuitacao formaRecebimento;

    @Column(name = "observacao")
    private String observacao;
}
