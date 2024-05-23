// Katharina Sternbauer, k11812499

// 1. Return all nodes
match (n) return n;

// 2. Return all lectures
match (l:Lecture) return l;

// 3. Return all lectures held by FAW (lecture.id starts with: 351.)
match (l:Lecture) where l.id STARTS WITH ("351.") return l;

// 4. List all exams belonging to the lecture Information Systems 1.
match (e:Exam)<-[:HAS_EXAM]-(l:Lecture {topic: "Information Systems 1"}) return e;

// 5. Find all second professors for a lecture
match (l:Lecture) with l match(p:Professor) WHERE (p)-[:TEACHES {order: 2}]->(l) return *;

// one could argue that you only want the professor and NOT see the lecture, then do a "return p" like

match (l:Lecture) with l match(p:Professor) WHERE (p)-[:TEACHES {order: 2}]->(l) return p;

// 6. Find all professors giving 2 lectures
MATCH (p:Professor)-[:TEACHES]->(l:Lecture)
with p, count(l) as teachedLectures WHERE teachedLectures = 2
RETURN p;

// 7. Find the lecture missing the ECTS entry
match (l:Lecture) WHERE l.ects IS NULL return l;

// 8. With which professor does Rene share a lecture?
match (r:Professor {name: "Rene"})-[:TEACHES]->(l:Lecture) with r, l match (p:Professor)-[:TEACHES]->(l) WHERE p <> r return p;

// 9. Find exams with registrations but no grades
match ()-[:REGISTERS]->(e:Exam) WHERE NOT ()-[:HAS_GRADE]->(e) return e;

// Note: I only returned exams where no grade AT all exists. To also return exams where some, but not all, students have gotten grades, this query should produce the a different result.

match (s:Student)-[:REGISTERS]->(e:Exam) WHERE NOT (s)-[:HAS_GRADE]->(e) return e;

// 10. Find the students and lecture not hearing a lecture but registering for the exam
match (s:Student)-[:REGISTERS]->(e:Exam)<-[:HAS_EXAM]-(l:Lecture) WHERE NOT (s)-[:HEARS]->(l) return s,l;

// 11. Find the student not doing anything
match (s:Student) WHERE NOT (s)-[]-() return s;

// 12. Calculate the average grade per lecture (a student failing at first and then passing counts both times)
MATCH (l:Lecture)-[:HAS_EXAM]->(e:Exam)<-[grade:HAS_GRADE]-(:Student)
WITH l, AVG(grade.grade) AS avgGrade
return l, avgGrade ORDER BY avgGrade;
//Alternative: wILL DO THAT avg in the return statement
MATCH (l:Lecture)-[:HAS_EXAM]->(e:Exam)<-[grade:HAS_GRADE]-(:Student)
return l as Lecture, AVG(grade.grade) AS avgGrade ORDER BY avgGrade;

// 13. Find the students getting the better grade on a later attempt. Note: use the function date() https://neo4j.com/docs/cypher-manual/current/functions/temporal/#functions-date
MATCH (s:Student)-[hg1:HAS_GRADE]->(exam1:Exam)<-[:HAS_EXAM]-(l:Lecture)
WITH s, hg1, l, exam1
MATCH (s)-[hg2:HAS_GRADE]->(exam2:Exam)<-[:HAS_EXAM]-(l) WHERE hg2.grade < hg1.grade AND date(exam1.date) < date(exam2.date) 
RETURN s;

// 14. Find the students registering for an exam but not getting a grade. Return students and lectures.
match (s:Student)-[:REGISTERS]->(e:Exam)<-[:HAS_EXAM]-(l:Lecture) WHERE NOT (s)-[:HAS_GRADE]->(e) return s,l;

// 15. Find which professor examines an exam but does not read the lecture
match (p:Professor)-[:EXAMINES]->(e:Exam)<-[:HAS_EXAM]-(l:Lecture) WHERE NOT (p)-[:TEACHES]->(l) return p;

// 16. All connections between professor Martina and student Alex with at most 5 hops.
match path = (p:Professor {name: "Martina"})-[*1..5]-(s:Student {name: "Alex"})
return length(path), path ORDER BY length(path);

