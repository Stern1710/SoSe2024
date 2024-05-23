// --- Create students ---
CREATE (s:Student{name: "Anton", matrNr: "k11223344", study: "Computer Science"});
CREATE (s:Student{name: "Berta", matrNr: "k55667788", study: "Computer Science"});
CREATE (s:Student{name: "Caesar", matrNr: "k99001122", study: "Artificial Intelligence"});
CREATE (s:Student{name: "Dora", matrNr: "k33445566", study: "Wirtschaftsinformatik"});
CREATE (s:Student{name: "Emil", matrNr: "k77889900", study: "Soziologie"});

// --- Create professors ---
CREATE (p:Professor{name: "Hannes Forscher", akNr: "ak12345678"});
CREATE (p:Professor{name: "Michael Lehrer", akNr: "ak87654321"});
CREATE (p:Professor{name: "Jonathan Wisser", akNr: "ak12344321"});
CREATE (p:Professor{name: "Erich Nachschlager", akNr: "ak56788765"});
CREATE (p:Professor{name: "Peter Pruefer", akNr: "ak90909090"});

// --- Create Lectures ---
CREATE (l:Lecture{title: "Punctuality", lvaNr: "123.123", type: "VL", credits: 3.0});
CREATE (l:Lecture{title: "Introduction to CS", lvaNr: "567.345", type: "KV", credits: 3.0});
CREATE (l:Lecture{title: "Advanced Social Economics", lvaNr: "047.256", type: "VL", credits: 6.0});
CREATE (l:Lecture{title: "Electromagic", lvaNr: "385.357", type: "UE", credits: 1.5});
CREATE (l:Lecture{title: "PC Internals", lvaNr: "531.966", type: "KV", credits: 4.5});
CREATE (l:Lecture{title: "Complex Mathematics", lvaNr: "332.471", type: "UE", credits: 3.0});

// --- Relate professors to lectures ---
// Introduction to CS
match (p:Professor {akNr: "ak12345678"}) with p match (l:Lecture {title: "Introduction to CS"}) with p,l CREATE (p)-[:TEACHES{slot: 1, semester: "WS2022"}]->(l), (p)-[:TEACHES{slot: 2, semester: "WS2023"}]->(l);
match (p:Professor {akNr: "ak12344321"}) with p match (l:Lecture {title: "Introduction to CS"}) with p,l CREATE (p)-[:TEACHES{slot: 1, semester: "WS2023"}]->(l);
// Punctuality
match (p:Professor {akNr: "ak56788765"}) with p match (l:Lecture {title: "Punctuality"}) with p,l CREATE (p)-[:TEACHES{slot: 1, semester: "WS2023"}]->(l), (p)-[:TEACHES{slot: 1, semester: "WS2022"}]->(l), (p)-[:TEACHES{slot: 1, semester: "SS2024"}]->(l), (p)-[:TEACHES{slot: 1, semester: "SS2023"}]->(l);
//Advanced Social Economics
match (p:Professor {akNr: "ak12345678"}) with p match (l:Lecture {title: "Advanced Social Economics"}) with p,l CREATE (p)-[:TEACHES{slot: 1, semester: "SS2024"}]->(l), (p)-[:TEACHES{slot: 1, semester: "SS2023"}]->(l);
// Electromagic
match (p:Professor {akNr: "ak87654321"}) with p match (l:Lecture {title: "Electromagic"}) with p,l CREATE (p)-[:TEACHES{slot: 1, semester: "WS2022"}]->(l), (p)-[:TEACHES{slot: 1, semester: "SS2024"}]->(l);
match (p:Professor {akNr: "ak90909090"}) with p match (l:Lecture {title: "Electromagic"}) with p,l CREATE (p)-[:TEACHES{slot: 2, semester: "SS2024"}]->(l);
// PC Internals
match (p:Professor {akNr: "ak12344321"}) with p match (l:Lecture {title: "PC Internals"}) with p,l CREATE (p)-[:TEACHES{slot: 1, semester: "SS2024"}]->(l), (p)-[:TEACHES{slot: 2, semester: "SS2023"}]->(l);
match (p:Professor {akNr: "ak90909090"}) with p match (l:Lecture {title: "PC Internals"}) with p,l CREATE (p)-[:TEACHES{slot: 2, semester: "SS2024"}]->(l), (p)-[:TEACHES{slot: 1, semester: "SS2023"}]->(l);
// Complex Mathematics
match (p:Professor {akNr: "ak56788765"}) with p match (l:Lecture {title: "Complex Mathematics"}) with p,l CREATE (p)-[:TEACHES{slot: 1, semester: "WS2023"}]->(l), (p)-[:TEACHES{slot: 1, semester: "WS2022"}]->(l), (p)-[:TEACHES{slot: 2, semester: "SS2024"}]->(l), (p)-[:TEACHES{slot: 2, semester: "SS2023"}]->(l);
match (p:Professor {akNr: "ak87654321"}) with p match (l:Lecture {title: "Complex Mathematics"}) with p,l CREATE (p)-[:TEACHES{slot: 1, semester: "SS2024"}]->(l);
match (p:Professor {akNr: "ak90909090"}) with p match (l:Lecture {title: "Complex Mathematics"}) with p,l CREATE (p)-[:TEACHES{slot: 1, semester: "SS2023"}]->(l);

