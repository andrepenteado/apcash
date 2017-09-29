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
    @DateTimeFormat(pattern = "dd/MM/yyyy")
    @Column(name = "data_recebimento")
    private LocalDate dataRecebimento;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "forma_recebimento")
    private TipoQuitacao formaRecebimento;

    @Column(name = "observacao")
    private String observacao;

    public Date getDataRecebimentoJsp() {
        return java.sql.Date.valueOf(this.dataRecebimento);
    }
}
