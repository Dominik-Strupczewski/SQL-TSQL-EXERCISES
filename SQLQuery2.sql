--wprowadzenie
CREATE TABLE t
(id int ,
nazwa varchar(20))

insert into t values
(1 , 'styczen' ) ,
(2, 'luty')

--zmiany nazwy kolumny tabeli

exec sp_rename 't.nazwa' , 'miesiac', 'column'

--zmiana nazwy tabeli
sp_rename 't' , 'tab'

--tworzenie kopii tabelii
select * into kopia from tab
select * from kopia

--zmiana typu danych w tabeli
alter table kopia alter column miesiac char(100)

--dodawanie nowej kolumny do tabeli
alter table kopia add k2 numeric(3)

select * from kopia

--usuwanie kolumny
alter table kopia drop column k2

--dodawanie indeksu przypisuj�cego wyszukiwanie

create index tab_index on tab(miesiac)
sp_helpindex tab

--usuwanie indexu
drop index tab_index on tab

drop table tab
drop table kopia

-- ID powinna automatycznie zwi�ksza� warto�� w momencie wprowadzania kolejnych wierszy do tabeli. Pozosta�e kolumny musz� by� w�a�ciwego dla nich typu oraz zastosowane powinny zosta� odpowiednie klucze.


--3. Na podstawie tabeli o nazwie Pracownicy, utworzy� jej dok�adn� kopi� o nazwie Studenci, kopiuj�c definicj� oraz zawarto�� tej tabeli dla os�b maj�cych mniej ni� 25 lat,
--jednocze�nie zmieniaj�c nazw� kolumny idpracownika na idstudenta. Wy�wietli� zawarto�� tabeli Studenci.

create table Pracownicy
(id_pracownika numeric(3) identity(1,1) primary key ,
imie varchar(20) ,
nazwisko varchar(20),
wiek numeric(3),
dzial varchar(5))

insert into Pracownicy values
('Jan' ,'Nowak' ,27 ,'INF') ,
('Adam' , 'Kowalski' , 26 , 'MAN') ,
('Anna' ,'Nowak' ,24 , 'MG' ),
('Ewa' , 'Kowalska' , 23 , 'ACC' )
select * from Pracownicy


--2. Na podstawie tabeli o nazwie Pracownicy, utworzy� jej kopi� o nazwie Uzytkownicy, kopiuj�c ca�� tabel� za wyj�tkiem kolumny Dzia� i zmieniaj�c nazw� kolumny  idpracownika na iduzytkownika.
--Wy�wietli� zawarto�� tabeli Uzytkownicy.

select id_pracownika as id_uzytkownika, imie , nazwisko , wiek into uzytkownicy from Pracownicy

--3. Na podstawie tabeli o nazwie Pracownicy, utworzy� jej dok�adn� kopi� o nazwie Studenci, kopiuj�c definicj� oraz zawarto�� tej tabeli dla os�b maj�cych mniej ni� 25 lat,
--jednocze�nie zmieniaj�c nazw� kolumny idpracownika na idstudenta. Wy�wietli� zawarto�� tabeli Studenci.

select id_pracownika as id_studenta , imie  , nazwisko , wiek , dzial into Studenci from Pracownicy where wiek<25

select * from Studenci

--4. W tabeli Uzytkownicy usun�� wiersze dla os�b, kt�re maj� mniej ni� 25 lat i nazwisko rozpoczynaj�ce si� od litery K. Zweryfikowa� poprawno��.

delete from uzytkownicy where wiek <25 and nazwisko like 'K%'

--5. Usun�� tabel� Uzytkownicy i Studenci.

drop table uzytkownicy
drop table  studenci

--6. Utworzy� now� tabel� o nazwie Region wed�ug poni�szych danych.

create table region
( id_regionu numeric(5) primary key,
nazwa varchar(30) ,
id_pracownika numeric(3)  foreign key (id_pracownika) references Pracownicy(id_pracownika)  )

insert into region values
( 4 , 'pomorskie' , 4 ) ,
( 2 , 'zachondiopomorskie', 2),
(3 , ' warminsko-mazurskie' , 3 )

select * from region


