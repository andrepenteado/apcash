
package com.github.andrepenteado.apscott.models;

public enum DespesaReceita {

    DESPESA {
        @Override
        public String getDescricao() {
            return "Despesa";
        }
    },
    RECEITA {
        @Override
        public String getDescricao() {
            return "Receita";
        }
    };

    public abstract String getDescricao();

    @Override
    public String toString() {
        return getDescricao();
    }
}
