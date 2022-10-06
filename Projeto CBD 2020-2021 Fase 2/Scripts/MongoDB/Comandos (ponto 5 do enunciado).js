use STBWeb

/*____________________________________________________*/
/*                                                    */
/*        COMANDOS (PONTO 5 DO ENUNCIADO)             */
/*                                                    */
/*----------------------------------------------------*/

/*
Esta é uma tabela temporária usada para associar a informação do Estudante com a do seu guardião,
de forma a facilitar a realização da query 1.
*/
db.Guardian.aggregate([
    {
        $lookup:
        {
            from: "Student",
            localField: "GuardianID",
            foreignField: "SGuardianID",
            as: "student"
        }
    },
    {
        $unwind: "$student"
    },
    { $out: "GuardianStudentAssociation"}
]);

/* 1 - Listar por Encarregado de Educação o “histórico de notas” dos alunos ao seu encargo */
db.Grades.aggregate([
    {
        $lookup:
        {
            from: "GuardianStudentAssociation",
            localField: "GStudentID",
            foreignField: "student.StudentNumber",
            as: "studentGuardianInformation"
        }
    },
    {
        $unwind: "$studentGuardianInformation"
    },
    {
        $lookup:
        {
            from: "Subjects",
            localField: "GSubjectID",
            foreignField: "SubjectID",
            as: "subject"
        }
    },
    {
        $unwind: "$subject"
    }
]);


/*-----------------------------------------------------------------------------------------------------------*/

/* 2 - Listar por aluno as notas de um determinado ano letivo, e a respectiva média final */
db.Grades.aggregate([
    {
        $group: {
                    _id:"$GStudentID", 
                    avgOfGrades: {$avg: {$add: [ "$P1", "$P2", "$P3" ] } }
                }
    },
    {$project: {
                     GStudentID:"$_id",
                     GDate: {$dateToParts: { 
                        date: "$GDate", 
                     }},
                     Avg: "$avgOfGrades"
                  }
    }
])


/*-----------------------------------------------------------------------------------------------------------*/

/* 3 - Listar por disciplina, os respetivos alunos e notas obtidas */
db.Grades.aggregate([
    {
    $match: {
        GSubjectID: {
            "$exists": true
        }
    }
   {
        $lookup:
        {
            from: "Subjects",
            localField: "GSubjectID",
            foreignField: "SubjectID",
            as: "subject"
        }
    },
    {
        $unwind: "$subject"
    },
    {
        $lookup:
        {
            from: "Student",
            localField: "GStudentID",
            foreignField: "StudentNumber",
            as: "student"
        }
    },
    {
        $unwind: "$student"
    }
]);





















