/*7. Utworzy� tabel� o nazwie Osoba, zawieraj�c� nast�puj�ce pola:

id (klucz g��wny bez autonumeracji)

imi�

nazwisko

pesel (warto�ci unikalne, tj. bez powt�rze�)

data urodzenia

wype�niaj�c j� nast�puj�cymi warto�ciami: */

create table Osoba
(id_osoby numeric(5) primary key ,
imie varchar(30),
nazwisko varchar(30),
pesel numeric(11) unique,
data_urodzenia date )

insert into Osoba values
(1  , 'Jan' , 'Kowalski' , 65121812434 , '1965-12-18' )

insert into Osoba values
(3, 'Ewa' , '  Zielinska' , 88111238273 , '1954-05-23' ),
(2 ,'Anna' , '  Nowak', 54052314588 , ' 1954-05-23' ) ,
(4 , 'Anna' , ' Wo�niak' ,  92012013721 , '1992-01-20')




--8. Zmieni� nazw� tabeli Osoba na Pracownik.

/*9. Doda� do tabeli Pracownik nast�puj�ce kolumny:

dzial

wyksztalcenie

 */
 sp_rename 'Osoba' , 'Pracownik' 
alter table Pracownik add dzial varchar(30) not null default 'Organizacyjny'
alter table Pracownik add wyksztalcenie varchar(30)

select* from Pracownik

--Wy�wietli� dane. Nast�pnie ustawi� wszystkim pracownikom dzia� "Organizacyjny", a pracownikom o id mniejszym ni� 3, wykszta�cenie wy�sze.

update pracownik set wyksztalcenie='wyzsze' where id_osoby<3

select* from pracownik






--10. Skopiowa� zawarto�� tabeli Pracownik do tabeli Pracownik_kopia.

select * into pracownik_kopia from pracownik
select * from pracownik_kopia

sp_helpindex pracownik
sp_helpindex pracownik_kopia


--11. Usun�� z tabeli Pracownik_kopia kolumn� o nazwie pesel.

alter table pracownik drop column pesel

--12. W tabeli Pracownik_kopia zmieni� kolumn� nazwisko tak, aby pozwala�a na wprowadzenie 40 znak�w.

alter table pracownik alter column nazwisko char(40)  

--13. W tabeli Pracownik_kopia zmieni� nazw� kolumny id na id_pracownika.

sp_rename 'Pracownik_kopia.id_osoby' , 'id' , 'column'

select * from pracownik_kopia

--14. Utworzy� indeks do tabeli Pracownik, indeksuj�cy nazwisko i imi�. Sprawdzi� dzia�anie.

create index imie_nazwisko_index on pracownik(imie, nazwisko )
sp_helpindex pracownik

--15. Usun�� indeks z tabeli Pracownik.

drop index imie_nazwisko_index on pracownik


--LAB 2 wprowadzenie
create table w
(id int ,
liczba numeric(3) ,
nazwa varchar (20))

insert into w values
(1,10,'A' ) ,
(2,20, 'B') ,
(3,25,'C') ,
(4,40, 'D') ,
(5,50,'E') ,
(6,65,'F')

select * from w

with zapytanie as
(
select case
when liczba <15 then 'mniej ni� 15'
when liczba between 15 and 40 then '15-40'
else 'powyzej 40 '
end as kategoria, nazwa , liczba
from w )
select kategoria, sum(liczba) as suma , count(*) as liczba_wystapien
from zapytanie
group by kategoria






---------------------------------------------------------------
create table JednostkaMiary

([id jednostki miary] int primary key,

[nazwa jednostki miary] varchar(20),

[symbol jednostki miary] varchar(20),

mnoznik numeric(2))


insert into JednostkaMiary values

(1,'sztuka','szt.',1),

(2,'kilogram','kg',1),

(3,'litr','l.',1)


create table GrupaProduktu 

([id grupy produktu] int primary key,

[nazwa grupy] varchar(20),

[nazwa kategorii] varchar(20))


insert into GrupaProduktu values

(1,'pieczywo','�ywno��'),

(2,'napoje','�ywno��'),

(3,'obuwie','odzie�'),

(4,'kurtki','odzie�')


