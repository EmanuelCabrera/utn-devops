use devops_app;
create table welcome (id int not null AUTO_INCREMENT, description varchar(255) not null, PRIMARY KEY (id));
insert into welcome (description) values ('Curso devOps'),('UTN-BA'),('Grupo nro 6');
