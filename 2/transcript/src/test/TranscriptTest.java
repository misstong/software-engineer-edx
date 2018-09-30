package test;

import model.Transcript;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class TranscriptTest {

    private Transcript testTranscript;

    @Before
    public void setUp(){
        testTranscript = new Transcript("Student Name", 1000);
        //TODO: write new values in testTranscript constructor
    }

    @Test
    public void testTemplate(){
        //TODO: write tests for Transcript methods
    }

    @Test
    public void testAddGrade(){
        assertEquals(testTranscript.numCourses(),0);
        testTranscript.addGrade("CS",4.0);
        assertEquals(testTranscript.numCourses(),1);
        assertEquals(testTranscript.getCourseAndGrade("CS"),"CS:4.0");
    }
}