/*3. Utworzy� tabel� o nazwie Produkt zawieraj�c� 4 kolumny (nada� samodzielnie nazwy kolumn i typy danych):
- id produktu - klucz g��wny
- nazwa produktu - tekst
- id grupy produktu - klucz obcy
- id jednostki miary - klucz obcy
i doda� dowolne 5 produkt�w, zgodnych z powy�szymi kategoriami.*/

create table produkt
( idproduktu numeric(3) primary key,
nazwa_produktu varchar(20) ,
[id grupy produktu] int foreign key ([id grupy produktu]) references GrupaProduktu([id grupy produktu]),
[id jednostki miary] int foreign key ([id jednostki miary]) references JednostkaMiary ([id jednostki miary]) )



select * from GrupaProduktu
select * from JednostkaMiary

insert into Produkt values
( 1 , ' ciasto' ,1 ,1) ,
(2, 'chleb' ,1 ,1 ) ,
( 3 , 'sok pomaranczowy' , 2 ,3),
( 4, 'sok jablkowy' , 2 ,3) ,
(5 , 'sok pomidorowy' , 2 ,3)


select * from Produkt

/*4. Utworzy� tabel� o nazwie Sklep zawieraj�c� 3 kolumny (nada� samodzielnie nazwy kolumn i typy danych):
- id sklepu - klucz g��wny
- nazwa sklepu - tekst
- wojew�dztwo - tekst
i doda� 5 sklep�w.*/

create table Sklep
(idsklepu numeric(10) primary key,
nazwasklepu varchar(30),
wojewodztwo varchar(30))

insert into Sklep values
(1,'A' , 'pomorskie') ,
(2 , 'B' , ' pomorskie' ) ,
(3 , 'C' , 'pomorskie' ) ,
(4 , 'D' , 'zachodniopomorskie' ) ,
(5 , 'E' , 'zachodniopomorskie' )

-- zadanie 5
create table sprzedaz
(idsprzedazy int primary key identity(1,1), -- autonumeracja
idproduktu numeric(3) foreign key (idproduktu)
references produkt(idproduktu),
idsklepu numeric(10) foreign key (idsklepu)
references sklep(idsklepu),
datatransakcji datetime2,
ilosc numeric(5,1),
cena money)


insert into sprzedaz values
(1,1,getdate(),5,7),
(1,1,getdate(),5,8),
(1,1,getdate(),15,20),
(1,1,getdate(),20,22),
(2,1,getdate(),1,2),
(2,1,getdate(),3,8),
(2,1,getdate(),2,4.5),
(2,1,getdate(),3,12),
(1,1,getdate(),5,7),
(1,1,getdate(),5,8),
(1,1,getdate(),15,20),
(1,1,getdate(),20,22),
(3,1,getdate(),1,3),
(3,1,getdate(),3,9),
(3,1,getdate(),2,4.5),
(3,1,getdate(),3,12),
(4,1,getdate(),2,3),
(4,1,getdate(),3,6),
(4,1,getdate(),2,4),
(4,1,getdate(),3,12),
(5,1,getdate(),1,2),
(5,1,getdate(),2,8),
(5,1,getdate(),2,4.5),
(5,1,getdate(),3,12)



insert into sprzedaz values
(1,2,getdate(),5,8),
(1,2,getdate(),5,9),
(1,2,getdate(),15,21),
(1,2,getdate(),20,23),
(2,2,getdate(),1,3),
(2,2,getdate(),3,9),
(2,2,getdate(),2,5.5),
(2,2,getdate(),3,13)

select * from sprzedaz

--6. Wy�wietli� wszystkie informacje o sprzedanych produktach w kolumnach idproduktu, nazwa, cena, ilosc (nie wy�wietla� innych kolumn).

select sp.idproduktu , p.nazwa_produktu , sp.cena , sp.ilosc
from sprzedaz sp inner join produkt p
on sp.idproduktu=p.idproduktu

--7. Wy�wietli� wszystkie niesprzedane produkty.

select * from produkt
where idproduktu not in
(select idproduktu from Sprzedaz )


