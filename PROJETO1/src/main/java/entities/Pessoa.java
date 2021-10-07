package entities;

import java.sql.Date;
import java.time.LocalDate;

public class Pessoa {
    private int matricula;
    private String nome;
    private String sobrenome;
    private LocalDate dataNac;

    public Pessoa(int matricula, String nome, String sobrenome) {
        this.matricula = matricula;
        this.nome = nome;
        this.sobrenome = sobrenome;
    }

    public int getMatricula() {
        return matricula;
    }

    public void setMatricula(int matricula) {
        this.matricula = matricula;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getSobrenome() {
        return sobrenome;
    }

    public void setSobrenome(String sobrenome) {
        this.sobrenome = sobrenome;
    }

    public LocalDate getDataNascimento() {
        return dataNac;
    }

    public void setDataNascimento(LocalDate DataNascimento) {
        this.dataNac = DataNascimento;
    }


    @Override
    public String toString() {
        return String.format("|%-11s|%-10s|%-11s|",
                matricula, nome, sobrenome);
    }
}