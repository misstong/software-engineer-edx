package ui;

import model.Transcript;

public class Main {
    public static void main(String[] args){
    Transcript t1 = new Transcript("Jane Doe", 7830);
    Transcript t2 = new Transcript("Ada Lovelace", 8853);
    //TODO: create another Transcript object

    t1.addGrade("CPSC-210", 3.5);
    t1.addGrade("ENGL-201", 4.0);
    t1.addGrade("CPSC-110", 3.1);

    //TODO: add grades to the other Transcript objects

    System.out.print(t1.getStudentName() + ": ");
    t1.printTranscript();

    System.out.println(t1.getGPA());


    //TODO: add more use cases here

}

}
