package bcd;
// https://docs.oracle.com/javase/tutorial/jdbc/basics/transactions.html
import DAO.*;
import entities.*;

import java.util.Objects;
import java.util.Scanner;

public class Principal {
    private static final int SEMESTRE = 1;

    public static void main(String[] args) {
        UsandoDAO u = new UsandoDAO();
        Emprestimo e = null;
        int matricula = 0; int atividade = 0; int patrimonio = 0; int id = 0;
        String novoItem;
        Scanner teclado = new Scanner(System.in);
        for (; ; ) {
            System.out.print("\n ======================================================\n" +
                    " 1 - Efetuar empréstimo;\n" +
                    " 2 - Renovar empréstimo;\n" +
                    " 3 - Finalizar empréstimo;\n" +
                    " 4 - Listar todos os empréstimos em andamento;\n" +
                    " 5 - Listas alunos que já solicitaram um empréstimo;\n" +
                    " 6 - Listar equipamento por aluno;\n" +
                    " 7 - Empréstimo em andamento com status vencido;\n" +
                    " 0 - Sair.\n" +
                    " ======================================================\n" +
                    " Digite sua opção: ");
            int opcao = teclado.nextInt();

            switch (opcao) {
                case 1:
                    System.out.printf(" Digite matricula do aluno: ");
                    matricula = teclado.nextInt();

                    System.out.printf(" Digite a atividade na qual deseja solicitar o emprestimo. " +
                            "\n 1 - Atividade de ensino" +
                            "\n 2 - Projetos de pesquisa"+
                            "\n 3 - Projetos de extensão "+
                            "\n 4 - Trabalho de conclusão de curso" +
                            "\n Digite sua opção: ");
                    atividade = teclado.nextInt();

                    System.out.printf(" Digite código de patrimônio: ");
                    patrimonio = teclado.nextInt();

                    e = new Emprestimo(id, matricula, atividade);
                    if(u.emprestimo(e, SEMESTRE)){
                        EmprestimoDAO.addEmprestimo(e, patrimonio);

                        System.out.printf(" Deseja adicionar outro item? (S/N): ");
                        novoItem = teclado.next();

                        if (Objects.equals(novoItem, "S")) {
                            System.out.printf(" Digite código de patrimônio: ");
                            patrimonio = teclado.nextInt();
                            EmprestimoDAO.addEmprestimo(e, patrimonio);
                        }else {
                            continue;
                        }
                    }
                    break;
                case 2:
                    System.out.printf(" Digite emprestimo que seja renovar: ");
                    id = teclado.nextInt();

                    u.renovar(id, SEMESTRE);

                    break;
                case 3:
                    System.out.printf(" Digite emprestimo que seja finalizar: ");
                    id = teclado.nextInt();
                    u.finalizar(id);

                    break;
                case 4:
                    System.out.println("\n" +u.listarEmprestimosEmAndamento(SEMESTRE));

                    break;
                case 5:
                    System.out.println("\n" + u.listarAlunosQueJaRealizaramEmprestimo());

                    break;
                case 6:
                    System.out.printf(" Digite a matrícula do aluno: ");
                    matricula = teclado.nextInt();
                    System.out.println("\n" + u.listarEquipamentoJaEmprestadoAluno(matricula));

                    break;
                case 7:
                    System.out.println("\n" + u.listarEmprestadoEmAndamentoVencido());

                    break;
                case 0:
                    System.exit(0);
                default:
                    System.out.println(" Opção inválida!");
                    System.exit(-1);
                    break;
            }
        }
    }
}