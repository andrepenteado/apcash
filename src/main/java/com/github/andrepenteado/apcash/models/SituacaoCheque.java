
package com.github.andrepenteado.apcash.models;

public enum SituacaoCheque {

    PRE_DATADO {
        @Override
        public String getDescricao() {
            return "Pré-Datado";
        }
    },
    COMPENSADO {
        @Override
        public String getDescricao() {
            return "Compensado";
        }
    },
    SEM_FUNDO {
        @Override
        public String getDescricao() {
            return "Sem Fundo";
        }
    };

    public abstract String getDescricao();

    @Override
    public String toString() {
        return getDescricao();
    }
}
