
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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Past;

import org.springframework.format.annotation.NumberFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

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
	@Past
	@Temporal(TemporalType.DATE)
	@Column(name = "data_pagamento")
	private Date dataPagamento;

	@NotNull
	@Enumerated(EnumType.STRING)
	@Column(name = "forma_pagamento")
	private TipoQuitacao formaPagamento;

	@Column(name = "observacao")
	private String observacao;
}
