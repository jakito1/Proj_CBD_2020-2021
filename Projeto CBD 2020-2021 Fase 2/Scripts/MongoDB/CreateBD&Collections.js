use STBWeb

db.createCollection('Person');
db.createCollection('Student');
db.createCollection('Guardian');
db.createCollection('Subjects');
db.createCollection('Grades');

/*
CONSULTAS PARA VERIFICAR QUE OS DADOS FORAM CORRETAMENTE IMPORTADOS (FAZER FETCH COUNT PARA VERIFICAR O NÚMERO DE REGISTOS)
db.Person.find({}).sort({ "PersonID": 1 });
db.Student.find({}).sort({ "StudentNumber": 1 });
db.Guardian.find({}).sort({ "GuardianID": 1 });
db.Subjects.find({}).sort({ "SubjectID": 1 });
db.Grades.find({}).sort({ "GradeID": 1 });
*/