// --- Create Exams for different lectures ---
// Introduction to CS
MATCH (l:Lecture {title: "Introduction to CS"}) with l MATCH (p:Professor)-[:TEACHES{slot: 1, semester: "WS2022"}]->(l) WITH l,p CREATE (e:Exam {number: 1, date: '30.01.2023'}), (e)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e), (e2:Exam {number: 2, date: '03.04.2023'}), (e2)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e2);
MATCH (l:Lecture {title: "Introduction to CS"}) with l MATCH (p:Professor)-[:TEACHES{slot: 1, semester: "WS2023"}]->(l) WITH l,p CREATE (e:Exam {number: 1, date: '01.02.2024'}), (e)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e), (e2:Exam {number: 2, date: '03.03.2024'}), (e2)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e2);
// Punctuality
MATCH (l:Lecture {title: "Punctuality"}) with l MATCH (p:Professor)-[:TEACHES{slot: 1, semester: "SS2024"}]->(l) WITH l,p CREATE (e:Exam {number: 1, date: '30.06.2024'}), (e)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e);
MATCH (l:Lecture {title: "Punctuality"}) with l MATCH (p:Professor)-[:TEACHES{slot: 1, semester: "WS2023"}]->(l) WITH l,p CREATE (e:Exam {number: 1, date: '07.02.2024'}), (e)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e);
MATCH (l:Lecture {title: "Punctuality"}) with l MATCH (p:Professor)-[:TEACHES{slot: 1, semester: "SS2023"}]->(l) WITH l,p CREATE (e:Exam {number: 1, date: '07.07.2023'}), (e)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e);
MATCH (l:Lecture {title: "Punctuality"}) with l MATCH (p:Professor)-[:TEACHES{slot: 1, semester: "WS2022"}]->(l) WITH l,p CREATE (e:Exam {number: 1, date: '28.01.2023'}), (e)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e);
//Advanced Social Economics
MATCH (l:Lecture {title: "Advanced Social Economics"}) with l MATCH (p:Professor)-[:TEACHES{slot: 1, semester: "SS2024"}]->(l) WITH l,p CREATE (e:Exam {number: 1, date: '28.05.2024'}), (e)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e), (e1:Exam {number: 2, date: '16.04.2024'}), (e1)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e1), (e2:Exam {number: 3, date: '23.09.2024'}), (e2)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e2);
MATCH (l:Lecture {title: "Advanced Social Economics"}) with l MATCH (p:Professor)-[:TEACHES{slot: 1, semester: "SS2023"}]->(l) WITH l,p CREATE (e:Exam {number: 1, date: '17.05.2023'}), (e)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e);
// Electromagic
//Does not have an Exam as it is a UE
// PC Internals
MATCH (l:Lecture {title: "PC Internals"}) with l MATCH (p:Professor)-[:TEACHES{slot: 1, semester: "SS2024"}]->(l) WITH l,p CREATE (e1:Exam {number: 1, date: '24.06.2024'}), (e1)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e1), (e2:Exam {number: 2, date: '28.07.2024'}), (e2)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e2);
MATCH (l:Lecture {title: "PC Internals"}) with l MATCH (p:Professor)-[:TEACHES{slot: 1, semester: "SS2023"}]->(l) WITH l,p CREATE (e:Exam {number: 1, date: '16.06.2023'}), (e)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e), (e2:Exam {number: 2, date: '30.08.2023'}), (e2)-[:BELONGS_TO]->(l), (p)-[:SUPERVISES]->(e2);
// Complex Mathematics
//Does not have an Exam as it is a UE

