package bcd;

import entities.*;
import java.time.LocalDate;
import java.time.Period;
import java.util.List;

import static DAO.EmprestimoDAO.*;
import static DAO.CalendarioDAO.*;
import static DAO.RelatorioDAO.*;


public class UsandoDAO {
    private final String DIVISOR1 = "----------------------------------------------------------------------------------------------------------------------\n";
    private final String DIVISOR2 = "------------------------------------\n";
    private final String DIVISOR3 = "------------------------------------------------------\n";

    public boolean emprestimo(Emprestimo e, int semestre){
        Calendario c = capturaCalendario(LocalDate.now().getYear(), semestre);

        LocalDate defineData = ManipulaData.verificaData(e, c, semestre);

        e.setDataEmprestimo(LocalDate.now());
        e.setDataPrevisaoEntrega(defineData);

        return efetuaEmprestimo(e);
    }

    public boolean renovar(int idEmprestimo, int semestre){
        LocalDate defineData = null;
        int qR = 0;
        Emprestimo e = buscarEmprestimo(idEmprestimo);
        Calendario c = capturaCalendario(LocalDate.now().getYear(), semestre);
        if (e.getQuantidadeRenovacao() < 3 || e.getQuantidadeRenovacao() == 0) {
            qR = e.getQuantidadeRenovacao() + 1;
            defineData = ManipulaData.verificaData(e, c, semestre);
            System.out.println(" Emprestimo Renovado!!");
            return renovarEmprestimo(idEmprestimo, defineData, qR);
        }else{
            System.out.println(" Você estourou o limite de removação!!");
            return false;
        }
    }

    public boolean finalizar(int idEmprestimo){
        boolean r = false;
        Emprestimo e = buscarEmprestimo(idEmprestimo);
        if (e.getDataDevolucao() == null) {
            System.out.println(" Emprestimo finalizado!!");
             r = FinalizarEmprestimo(idEmprestimo);

            int d = verificaPrazo(e);
            int p = d * 3;
            System.out.println(" Você atrasou " + d + " dias!!! Estará impossibilitado de " +
                    "pegar um empréstimo por " + p + " dias");
        }
        return r;
    }

    //Funcionando
    public String listarEmprestimosEmAndamento(int semestre){
        Calendario c = capturaCalendario(LocalDate.now().getYear(), semestre);
        List<Emprestimo> e = emprestimosEmAndamento(c);

        StringBuilder sb = new StringBuilder();

        sb.append(DIVISOR1);
        sb.append(String.format("|%-10s|%-10s|%-10s|%-10s|%-10s|%-10s|%-10s|\n",
                " idEmprestimo ", " Matricula ", " Patrimônio ", " DataEmprestimo ",
                " DataPrevisaoEntrega ", " DataDevolucao ", " QuantidadeRenovacao "));
        sb.append(DIVISOR1);

        e.forEach(emprestimo -> sb.append(emprestimo + "\n"));
        sb.append(DIVISOR1);

        return sb.toString();
    }
    //Funcionando
    public String listarAlunosQueJaRealizaramEmprestimo(){
        List<Pessoa> p = alunosQueJaRealizaramEmprestimo();

        StringBuilder sb = new StringBuilder();

        sb.append(DIVISOR2);
        sb.append(String.format("|%-10s|%-10s|%-10s|\n",
                " Matricula ", " Nome ", " Sobrenome "));
        sb.append(DIVISOR2);

        p.forEach(pessoa -> sb.append(pessoa + "\n"));
        sb.append(DIVISOR2);

        return sb.toString();
    }
    //Funcionando
    public String listarEquipamentoJaEmprestadoAluno(int matricula){
        List<Equipamento> eq = equipamentoJaEmprestadoAluno(matricula);

        StringBuilder sb = new StringBuilder();

        sb.append(DIVISOR3);
        sb.append(String.format("|%-12s|%-39s|\n",
                "Patrimonio", "Nome"));
        sb.append(DIVISOR3);

        eq.forEach(equipamento -> sb.append(equipamento + "\n"));
        sb.append(DIVISOR3);

        return sb.toString();
    }
    //Funcionando
    public String listarEmprestadoEmAndamentoVencido(){
        List<Emprestimo> e = emprestadoEmAndamentoVencido();

        StringBuilder sb = new StringBuilder();

        sb.append(DIVISOR1);
        sb.append(String.format("|%-10s|%-10s|%-10s|%-10s|%-10s|%-10s|%-10s|\n",
                " idEmprestimo ", " Matricula ", " Patrimônio ", " DataEmprestimo ",
                " DataPrevisaoEntrega ", " DataDevolucao ", " QuantidadeRenovacao "));
        sb.append(DIVISOR1);

        e.forEach(emprestimo -> sb.append(emprestimo + "\n"));
        sb.append(DIVISOR1);

        return sb.toString();

    }

    public int verificaPrazo(Emprestimo e){
        Period periodo = Period.between(e.getDataPrevisaoEntrega(), LocalDate.now());

        int dias = periodo.getDays();
        int mes = periodo.getMonths();
        int ano = periodo.getYears();

        int d = dias + (mes*30) + (ano*365);
        return d;
    }


}
