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

--dodawanie indeksu przypisuj¹cego wyszukiwanie

create index tab_index on tab(miesiac)
sp_helpindex tab

--usuwanie indexu
drop index tab_index on tab

drop table tab
drop table kopia

-- ID powinna automatycznie zwiêkszaæ wartoœæ w momencie wprowadzania kolejnych wierszy do tabeli. Pozosta³e kolumny musz¹ byæ w³aœciwego dla nich typu oraz zastosowane powinny zostaæ odpowiednie klucze.


--3. Na podstawie tabeli o nazwie Pracownicy, utworzyæ jej dok³adn¹ kopiê o nazwie Studenci, kopiuj¹c definicjê oraz zawartoœæ tej tabeli dla osób maj¹cych mniej ni¿ 25 lat,
--jednoczeœnie zmieniaj¹c nazwê kolumny idpracownika na idstudenta. Wyœwietliæ zawartoœæ tabeli Studenci.

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


--2. Na podstawie tabeli o nazwie Pracownicy, utworzyæ jej kopiê o nazwie Uzytkownicy, kopiuj¹c ca³¹ tabelê za wyj¹tkiem kolumny Dzia³ i zmieniaj¹c nazwê kolumny  idpracownika na iduzytkownika.
--Wyœwietliæ zawartoœæ tabeli Uzytkownicy.

select id_pracownika as id_uzytkownika, imie , nazwisko , wiek into uzytkownicy from Pracownicy

--3. Na podstawie tabeli o nazwie Pracownicy, utworzyæ jej dok³adn¹ kopiê o nazwie Studenci, kopiuj¹c definicjê oraz zawartoœæ tej tabeli dla osób maj¹cych mniej ni¿ 25 lat,
--jednoczeœnie zmieniaj¹c nazwê kolumny idpracownika na idstudenta. Wyœwietliæ zawartoœæ tabeli Studenci.

select id_pracownika as id_studenta , imie  , nazwisko , wiek , dzial into Studenci from Pracownicy where wiek<25

select * from Studenci

--4. W tabeli Uzytkownicy usun¹æ wiersze dla osób, które maj¹ mniej ni¿ 25 lat i nazwisko rozpoczynaj¹ce siê od litery K. Zweryfikowaæ poprawnoœæ.

delete from uzytkownicy where wiek <25 and nazwisko like 'K%'

--5. Usun¹æ tabelê Uzytkownicy i Studenci.

drop table uzytkownicy
drop table  studenci

--6. Utworzyæ now¹ tabelê o nazwie Region wed³ug poni¿szych danych.

create table region
( id_regionu numeric(5) primary key,
nazwa varchar(30) ,
id_pracownika numeric(3)  foreign key (id_pracownika) references Pracownicy(id_pracownika)  )

insert into region values
( 4 , 'pomorskie' , 4 ) ,
( 2 , 'zachondiopomorskie', 2),
(3 , ' warminsko-mazurskie' , 3 )

select * from region


/*7. Utworzyæ tabelê o nazwie Osoba, zawieraj¹c¹ nastêpuj¹ce pola:

id (klucz g³ówny bez autonumeracji)

imiê

nazwisko

pesel (wartoœci unikalne, tj. bez powtórzeñ)

data urodzenia

wype³niaj¹c j¹ nastêpuj¹cymi wartoœciami: */

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
(4 , 'Anna' , ' WoŸniak' ,  92012013721 , '1992-01-20')




--8. Zmieniæ nazwê tabeli Osoba na Pracownik.

/*9. Dodaæ do tabeli Pracownik nastêpuj¹ce kolumny:

dzial

wyksztalcenie

 */
 sp_rename 'Osoba' , 'Pracownik' 
alter table Pracownik add dzial varchar(30) not null default 'Organizacyjny'
alter table Pracownik add wyksztalcenie varchar(30)

select* from Pracownik

--Wyœwietliæ dane. Nastêpnie ustawiæ wszystkim pracownikom dzia³ "Organizacyjny", a pracownikom o id mniejszym ni¿ 3, wykszta³cenie wy¿sze.

update pracownik set wyksztalcenie='wyzsze' where id_osoby<3

select* from pracownik






--10. Skopiowaæ zawartoœæ tabeli Pracownik do tabeli Pracownik_kopia.

select * into pracownik_kopia from pracownik
select * from pracownik_kopia

