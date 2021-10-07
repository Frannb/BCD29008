package entities;

import java.time.LocalDate;
import java.util.List;

public class Emprestimo {
    private int idEmprestimo;
    private int matricula;
    private int patrimonio;
    private int idAtividade;
    private LocalDate dataEmprestimo;
    private LocalDate dataPrevisaoEntrega;
    private LocalDate dataDevolucao;
    private int quantidadeRenovacao;

    public Emprestimo(int idEmprestimo, int matricula, int idAtividade) {
        this.idEmprestimo = idEmprestimo;
        this.matricula = matricula;
        this.idAtividade = idAtividade;
        this.dataEmprestimo = LocalDate.now();
    }

    public Emprestimo(int idEmprestimo, int matricula, int idAtividade, int patrimonio) {
        this.idEmprestimo = idEmprestimo;
        this.matricula = matricula;
        this.idAtividade = idAtividade;
        this.patrimonio = patrimonio;
        this.dataEmprestimo = LocalDate.now();
    }


    public Emprestimo(int idEmprestimo, int matricula, int patrimonio, int idAtividade,
                      LocalDate dataEmprestimo, LocalDate dataPrevisaoEntrega) {
        this.idEmprestimo = idEmprestimo;
        this.matricula = matricula;
        this.patrimonio = patrimonio;
        this.idAtividade = idAtividade;
        this.dataEmprestimo = dataEmprestimo;
        this.dataPrevisaoEntrega = dataPrevisaoEntrega;
    }

    public Emprestimo(int idEmprestimo, int matricula, int patrimonio, int idAtividade,
                      LocalDate dataEmprestimo, LocalDate dataPrevisaoEntrega,
                      int quantidadeRenovacao) {
        this.idEmprestimo = idEmprestimo;
        this.matricula = matricula;
        this.patrimonio = patrimonio;
        this.idAtividade = idAtividade;
        this.dataEmprestimo = dataEmprestimo;
        this.dataPrevisaoEntrega = dataPrevisaoEntrega;
        this.quantidadeRenovacao = quantidadeRenovacao;
    }


    public int getIdEmprestimo() {
        return idEmprestimo;
    }

    public void setIdEmprestimo(int idEmprestimo) {
        this.idEmprestimo = idEmprestimo;
    }

    public int getMatricula() {
        return matricula;
    }

    public void setMatricula(int matricula) {
        this.matricula = matricula;
    }

    public int getPatrimonio() {
        return patrimonio;
    }

    public void setPatrimonio(int patrimonio) {
        this.patrimonio = patrimonio;
    }

    public int getIdAtividade() {
        return idAtividade;
    }

    public void setIdAtividade(int idAtividade) {
        this.idAtividade = idAtividade;
    }

    public LocalDate getDataEmprestimo() {
        return dataEmprestimo;
    }

    public void setDataEmprestimo(LocalDate dataEmprestimo) {
        this.dataEmprestimo = dataEmprestimo;
    }

    public LocalDate getDataPrevisaoEntrega() {
        return dataPrevisaoEntrega;
    }

    public void setDataPrevisaoEntrega(LocalDate dataPrevisaoEntrega) {
        this.dataPrevisaoEntrega = dataPrevisaoEntrega;
    }

    public LocalDate getDataDevolucao() {
        return dataDevolucao;
    }

    public void setDataDevolucao(LocalDate dataDevolucao) {
        this.dataDevolucao = dataDevolucao;
    }

    public int getQuantidadeRenovacao() {
        return quantidadeRenovacao;
    }

    public void setQuantidadeRenovacao(int quantRenovacao) {
        quantidadeRenovacao = quantRenovacao;
    }

    @Override
    public String toString() {
        return String.format("|%-14s|%-11s|%-12s|%-12s|%-16s|%-21s|%-15s|%-21s|",
                idEmprestimo,matricula, idAtividade, patrimonio, dataEmprestimo,
                dataPrevisaoEntrega,dataDevolucao,quantidadeRenovacao);
    }
}
