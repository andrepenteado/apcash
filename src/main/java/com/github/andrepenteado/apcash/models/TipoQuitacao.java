
package com.github.andrepenteado.apcash.models;

public enum TipoQuitacao {

    DINHEIRO {
        @Override
        public String getDescricao() {
            return "Dinheiro";
        }
    },
    CHEQUE_VISTA {
        @Override
        public String getDescricao() {
            return "Cheque à Vista";
        }
    },
    CHEQUE_PRE {
        @Override
        public String getDescricao() {
            return "Cheque Pré-Datado";
        }
    },
    CARTAO_DEBITO {
        @Override
        public String getDescricao() {
            return "Cartão Débito";
        }
    },
    CARTAO_CREDITO {
        @Override
        public String getDescricao() {
            return "Cartão Crédito";
        }
    };

    public abstract String getDescricao();

    @Override
    public String toString() {
        return getDescricao();
    }
}
