package entities;

import java.time.LocalDate;
import java.sql.Date;

public class Calendario {
    private int ano;
    private int semestre;
    private LocalDate inicio;
    private LocalDate fim;

    public Calendario(int ano, int semestre, LocalDate inicio, LocalDate fim){
        this.ano = ano;
        this.semestre = semestre;
        this.inicio = inicio;
        this.fim = fim;
    }

    public int getAno() {
        return ano;
    }

    public void setAno(int ano) {
        this.ano = ano;
    }

    public int getSemestre() {
        return semestre;
    }

    public void setSemestre(int semestre) {
        this.semestre = semestre;
    }

    public LocalDate getInicio() {

        return inicio;
    }

    public void setInicio(LocalDate inicio) {
        this.inicio = inicio;
    }

    public LocalDate getFim() {
        return fim;
    }

    public void setFim(LocalDate fim) {
        this.fim = fim;
    }

    @Override
    public String toString() {
        return String.format("|%-5s|%-5s|%-10s|%-10s|",
                ano,semestre, inicio, fim);
    }
}
