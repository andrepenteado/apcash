package com.andrepenteado.apscott.models;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.Future;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotBlank;

import lombok.Data;

@Data
@Entity
@Table(name = "receber")
public class Receber {

	@Id
	@SequenceGenerator(name = "receber_id_seq", sequenceName = "receber_id_seq", allocationSize = 1)
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "receber_id_seq")
	@Column(name = "id", nullable = false)
	private Long id;

	@NotBlank
	@Column(name = "descricao")
	private String descricao;

	@NotNull
	@Future
	@Temporal(TemporalType.DATE)
	@Column(name = "data_vencimento")
	private Date dataVencimento;

	@NotNull
	@Column(name = "valor")
	private BigDecimal valor;

	@NotNull
	@ManyToOne
	@JoinColumn(name = "id_categoria", referencedColumnName = "id")
	private Categoria categoria;

	@Column(name = "observacao")
	private String observacao;
}