--8. Zmieni� kategori� produkt�w wed�ug ceny jednostkowej oferowanej za sprzeda� (cena/ilosc) -
--produkty kosztuj�ce do 2 z�/jednostk� powinny nazywa� si� "do 2 z�", od 2 do 5 z� "2-5 z�", 
--a pozosta�e "powy�ej 5 z�". Nast�pnie nale�y pogrupowa� te produkty tworz�c raport zawieraj�cy informacj� o nazwie sklepu,
--nazwie produktu oraz wyliczonej kategorii.

with zapytanie  
as 
(select 
idproduktu , 
case 
when cena/ilosc < 2 then 'do 2 z�' 
when cena/ilosc between 2 and 5 then '2-5' 
else 
'powyzej 5 zl ' 
end as 'kategoria'
from sprzedaz ) 
select distinct p.nazwa_produktu , s.nazwasklepu ,z.kategoria 
from produkt p, sklep s, zapytanie z, sprzedaz sp 
where sp.idproduktu=p.idproduktu 
and s.idsklepu=sp.idsklepu
and p.idproduktu=z.idproduktu 



--9. Doda� now� kolumn� o nazwie nowa_kategoria dla produkt�w.

Alter table produkt add nowa_kategoria varchar(30) 

select * from produkt 

--10. Uzupe�ni� now� kategori� produkt�w przypisuj�c jej kategorie z zapytania 8.


with zapytanie  
as 
(select 
idproduktu , 
case 
when cena/ilosc < 2 then 'do 2 z�' 
when cena/ilosc between 2 and 5 then '2-5' 
else 
'powyzej 5 zl ' 
end as 'kategoria'
from sprzedaz ) 
select distinct nazwa_produktu , nazwasklepu , kategoria 
into zadanie8
from produkt p, sklep s, zapytanie z, sprzedaz sp 
where sp.idproduktu=p.idproduktu 
and s.idsklepu=sp.idsklepu
and p.idproduktu=z.idproduktu 

select * from zadanie8

select idproduktu, p.nazwa_produktu, z.kategoria 
from zadanie8 z , produkt p 
where z.nazwa_produktu=p.nazwa_produktu 

select * from produkt

update produkt set nowa_kategoria=z.kategoria
from zadanie8 z , produkt p 
where z.nazwa_produktu=p.nazwa_produktu

select * from produkt 

--11. Wy�wietli� wszystkie produkty, dodatkowo je�eli zosta�y sprzedane to nale�y wy�wietli� sprzedan� ��czn� ilo�� oraz cen� uzyskan�.

select p.* , sum(ilosc) as ' ��czna ilosc' , sum(cena) as '��czna cena' 
from produkt p left join sprzedaz s 
on p.idproduktu=s.idproduktu
group by p.idproduktu , nazwa_produktu, [id grupy produktu] ,
[id jednostki miary] , nowa_kategoria 

--12. Utworzy� ranking najlepszych sklep�w wed�ug ��cznej kwoty uzyskanej ze sprzeda�y produkt�w i zapisa� go w tabeli Raport1.

select sum(cena) as '��czna cena' 
into Raport1 
from sklep s ,sprzedaz sp 
where s.idsklepu=sp.idsklepu 
group by s.nazwasklepu 
order by 1 desc  

select * from Raport1

--13. Utworzy� raport pozwalaj�cy na przegl�danie informacji o sprzedanych produktach (cena, ilo��, produkt) w nowej tabeli o nazwie 
--Raport2.

select sp.cena , sp.ilosc , p.nazwa_produktu
into Raport2 
from sprzedaz sp , produkt p 
where p.idproduktu=sp.idproduktu




-----------------------------------------------------------------------------<<<<<<<<<<<<<<>>>>>>>>>>>>>---------------------------------------------------

-1. Zadeklarowa� dwie zmienne tekstowe: imie i nazwisko oraz jedn� zmienn� liczbow� o nazwie numer porz�dkowy. Przypisa� warto�ci zmiennym:
--Jan, Kowalski, 100
--i wy�wietli� je.

declare		
@imie varchar(20) , 
@nazwisko varchar(30) , 
@numer_porzadkowy int 

begin
	set @imie='Jan'
	set @nazwisko='Kowalski' 
	set @numer_porzadkowy=100 
	print @imie+ ' ' + @nazwisko + ' ' + cast(@numer_porzadkowy as varchar(5)) 