// --- Inscribe students for courses ---
// Anton
MATCH (s:Student {name: "Anton"}) with s MATCH (l:Lecture {title: "Introduction to CS"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Anton"}) with s MATCH (l:Lecture {title: "Electromagic"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Anton"}) with s MATCH (l:Lecture {title: "PC Internals"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
// Berta
MATCH (s:Student {name: "Berta"}) with s MATCH (l:Lecture {title: "Introduction to CS"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Berta"}) with s MATCH (l:Lecture {title: "Electromagic"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Berta"}) with s MATCH (l:Lecture {title: "PC Internals"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Berta"}) with s MATCH (l:Lecture {title: "Complex Mathematics"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Berta"}) with s MATCH (l:Lecture {title: "Punctuality"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
// Caesar
MATCH (s:Student {name: "Caesar"}) with s MATCH (l:Lecture {title: "PC Internals"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Caesar"}) with s MATCH (l:Lecture {title: "Complex Mathematics"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Caesar"}) with s MATCH (l:Lecture {title: "Punctuality"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
// Dora
MATCH (s:Student {name: "Dora"}) with s MATCH (l:Lecture {title: "Introduction to CS"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Dora"}) with s MATCH (l:Lecture {title: "Complex Mathematics"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Dora"}) with s MATCH (l:Lecture {title: "Advanced Social Economics"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
// Emil
MATCH (s:Student {name: "Emil"}) with s MATCH (l:Lecture {title: "Introduction to CS"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Emil"}) with s MATCH (l:Lecture {title: "Punctuality"}) with s,l CREATE (s)-[:INSCRIBED]->(l);
MATCH (s:Student {name: "Emil"}) with s MATCH (l:Lecture {title: "Electromagic"}) with s,l CREATE (s)-[:INSCRIBED]->(l);

// --- Register students for exams ---
// Anton
MATCH (s:Student {name: "Anton"}) with s MATCH(e:Exam {date: "30.01.2023"})-[:BELONGS_TO]->(:Lecture{title: "Introduction to CS"}) with s, e CREATE (s)-[:REGISTERED]->(e);
MATCH (s:Student {name: "Anton"}) with s MATCH(e:Exam {date: "30.08.2023"})-[:BELONGS_TO]->(:Lecture{title: "PC Internals"}) with s, e CREATE (s)-[:REGISTERED]->(e);
// Berta
MATCH (s:Student {name: "Berta"}) with s MATCH(e:Exam {date: "30.06.2024"})-[:BELONGS_TO]->(:Lecture{title: "Punctuality"}) with s, e CREATE (s)-[:REGISTERED]->(e);
MATCH (s:Student {name: "Berta"}) with s MATCH(e:Exam {date: "16.06.2023"})-[:BELONGS_TO]->(:Lecture{title: "PC Internals"}) with s, e CREATE (s)-[:REGISTERED]->(e);
// Caesar
MATCH (s:Student {name: "Caesar"}) with s MATCH(e:Exam {date: "28.01.2023"})-[:BELONGS_TO]->(:Lecture{title: "Punctuality"}) with s, e CREATE (s)-[:REGISTERED]->(e);
// Dora
MATCH (s:Student {name: "Dora"}) with s MATCH(e:Exam {date: "28.05.2024"})-[:BELONGS_TO]->(:Lecture{title: "Advanced Social Economics"}) with s, e CREATE (s)-[:REGISTERED]->(e);
MATCH (s:Student {name: "Dora"}) with s MATCH(e:Exam {date: "23.09.2024"})-[:BELONGS_TO]->(:Lecture{title: "Advanced Social Economics"}) with s, e CREATE (s)-[:REGISTERED]->(e);
MATCH (s:Student {name: "Dora"}) with s MATCH(e:Exam {date: "01.02.2024"})-[:BELONGS_TO]->(:Lecture{title: "Introduction to CS"}) with s, e CREATE (s)-[:REGISTERED]->(e);
// Emil
MATCH (s:Student {name: "Emil"}) with s MATCH(e:Exam {date: "16.04.2024"})-[:BELONGS_TO]->(:Lecture{title: "Advanced Social Economics"}) with s, e CREATE (s)-[:REGISTERED]->(e);
MATCH (s:Student {name: "Emil"}) with s MATCH(e:Exam {date: "07.02.2024"})-[:BELONGS_TO]->(:Lecture{title: "Punctuality"}) with s, e CREATE (s)-[:REGISTERED]->(e);
 
// --- Attach grades for courses (via exam) to student ---
// Anton
MATCH (s:Student {name: "Anton"}) with s MATCH(e:Exam {date: "30.01.2023"})-[:BELONGS_TO]->(:Lecture{title: "Introduction to CS"}) with s, e CREATE (e)-[:GRADED{grade: 2}]->(s);
MATCH (s:Student {name: "Anton"}) with s MATCH(e:Exam {date: "30.08.2023"})-[:BELONGS_TO]->(:Lecture{title: "PC Internals"}) with s, e CREATE (e)-[:GRADED{grade: 1}]->(s);
// Berta
// Does not have a grade yet for Punctuality (the irony), does not attempt one course Berta is registered for
MATCH (s:Student {name: "Berta"}) with s MATCH(e:Exam {date: "16.06.2023"})-[:BELONGS_TO]->(:Lecture{title: "PC Internals"}) with s, e CREATE (e)-[:GRADED{grade: 4}]->(s);
// Caesar
// Gets a result from an exam no registered for 
MATCH (s:Student {name: "Caesar"}) with s MATCH(e:Exam {date: "28.01.2023"})-[:BELONGS_TO]->(:Lecture{title: "Punctuality"}) with s, e CREATE (e)-[:GRADED{grade: 1}]->(s);
MATCH (s:Student {name: "Caesar"}) with s MATCH(e:Exam {date: "03.03.2024"})-[:BELONGS_TO]->(:Lecture{title: "Introduction to CS"}) with s, e CREATE (e)-[:GRADED{grade: 4}]->(s);
// Dora
// Multiple Attempts for Advanced Social Economics, first was a fail
MATCH (s:Student {name: "Dora"}) with s MATCH(e:Exam {date: "28.05.2024"})-[:BELONGS_TO]->(:Lecture{title: "Advanced Social Economics"}) with s, e CREATE (e)-[:GRADED{grade: 5}]->(s);
MATCH (s:Student {name: "Dora"}) with s MATCH(e:Exam {date: "23.09.2024"})-[:BELONGS_TO]->(:Lecture{title: "Advanced Social Economics"}) with s, e CREATE (e)-[:GRADED{grade: 2}]->(s);
MATCH (s:Student {name: "Dora"}) with s MATCH(e:Exam {date: "01.02.2024"})-[:BELONGS_TO]->(:Lecture{title: "Introduction to CS"}) with s, e CREATE (e)-[:GRADED{grade: 3}]->(s);
// Emil
// Registered for an exam where not registered for course
MATCH (s:Student {name: "Emil"}) with s MATCH(e:Exam {date: "16.04.2024"})-[:BELONGS_TO]->(:Lecture{title: "Advanced Social Economics"}) with s, e CREATE (e)-[:GRADED{grade: 1}]->(s);
MATCH (s:Student {name: "Emil"}) with s MATCH(e:Exam {date: "07.02.2024"})-[:BELONGS_TO]->(:Lecture{title: "Punctuality"}) with s, e CREATE (e)-[:GRADED{grade: 4}]->(s);