sp_helpindex pracownik
sp_helpindex pracownik_kopia


--11. Usun¹æ z tabeli Pracownik_kopia kolumnê o nazwie pesel.

alter table pracownik drop column pesel

--12. W tabeli Pracownik_kopia zmieniæ kolumnê nazwisko tak, aby pozwala³a na wprowadzenie 40 znaków.

alter table pracownik alter column nazwisko char(40)  

--13. W tabeli Pracownik_kopia zmieniæ nazwê kolumny id na id_pracownika.

sp_rename 'Pracownik_kopia.id_osoby' , 'id' , 'column'

select * from pracownik_kopia

--14. Utworzyæ indeks do tabeli Pracownik, indeksuj¹cy nazwisko i imiê. Sprawdziæ dzia³anie.

create index imie_nazwisko_index on pracownik(imie, nazwisko )
sp_helpindex pracownik

--15. Usun¹æ indeks z tabeli Pracownik.

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
when liczba <15 then 'mniej ni¿ 15'
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

(1,'pieczywo','¿ywnoœæ'),

(2,'napoje','¿ywnoœæ'),

(3,'obuwie','odzie¿'),

(4,'kurtki','odzie¿')


/*3. Utworzyæ tabelê o nazwie Produkt zawieraj¹c¹ 4 kolumny (nadaæ samodzielnie nazwy kolumn i typy danych):
- id produktu - klucz g³ówny
- nazwa produktu - tekst
- id grupy produktu - klucz obcy
- id jednostki miary - klucz obcy
i dodaæ dowolne 5 produktów, zgodnych z powy¿szymi kategoriami.*/

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

/*4. Utworzyæ tabelê o nazwie Sklep zawieraj¹c¹ 3 kolumny (nadaæ samodzielnie nazwy kolumn i typy danych):
- id sklepu - klucz g³ówny
- nazwa sklepu - tekst
- województwo - tekst
i dodaæ 5 sklepów.*/

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

--6. Wyœwietliæ wszystkie informacje o sprzedanych produktach w kolumnach idproduktu, nazwa, cena, ilosc (nie wyœwietlaæ innych kolumn).

select sp.idproduktu , p.nazwa_produktu , sp.cena , sp.ilosc
from sprzedaz sp inner join produkt p
on sp.idproduktu=p.idproduktu

--7. Wyœwietliæ wszystkie niesprzedane produkty.

select * from produkt
where idproduktu not in
(select idproduktu from Sprzedaz )


--8. Zmieniæ kategoriê produktów wed³ug ceny jednostkowej oferowanej za sprzeda¿ (cena/ilosc) -
--produkty kosztuj¹ce do 2 z³/jednostkê powinny nazywaæ siê "do 2 z³", od 2 do 5 z³ "2-5 z³", 
--a pozosta³e "powy¿ej 5 z³". Nastêpnie nale¿y pogrupowaæ te produkty tworz¹c raport zawieraj¹cy informacjê o nazwie sklepu,
--nazwie produktu oraz wyliczonej kategorii.

