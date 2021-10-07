package entities;

public class Equipamento {
    private String patrimonio;
    private String nome;

    public Equipamento(String patrimonio, String nome) {
        this.patrimonio = patrimonio;
        this.nome = nome;
    }

    public String getPatrimonio() {
        return patrimonio;
    }

    public void setPatrimonio(String patrimonio) {
        this.patrimonio = patrimonio;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    @Override
    public String toString() {
        return String.format("|%-12s|%-39s|",
                patrimonio, nome);
    }

}
