package model;

public class Transcript {
    public Transcript(String studentName,int studentID){}

    //getters
    public String getStudentName(){return null;}

    //TODO: Design specification for this method
    //Requires:course must be valid,grade must between 0 and 4.0
    //Modifies:this
    //Effect:add a course and its corresponding grade to the transcript
    public void addGrade(String course, double grade){ }

    //TODO: Design specification for this method
    // This method should return course name and grade in some consistent String format
    //Requires:the course must be in the transcript
    //Effect:return course name and grade in some consistent String format
    public String getCourseAndGrade(String course){ return null; }

    //TODO: Design specification for this method
    //Effect:print the transcript
    public void printTranscript(){ }

    //TODO: Design specification for this method
    //Requires:at least one course in the transcript
    //Effect:return GPA of transcript
    public double getGPA(){ return 0.0; }

    public int numCourses(){return 0;}
}