with zapytanie  
as 
(select 
idproduktu , 
case 
when cena/ilosc < 2 then 'do 2 z³' 
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



--9. Dodaæ now¹ kolumnê o nazwie nowa_kategoria dla produktów.

Alter table produkt add nowa_kategoria varchar(30) 

select * from produkt 

--10. Uzupe³niæ now¹ kategoriê produktów przypisuj¹c jej kategorie z zapytania 8.


with zapytanie  
as 
(select 
idproduktu , 
case 
when cena/ilosc < 2 then 'do 2 z³' 
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

--11. Wyœwietliæ wszystkie produkty, dodatkowo je¿eli zosta³y sprzedane to nale¿y wyœwietliæ sprzedan¹ ³¹czn¹ iloœæ oraz cenê uzyskan¹.

select p.* , sum(ilosc) as ' ³¹czna ilosc' , sum(cena) as '£¹czna cena' 
from produkt p left join sprzedaz s 
on p.idproduktu=s.idproduktu
group by p.idproduktu , nazwa_produktu, [id grupy produktu] ,
[id jednostki miary] , nowa_kategoria 

--12. Utworzyæ ranking najlepszych sklepów wed³ug ³¹cznej kwoty uzyskanej ze sprzeda¿y produktów i zapisaæ go w tabeli Raport1.

select sum(cena) as '³¹czna cena' 
into Raport1 
from sklep s ,sprzedaz sp 
where s.idsklepu=sp.idsklepu 
group by s.nazwasklepu 
order by 1 desc  

select * from Raport1

--13. Utworzyæ raport pozwalaj¹cy na przegl¹danie informacji o sprzedanych produktach (cena, iloœæ, produkt) w nowej tabeli o nazwie 
--Raport2.

select sp.cena , sp.ilosc , p.nazwa_produktu
into Raport2 
from sprzedaz sp , produkt p 
where p.idproduktu=sp.idproduktu




-----------------------------------------------------------------------------<<<<<<<<<<<<<<>>>>>>>>>>>>>---------------------------------------------------

-1. Zadeklarowaæ dwie zmienne tekstowe: imie i nazwisko oraz jedn¹ zmienn¹ liczbow¹ o nazwie numer porz¹dkowy. Przypisaæ wartoœci zmiennym:
--Jan, Kowalski, 100
--i wyœwietliæ je.

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

--2. Napisaæ program, który z wykorzystaniem instrukcji EXEC policzy liczbê wierszy w dowolnej tabeli, 
--a nastêpnie utworzy tabelê o nazwie Raport3 wstawiaj¹c liczbê wczeœniej wyliczonych wierszy. 
--Zapytania musz¹ byæ przechowywane w zmiennych tekstowych.

select count(*) as 'liczba' 
into Raport3 
from produkt 

begin 
	set @zapytanie varchar(max) 
	set @zapytanie ='select count(*) as ''liczba'' into Raport3  from produkt ' 
	exec(@zapytanie) 
end

select * from Raport3

--3. Napisaæ program, który wyœwietli wszystkie parzyste liczby z zakresu od 1 do 10. 
--Dodatkowo po wykonaniu kodu nale¿y wstrzymaæ program na 2 sekundy przed wyœwietleniem danych.

declare @liczba as INT = 1 ; 
while @liczba <=10 
begin 
if @liczba % 2 = 0 
print 'liczab to: ' + CAST(@liczba  as Varchar) ; 
set @liczba = @liczba +1 ; 
end 
waitfor delay '00:00:02' 
go
--4. Napisaæ program, który wyœwietli wszystkie liczby z zakresu od 1 do 10. 
--Je¿eli liczba jest podzielna przez 3 to wypisze stosown¹ informacjê.

declare @liczba as INT = 1 ; 
while @liczba <=10 
begin 
if @liczba % 3 = 0 
print 'liczab podzielna przez 3 to : ' + CAST(@liczba  as Varchar) ; 
set @liczba = @liczba +1 ; 
end 
go 

--5. Wygenerowaæ tabelê o nazwie Dane, która bêdzie zawiera³a dwie kolumny: opis oraz wartoœæ.
--W tabeli powinny byæ zamieszczone opisy: A, B, C, D i E oraz przyporz¹dkowane im liczby z zakresu od 1 do 100. 
--Nale¿y wype³niæ 2000 wierszy tablicy. Je¿eli kolejny dodawany wiersz jest podzielny przez 5
--to powinien otrzymaæ opis E, przez 4: D, przez 3: C,
--przez 2: B oraz przez 1: A. PodpowiedŸ: funkcja RAND() s³u¿y do generowania liczby losowej zmiennoprzecinkowej z zakresu od 0 do 1.




declare 
@tworzenietabeli varchar(100) , -- zapytanie tworzace tabele 
@wstawianiewierszy varchar(100),  -- zapyutanie wstawiajace wiersze 
@liczba numeric (3) , --generowanie liczb losowych 
@licznik numeric(5) , -- do pêtli 
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
	

	 
 

--6. Wyœwietliæ utworzon¹ wczeœniej tabelê wypisuj¹c w trzech kolumnach nastêpuj¹ce wartoœci:
--Klasa wielkoœci
--Opis 
--£¹czna wartoœæ  
--gdzie:
--- klasa wielkoœci ma reprezentowaæ przedzia³y:
--ma³e: 1 do 30
--œrednie: 31 do 70
--du¿e: 71 do 100
--- ³¹czna wartoœæ to funkcja agreguj¹ca SUM
--Wyniki maj¹ byæ koniecznie pogrupowane wed³ug klas wielkoœci i opisu.

with zapytanie
as
(select 
case
when wartosc between 1 and 30 then 'ma³e'
when wartosc between 31 and 70 then 'œrednie' 
else 'du¿e ' 
end as klasa_wielkosci , wartosc , opis 
from Dane) 
select klasa_wielkosci , sum(wartosc) as '³¹czna wartoœc' , opis 
from zapytanie 
group by klasa_wielkosci , opis 




-----------------------------------------------------------<<<<<<<<<<<<        PROCEDURY I FUNKCJE           >>>>>>>>>>>>>>------------------------------------------

--1. Nale¿y utworzyæ tablicê o nazwie TabLiczba, zawieraj¹c¹ kolumny:

--- identyfikator (autonumeracja),

--- liczba typu liczbowego ca³kowitego (co najmniej z zakresu 0 do 1000),

--- slownie typu tekstowego.

 

--Dodaæ do tabeli trzy wiersze (liczba, slownie):

--1 jeden

--2 dwa

--3 trzy

 

CREATE TABLE TabLiczba(id int identity(1,1), liczba numeric(4,0), slownie varchar(100));

INSERT INTO TabLiczba(liczba, slownie) VALUES (1,'jeden');

INSERT INTO TabLiczba(liczba, slownie) VALUES (2,'dwa');

INSERT INTO TabLiczba(liczba, slownie) VALUES (3,'trzy');



--2. Utworzyæ procedurê o nazwie wyswietlDane, która wyœwietli wszystkie wiersze z tabeli o nazwie Liczba. 
--Zweryfikowaæ dzia³anie procedury.

select * from  TabLiczba 

create procedure wyswietlDane  -- jesli zmienic procedure trzeba dodac alter 
as
(select * from  TabLiczba)


execute wyswietlDane --exec wyswietlDane - to samo 

--3. Utworzyæ procedurê o nazwie dodajLiczbe, która przyjmuje dwa argumenty - 
--liczbê oraz jej reprezentacjê s³own¹ i dodaje te argumenty jako kolejny wiersz tabeli TabLiczba.

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
--4. Dodaæ liczby od 4 do 10 wykorzystuj¹c procedurê dodajLiczbe.

--PodpowiedŸ:

exec dodajLiczbe @Numer=4, @Sl='cztery';
 
exec dodajLiczbe @Numer=5, @Sl='piêæ';

exec dodajLiczbe @Numer=6, @Sl='szeœæ';
 
exec dodajLiczbe @Numer=7, @Sl='siedem';
 
exec dodajLiczbe @Numer=8, @Sl='osiem';
 
exec dodajLiczbe @Numer=9, @Sl='dziewiêæ';

exec dodajLiczbe @Numer=10, @Sl='dziesiêæ';

select * from TabLiczba

--5. Utworzyæ procedurê o nazwie procLiczbaSlownie, która za argument przyjmuje wartoœæ liczbow¹
--i wyœwietla reprezentacjê s³own¹ tej liczby na podstawie danych z tabeli o nazwie TabLiczba.
--Zweryfikowaæ dzia³anie procedury.

select slownie from TabLiczba where liczba = 4 

create proc procLiczbaSlownie 
@liczba int 
as
(select slownie from TabLiczba where liczba = @liczba) 
 go

 exec procLiczbaSlownie @liczba=5

--6. Utworzyæ funkcjê o nazwie funkcjaLiczbaSlownie, która za argument przyjmuje wartoœæ liczbow¹ i 
--zwraca reprezentacjê s³own¹ tej liczby w postaci tabeli, na podstawie danych z tabeli o nazwie TabLiczba. Zweryfikowaæ dzia³anie.

go
create function funkcjaLiczbaSlownie(@liczba numeric(4))
returns table 
as return
(select slownie from TabLiczba where liczba = @liczba)

select * from funkcjaLiczbaSlownie(5) -- czasami trzeba dbo.funkcjaLiczbaSlownie 

--7. Napisaæ funkcjê o nazwie LiczbaWierszy, która zwróci liczbê wierszy zapisanych w tabeli o nazwie TabLiczba.

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
--8. Utworzyæ procedurê o nazwie dodajTylkoLiczbe, która za argument przyjmuje wartoœæ liczbow¹.
--Przed dodaniem liczby ma zostaæ sprawdzona, czy wartoœæ argumentu jest z zakresu 20 do 99.
--Je¿eli warunek ten zostanie spe³niony powinna zostaæ dodana liczba wraz ze s³own¹ reprezentacj¹ np.
--dwadzieœcia trzy. Czêœæ opisu powinna byæ pobierana z opisu liczb od 1 do 9. Dodaæ kilka liczb z zakresu od 20 do 99.

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
--9. Napisaæ procedurê o nazwie DodajLiczby, która doda wszystkie liczby z okreœlonego 
--zakresu u¿ywaj¹c w tym celu procedury o nazwie dodajTylkoLiczbe. Wywo³aæ procedurê dla zakresu od 20 do 99.
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


--10. Napisaæ funkcjê o nazwie WyswietlDuplikatyLiczb, która w postaci tabeli z kolumnami liczba oraz liczba_wystapien,
--zwróci listê wszystkich duplikatów liczb, jakie wystêpuj¹ w tabeli. Przetestowaæ dzia³anie.
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

--11. Napisaæ procedurê UsunLiczbe, usuwaj¹c¹ liczbê podan¹ jako argument wywo³ania procedury. Przetestowaæ dzia³anie.

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


---------------------------------<<<<<<<<<<<           WYZWALACZE I WYJ¥TKI        >>>>>>>>>>>>>>-----------------------------------------


--1. Utworzyæ tabelê o nazwie Osoba1 zawieraj¹ca 5 kolumn:

--identyfikator - liczba szeœciocyfrowa, autonumeracja od 100000 co 10

--imie - tekst 30 znaków

--nazwisko - tekst 50 znaków

--wiek - liczba trzycyfrowa

--data_dodania - data, domyœlnie ma byæ wstawiana dzisiejsza data

 

create table osoba1(id numeric(6) primary key identity(100000,10),

imie varchar(30),

nazwisko varchar(50),

wiek numeric(3,0),

data_dodania date default getdate());

 

--2. Do tabeli Osoba dodaæ 4 wiersze:

--Jan Kowalski, 35 lat

--Anna Nowak, 30 lat

--Ewa Zieliñska, 38 lat

--Adam WoŸniak, 32 lata

 

insert into osoba1(imie,nazwisko,wiek)

values

('Jan','Kowalski',35),

('Anna','Nowak',30),

('Ewa','Zieliñska',38),

('Adam','WoŸniak',31);

 

 

--3. Utworzyæ wyzwalacz o nazwie DodanoOsobe na tabeli o nazwie Osoba, 
--który bêdzie informowa³ u¿ytkownika, ¿e wiersz zosta³ dodany. Dodaæ jeden wiersz do tabeli.

create trigger DodanoOsobe on Osoba1
for insert 
as 
begin
print ' Dodano now¹ osobe' 
end 

insert into osoba1(imie,nazwisko,wiek)
values
('Kazimierz','Kowalski',35)
	
--4. Usun¹æ wyzwalacz o nazwie DodanoOsobe.

drop trigger dodanoosobe 

--5. Utworzyæ wyzwalacz o nazwie ModyfikujOsobe, który zablokuje mo¿liwoœæ modyfikacji wierszy w tabeli o nazwie Osoba.
--Wywo³ywanie instrukcji INSERT na tabeli osoba ma dodatkowo generowaæ wyj¹tek.

go
create trigger ModyfikujOsobe on Osoba1 
for update
as
begin
	rollback transaction
	raiserror('Osoby nie moga byc modyfikowane',1,1) 

end

update osoba1 set wiek=20 where imie= 'Anna' 

--6. Usun¹æ wyzwalacz o nazwie ModyfikujOsobe.
drop trigger ModyfikujOsobe 

--7. Utworzyæ wyzwalacz o nazwie DodanoOsoby na tabeli o nazwie Osoba, który bêdzie wyœwietla³ imiê i 
--nazwisko nowo dodawanej osoby (wartoœci). Przetestowaæ dzia³anie.
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

--8. Usun¹æ wyzwalacz o nazwie DodanoOsoby.

drop trigger DodanoOsoby 

--9. Utworzyæ wyzwalacz o nazwie SprawdzWiek, który zablokuje mo¿liwoœæ wprowadzenia osoby w wieku innymi ni¿ w przedziale 0-120 lat.
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

--10. Dodaæ now¹ osobê w wieku 130 lat. Sprawdziæ zawartoœæ tabeli.

insert into osoba1 ( imie ,nazwisko ,  wiek) values 
('Anna' , 'Kowalska', 130 ) 


--11. Usun¹æ wyzwalacz o nazwie SprawdzWiek.
drop trigger SprawdzWiek