end 
go

--2. Napisa� program, kt�ry z wykorzystaniem instrukcji EXEC policzy liczb� wierszy w dowolnej tabeli, 
--a nast�pnie utworzy tabel� o nazwie Raport3 wstawiaj�c liczb� wcze�niej wyliczonych wierszy. 
--Zapytania musz� by� przechowywane w zmiennych tekstowych.

select count(*) as 'liczba' 
into Raport3 
from produkt 

begin 
	set @zapytanie varchar(max) 
	set @zapytanie ='select count(*) as ''liczba'' into Raport3  from produkt ' 
	exec(@zapytanie) 
end

select * from Raport3

--3. Napisa� program, kt�ry wy�wietli wszystkie parzyste liczby z zakresu od 1 do 10. 
--Dodatkowo po wykonaniu kodu nale�y wstrzyma� program na 2 sekundy przed wy�wietleniem danych.

declare @liczba as INT = 1 ; 
while @liczba <=10 
begin 
if @liczba % 2 = 0 
print 'liczab to: ' + CAST(@liczba  as Varchar) ; 
set @liczba = @liczba +1 ; 
end 
waitfor delay '00:00:02' 
go
--4. Napisa� program, kt�ry wy�wietli wszystkie liczby z zakresu od 1 do 10. 
--Je�eli liczba jest podzielna przez 3 to wypisze stosown� informacj�.

declare @liczba as INT = 1 ; 
while @liczba <=10 
begin 
if @liczba % 3 = 0 
print 'liczab podzielna przez 3 to : ' + CAST(@liczba  as Varchar) ; 
set @liczba = @liczba +1 ; 
end 
go 

--5. Wygenerowa� tabel� o nazwie Dane, kt�ra b�dzie zawiera�a dwie kolumny: opis oraz warto��.
--W tabeli powinny by� zamieszczone opisy: A, B, C, D i E oraz przyporz�dkowane im liczby z zakresu od 1 do 100. 
--Nale�y wype�ni� 2000 wierszy tablicy. Je�eli kolejny dodawany wiersz jest podzielny przez 5
--to powinien otrzyma� opis E, przez 4: D, przez 3: C,
--przez 2: B oraz przez 1: A. Podpowied�: funkcja RAND() s�u�y do generowania liczby losowej zmiennoprzecinkowej z zakresu od 0 do 1.




