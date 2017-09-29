package com.github.andrepenteado.apcash.models;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.hibernate.validator.constraints.NotBlank;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.NumberFormat;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collection;
import java.util.Date;

@Data
@EqualsAndHashCode(of = {"descricao", "dataVencimento", "valor"})
@ToString(of = {"descricao", "dataVencimento", "valor"})
@Entity
@Table(name = "pagar")
public class Pagar implements Serializable {

    private static final long serialVersionUID = -5444758171825826973L;

    @Id
    @SequenceGenerator(name = "pagar_id_seq", sequenceName = "pagar_id_seq", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "pagar_id_seq")
    @Column(name = "id", nullable = false)
    private Long id;

    @NotBlank
    @Column(name = "descricao")
    private String descricao;

    @NotNull
    @DateTimeFormat(pattern = "dd/MM/yyyy")
    @Column(name = "data_vencimento")
    private LocalDate dataVencimento;

    @NotNull
    @NumberFormat(pattern = "#,##0.00")
    @Column(name = "valor")
    private BigDecimal valor;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "id_categoria", referencedColumnName = "id")
    private Categoria categoria;

    @Column(name = "observacao")
    private String observacao;

    @OneToMany(mappedBy = "pagar", cascade = CascadeType.ALL)
    @OrderBy(value = "dataPagamento")
    private Collection<Pago> pagamentos;

    public boolean isVencida() {
        LocalDate hoje = LocalDate.now();
        return hoje.isAfter(this.dataVencimento);
    }

    public boolean isVencendo() {
        LocalDate hoje = LocalDate.now();
        return hoje.isEqual(this.dataVencimento);
    }

    public boolean isVencer() {
        LocalDate hoje = LocalDate.now();
        return hoje.isBefore(this.dataVencimento);
    }

    public Date getDataVencimentoJsp() {
        return java.sql.Date.valueOf(this.dataVencimento);
    }
}