declare 
@tworzenietabeli varchar(100) , -- zapytanie tworzace tabele 
@wstawianiewierszy varchar(100),  -- zapyutanie wstawiajace wiersze 
@liczba numeric (3) , --generowanie liczb losowych 
@licznik numeric(5) , -- do p�tli 
@opis varchar(1) --kategoria od A do E 
begin 
	set @tworzenietabeli ='create table Dane ( opis varchar(1), wartosc numeric(3) ) ' 
	select @licznik = 1 
	exec(@tworzenietabeli) 
	while @licznik<=10
	begin
		select @liczba=rand()*99+1 
		if @liczba % 5 = 0 set @opis='E' 
		else if @liczba %4 = 0 set @opis= 'D' 
		else if @liczba %3 = 0 set @opis= ' C' 
		else if @liczba % 2 = 0 set @opis = ' B' 
		else set @opis= 'A'  
		--print ' insert into Dane values (''' +@opis+''', '+CAST(@liczba as varchar(3)) +')' 
		set @wstawianiewierszy = ' insert into Dane values (''' +@opis+''', '+CAST(@liczba as varchar(3)) +')'
		exec(@wstawianiewierszy) 
		set @licznik +=1
	end
end
	
	select * from Dane 
	

	 
 

--6. Wy�wietli� utworzon� wcze�niej tabel� wypisuj�c w trzech kolumnach nast�puj�ce warto�ci:
--Klasa wielko�ci
--Opis 
--��czna warto��  
--gdzie:
--- klasa wielko�ci ma reprezentowa� przedzia�y:
--ma�e: 1 do 30
--�rednie: 31 do 70
--du�e: 71 do 100
--- ��czna warto�� to funkcja agreguj�ca SUM
--Wyniki maj� by� koniecznie pogrupowane wed�ug klas wielko�ci i opisu.

with zapytanie
as
(select 
case
when wartosc between 1 and 30 then 'ma�e'
when wartosc between 31 and 70 then '�rednie' 
else 'du�e ' 
end as klasa_wielkosci , wartosc , opis 
from Dane) 
select klasa_wielkosci , sum(wartosc) as '��czna warto�c' , opis 
from zapytanie 
group by klasa_wielkosci , opis 




-----------------------------------------------------------<<<<<<<<<<<<        PROCEDURY I FUNKCJE           >>>>>>>>>>>>>>------------------------------------------

--1. Nale�y utworzy� tablic� o nazwie TabLiczba, zawieraj�c� kolumny:

--- identyfikator (autonumeracja),

--- liczba typu liczbowego ca�kowitego (co najmniej z zakresu 0 do 1000),

--- slownie typu tekstowego.

 

--Doda� do tabeli trzy wiersze (liczba, slownie):

--1 jeden

--2 dwa

--3 trzy

 

CREATE TABLE TabLiczba(id int identity(1,1), liczba numeric(4,0), slownie varchar(100));

INSERT INTO TabLiczba(liczba, slownie) VALUES (1,'jeden');

INSERT INTO TabLiczba(liczba, slownie) VALUES (2,'dwa');

INSERT INTO TabLiczba(liczba, slownie) VALUES (3,'trzy');



--2. Utworzy� procedur� o nazwie wyswietlDane, kt�ra wy�wietli wszystkie wiersze z tabeli o nazwie Liczba. 
--Zweryfikowa� dzia�anie procedury.

select * from  TabLiczba 

create procedure wyswietlDane  -- jesli zmienic procedure trzeba dodac alter 
as
(select * from  TabLiczba)


execute wyswietlDane --exec wyswietlDane - to samo 

--3. Utworzy� procedur� o nazwie dodajLiczbe, kt�ra przyjmuje dwa argumenty - 
--liczb� oraz jej reprezentacj� s�own� i dodaje te argumenty jako kolejny wiersz tabeli TabLiczba.

insert into TabLiczba values (4, 'cztery')


go
create procedure dodajLiczbe
@Numer numeric(4),
@Sl varchar(20)
as
begin 
	insert into TabLiczba(liczba,slownie)
	values(@Numer,@Sl)
end


(
--4. Doda� liczby od 4 do 10 wykorzystuj�c procedur� dodajLiczbe.

--Podpowied�:

exec dodajLiczbe @Numer=4, @Sl='cztery';
 
exec dodajLiczbe @Numer=5, @Sl='pi��';

exec dodajLiczbe @Numer=6, @Sl='sze��';
 
exec dodajLiczbe @Numer=7, @Sl='siedem';
 
exec dodajLiczbe @Numer=8, @Sl='osiem';
 
exec dodajLiczbe @Numer=9, @Sl='dziewi��';

exec dodajLiczbe @Numer=10, @Sl='dziesi��';

select * from TabLiczba

--5. Utworzy� procedur� o nazwie procLiczbaSlownie, kt�ra za argument przyjmuje warto�� liczbow�
--i wy�wietla reprezentacj� s�own� tej liczby na podstawie danych z tabeli o nazwie TabLiczba.
--Zweryfikowa� dzia�anie procedury.

select slownie from TabLiczba where liczba = 4 

create proc procLiczbaSlownie 
@liczba int 
as
(select slownie from TabLiczba where liczba = @liczba) 
 go

 exec procLiczbaSlownie @liczba=5

--6. Utworzy� funkcj� o nazwie funkcjaLiczbaSlownie, kt�ra za argument przyjmuje warto�� liczbow� i 
--zwraca reprezentacj� s�own� tej liczby w postaci tabeli, na podstawie danych z tabeli o nazwie TabLiczba. Zweryfikowa� dzia�anie.

go
create function funkcjaLiczbaSlownie(@liczba numeric(4))
returns table 
as return
(select slownie from TabLiczba where liczba = @liczba)

select * from funkcjaLiczbaSlownie(5) -- czasami trzeba dbo.funkcjaLiczbaSlownie 

--7. Napisa� funkcj� o nazwie LiczbaWierszy, kt�ra zwr�ci liczb� wierszy zapisanych w tabeli o nazwie TabLiczba.

select COUNT(*) from TabLiczba


create function LiczbaWierszy() 
returns int
as
begin
	declare @liczba int 
	select @liczba= COUNT(*) from TabLiczba
	return @liczba 
end

select dbo.LiczbaWierszy()
--8. Utworzy� procedur� o nazwie dodajTylkoLiczbe, kt�ra za argument przyjmuje warto�� liczbow�.
--Przed dodaniem liczby ma zosta� sprawdzona, czy warto�� argumentu jest z zakresu 20 do 99.
--Je�eli warunek ten zostanie spe�niony powinna zosta� dodana liczba wraz ze s�own� reprezentacj� np.
--dwadzie�cia trzy. Cz�� opisu powinna by� pobierana z opisu liczb od 1 do 9. Doda� kilka liczb z zakresu od 20 do 99.

go 
create procedure dodajTylkoLiczbe
@argument1 numeric(4) 
as 
begin
	declare 
	@sl varchar(50)
	if @argument1>=20 and @argument1<=99
	begin 
			if @argument1>=20 and @argument1<=29 begin	set @sl='Dwadzeiscia' end
			if @argument1>=30 and @argument1<=39 begin	set @sl= 'Trzydziesci' end
			if @argument1>=40 and @argument1<=49 begin	set @sl='Czterdziesci' end
			if @argument1>=50 and @argument1<=59 begin	set @sl='Piecdziesiat' end
			if @argument1>=60 and @argument1<=69 begin	set @sl='Szescdziesiat' end
			if @argument1>=70 and @argument1<=79 begin	set @sl='Siedemdziesiat' end
			if @argument1>=80 and @argument1<=89 begin	set @sl='Osiemdziesiat' end
			if @argument1>=90 and @argument1<=99 begin	set @sl='Dziewiecdziesiat' end
			select @sl=@sl+ ' ' + slownie 
			from TabLiczba where liczba=(@argument1%10)
			print 'Dodano ' +  @sl
			insert into TabLiczba(liczba,slownie)
			values(@argument1,@sl)
	end
end


exec dodajTylkoLiczbe @argument1= 34
--9. Napisa� procedur� o nazwie DodajLiczby, kt�ra doda wszystkie liczby z okre�lonego 
--zakresu u�ywaj�c w tym celu procedury o nazwie dodajTylkoLiczbe. Wywo�a� procedur� dla zakresu od 20 do 99.
go
create proc DodajLiczby 
@min int , 
@max int 
as 
begin
	while(@min<=@max) 
	begin
		execute dodajTylkoLiczbe @min 
		set @min+=1
	end
end


--10. Napisa� funkcj� o nazwie WyswietlDuplikatyLiczb, kt�ra w postaci tabeli z kolumnami liczba oraz liczba_wystapien,
--zwr�ci list� wszystkich duplikat�w liczb, jakie wyst�puj� w tabeli. Przetestowa� dzia�anie.
go
create function WyswietlDuplikatyLiczb()
		returns table 
		as return 
		( select liczba, COUNT(*) as liczba_wystapien
	from TabLiczba
	group by liczba 
	having COUNT(*)>1 
	)


	select* from dbo.WyswietlDuplikatyLiczb()

--11. Napisa� procedur� UsunLiczbe, usuwaj�c� liczb� podan� jako argument wywo�ania procedury. Przetestowa� dzia�anie.

go
create proc UsunLiczbe 
@liczba int 
as
begin
delete from TabLiczba where liczba =@liczba
end

exec UsunLiczbe @liczba=34

 SELECT definition, type
 FROM sys.sql_modules AS m
 JOIN sys.objects AS o ON m.object_id = o.object_id
 AND type IN ('FN', 'IF', 'TF');
GO

drop function funkcjaLiczbaSlownie
drop function WyswietlDuplikatyLiczb
drop function LiczbaWierszy
drop procedure DodajLiczby
drop procedure dodajTylkoLiczbe


---------------------------------<<<<<<<<<<<           WYZWALACZE I WYJ�TKI        >>>>>>>>>>>>>>-----------------------------------------


--1. Utworzy� tabel� o nazwie Osoba1 zawieraj�ca 5 kolumn:

--identyfikator - liczba sze�ciocyfrowa, autonumeracja od 100000 co 10

--imie - tekst 30 znak�w

--nazwisko - tekst 50 znak�w

--wiek - liczba trzycyfrowa

--data_dodania - data, domy�lnie ma by� wstawiana dzisiejsza data

 

create table osoba1(id numeric(6) primary key identity(100000,10),

imie varchar(30),

nazwisko varchar(50),

wiek numeric(3,0),

data_dodania date default getdate());

 

--2. Do tabeli Osoba doda� 4 wiersze:

--Jan Kowalski, 35 lat

--Anna Nowak, 30 lat

--Ewa Zieli�ska, 38 lat

--Adam Wo�niak, 32 lata

 

insert into osoba1(imie,nazwisko,wiek)

values

('Jan','Kowalski',35),

('Anna','Nowak',30),

('Ewa','Zieli�ska',38),

('Adam','Wo�niak',31);

 

 

--3. Utworzy� wyzwalacz o nazwie DodanoOsobe na tabeli o nazwie Osoba, 
--kt�ry b�dzie informowa� u�ytkownika, �e wiersz zosta� dodany. Doda� jeden wiersz do tabeli.

create trigger DodanoOsobe on Osoba1
for insert 
as 
begin
print ' Dodano now� osobe' 
end 

insert into osoba1(imie,nazwisko,wiek)
values
('Kazimierz','Kowalski',35)
	
--4. Usun�� wyzwalacz o nazwie DodanoOsobe.

drop trigger dodanoosobe 

--5. Utworzy� wyzwalacz o nazwie ModyfikujOsobe, kt�ry zablokuje mo�liwo�� modyfikacji wierszy w tabeli o nazwie Osoba.
--Wywo�ywanie instrukcji INSERT na tabeli osoba ma dodatkowo generowa� wyj�tek.

go
create trigger ModyfikujOsobe on Osoba1 
for update
as
begin
	rollback transaction
	raiserror('Osoby nie moga byc modyfikowane',1,1) 

end

update osoba1 set wiek=20 where imie= 'Anna' 

--6. Usun�� wyzwalacz o nazwie ModyfikujOsobe.
drop trigger ModyfikujOsobe 

--7. Utworzy� wyzwalacz o nazwie DodanoOsoby na tabeli o nazwie Osoba, kt�ry b�dzie wy�wietla� imi� i 
--nazwisko nowo dodawanej osoby (warto�ci). Przetestowa� dzia�anie.
go
create trigger  DodanoOsoby on osoba1 
after insert 
as
begin
	declare 
	@imie varchar(20) ,
	@nazwisko varchar (20) 
	set nocount on 
	select @imie = imie from osoba1 -- informacja z ostatniego wiersza w tabeli osoba 
	select @nazwisko = nazwisko from osoba1 
	print 'Imie ' + @imie+ ' nazwisko ' + @nazwisko 


end


insert into osoba1 ( imie ,nazwisko ,  wiek) values 
('Anna' , 'Kowalska', 30 ) 

--8. Usun�� wyzwalacz o nazwie DodanoOsoby.

drop trigger DodanoOsoby 

--9. Utworzy� wyzwalacz o nazwie SprawdzWiek, kt�ry zablokuje mo�liwo�� wprowadzenia osoby w wieku innymi ni� w przedziale 0-120 lat.
	go 
	create trigger SprawdzWiek on Osoba1 
	after insert 
	as
	declare 
	@wiek numeric (3)
	begin 
	select @wiek = wiek from osoba1 
	if @wiek <0 or @wiek >120 
	begin
	rollback transaction
	raiserror('Wiek nie znajduje sie w przedziale od 0 do 120 ',1, 1) 
	end

	end

--10. Doda� now� osob� w wieku 130 lat. Sprawdzi� zawarto�� tabeli.

insert into osoba1 ( imie ,nazwisko ,  wiek) values 
('Anna' , 'Kowalska', 130 ) 


--11. Usun�� wyzwalacz o nazwie SprawdzWiek.
drop trigger SprawdzWiek