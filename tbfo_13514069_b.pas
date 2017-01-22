{NIM/Nama : 13514069/Sekar Anglila Hapsari
 Nama file : tbfo_13514069_b.pas
 Topik : Finite Automation
 Tanggal : 24 September 2015
 Deskripsi : Membuat program vending machine yang bisa menukar uang dan
			 mengeluarkan minuman tergantung statenya}

program tbfo_b;

uses StrUtils;

{Kamus}
	type automata = record
		stateAw : string;
		jalur : integer;
		stateAkh : string;
		jenisstate : string;
	end;
	
	type auto = array [1..100] of automata;
	
var
	TA : auto;
	i, Neff, sum, uang: integer;
	stop : boolean;
	beli : char;
	statenow : string;
	
{Prosedur dan Fungsi}
	procedure Load(fin : string; var TA : auto; var Neff : integer);
	{I.S. File eksternal sudah terdefinisi}
	{F.S. Data dalam file eksternal sudah disalin ke array, Neff terdefinisi}
	{Membaca file eksternal dan menyalinnya ke array sambil menghitung Neff}
	{Kamus Lokal}
	var
		i , j : integer;
		f : text;
		s, s1, s2, s3, s4 : string;
	{Algoritma}
	begin
		{Assign file text}
		assign (f, fin);
		reset (f);
		{Perhitungan Baris}
		j := 1;
		Neff := 0;
		while not EOF(f) do
		begin
		{Bentuk file eksternal : q1|1000|q2|NF|}
			i := 1; s1 := ''; s2 := ''; s3 := ''; s4 := '';{Inisialisasi variabel}
			readln(f, s);
			{Mengisi stateAw}
			while (s[i] <> '|') do
			begin
				s1 := s1 + s[i];
				i := i + 1;
			end;
			i := i + 1;
			TA[j].stateAw := s1;
			{Mengisi jalur}
			while (s[i] <> '|') do
			begin
				s2 := s2 + s[i];
				i := i + 1;
			end;
			i := i + 1;
			Val(s2, TA[j].jalur);
			{Mengisi stateAkh}
			while (s[i] <> '|') do
			begin
				s3 := s3 + s[i];
				i := i + 1;
			end;
			i := i + 1;
			TA[j].stateAkh := s3;
			{Mengisi jenisstate}
			while (s[i] <> '|') do
			begin
				s4 := s4 + s[i];
				i := i + 1;
			end;
			TA[j].jenisstate := s4;
			{Mengisi nilai Neff}
			Neff := j;
			j := j + 1;
		end;
		close(f);
	end;
	
	function IsValid(uang : integer; sum : integer; i : integer) : boolean;
	{Menentukan apakah input valid atau tidak}
	begin
		case (uang) of
			1000, 2000, 5000 : begin
									if (sum <= 6000) then
									begin
										IsValid := true;
									end else
										IsValid := false;
								end;
			10000, 20000 : begin
								if (i = 1) then
								begin
									IsValid := true;
								end else
									IsValid := false;
							end;
			else IsValid := false
		end;
	end;
	
	function IsTukar(sum : integer; i : integer) : boolean;
	{Menentukan apakah ditukan atau gak}
	begin
		if ((sum = 10000) or (sum = 20000)) then
		begin
			if (i = 1) then
			begin
				IsTukar := true;
			end;
		end else
			IsTukar := false;
	end;
	
	function IsBeli(beli : char) : boolean;
	{Mengecek apakah membeli/menukar}
	begin
		if ((beli = 'Y') or (beli = 'y')) then
		begin
			IsBeli := true;
		end else
			if ((beli = 'N') or (beli = 'n')) then
			begin
				IsBeli := false;
			end;
	end;
	
	procedure tampilmenu(sum : integer);
	{I.S. Nilai sum terdefinisi}
	{F.S. Menu ditampilkan}
	{Mengecek input dan tampilan menu yang tepat}
	{Algoritma}
	begin
		if (IsTukar(sum, i)) then
		begin
			writeln(' Minuman A : OFF');
			writeln(' Minuman B : OFF');
			writeln(' Minuman C : OFF');
			writeln(' Tukar Uang : ON');
		end else {IsTukar := false}
			begin
				case (sum) of
					1000 : begin
							writeln(' Minuman A : OFF');
							writeln(' Minuman B : OFF');
							writeln(' Minuman C : OFF');
							writeln(' Tukar Uang : OFF');
						end;
					2000 : begin
							writeln(' Minuman A : OFF');
							writeln(' Minuman B : OFF');
							writeln(' Minuman C : OFF');
							writeln(' Tukar Uang : OFF');
						end;
					3000 : begin
							writeln(' Minuman A : ON');
							writeln(' Minuman B : OFF');
							writeln(' Minuman C : OFF');
							writeln(' Tukar Uang : OFF');
						end;
					4000 : begin
							writeln(' Minuman A : OFF');
							writeln(' Minuman B : ON');
							writeln(' Minuman C : OFF');
							writeln(' Tukar Uang : OFF');
						end;
					5000 : begin
							writeln(' Minuman A : OFF');
							writeln(' Minuman B : OFF');
							writeln(' Minuman C : OFF');
							writeln(' Tukar Uang : OFF');
						end;
					6000 : begin
							writeln(' Minuman A : OFF');
							writeln(' Minuman B : OFF');
							writeln(' Minuman C : ON');
							writeln(' Tukar Uang : OFF');
						end;
				end;
			end;
	end;
	
	procedure tampilstate(var statenow : string; uang : integer);
	{I.S. Nilai statenow dan uang sudah terdefinisi}
	{F.S. Nilai StateNow berubah}
	{Menampilkan jalur state}
	{Kamus Lokal}
	var
		found : boolean;
		i : integer;
		stateAkh : string;
	{Algoritma}
	begin
		found := false; i := 1; {Inisialsasi variabel}
		while ((not(found)) and (i <= Neff)) do
		begin
			if ((TA[i].stateAw = statenow) and (TA[i].jalur = uang)) then
			begin
				writeln(' ', statenow,' > ', TA[i].stateAkh);
				stateAkh := TA[i].stateAkh;
				if (TA[i].jenisstate = 'F') then
				begin
					writeln(' Mencapai State Final');
				end;
				found := true;
			end;
			i := i + 1;
		end;
		statenow := stateAkh;
	end;
	
{Algoritma}
begin
	Load('state.txt', TA, Neff); {Menmindahkan data ke array TA}
	{Menampilkan Menu}
	writeln(' -----------------------------------------------------------');
	writeln('                     Vending Machine                        ');
	writeln(' -----------------------------------------------------------');
	writeln;
	writeln('                          Menu                              ');
	writeln(' 1. Minuman A : Rp 3.000 ');
	writeln(' 2. Minuman B : Rp 4.000 ');  
	writeln(' 3. Minuman C : Rp 6.000 ');
	writeln(' 3. Tukar Uang (Rp 10.000 / Rp 20.000) ');
	writeln(' Vending Machine hanya menerima Rp 1.000, Rp 2.000, Rp 5.000,'); 
	writeln(' Rp 10.000, dan Rp 20.000');
	writeln;
	
	{Inisialisasi variabel}
	sum := 0; stop := false; statenow := TA[1].stateAw; i := 1;
	 
	{Menjalankan Vending Machine}
	while (not(stop)) do
	begin
		{Menerima masukan}
		write(' Masukkan Uang = ');
		readln(uang);
		sum := sum + uang;
		if (IsValid(uang, sum, i)) then
		begin
			tampilMenu(sum);
			writeln(' Jalur state : ');
			tampilstate(statenow, uang);
			writeln;
			if (IsTukar(sum, i)) then
			begin
				write(' Apakah ingin menukar? [Y/N] ');
				readln(beli);
				writeln;
				if (IsBeli(beli)) then
				begin
					writeln(' Akan dikeluarkan uang sejumlah Rp ',sum,' dalam bentuk seribuan!');
					writeln;
					stop := true; {Terminasi}
				end else
					begin
						stop := true; {Terminasi}
					end;
			end else
				begin
					if ((sum = 3000) or (sum = 4000) or (sum = 6000)) then
					begin
						write(' Apakah ingin membeli minuman? [Y/N] ');
						readln(beli);
						writeln;
						if (IsBeli(beli)) then
						begin
							writeln(' Terima Kasih telah membeli! ');
							writeln;
							stop := true; {Terminasi}
						end;
					end;
				end;
		end else
			begin
				stop := true;
				writeln(' Masukkan anda tidak valid!');
				writeln;
			end;
		i := i + 1;
	end;
	writeln (' Terima Kasih sudah menggunakan Vending Machine!');
	writeln;
end.
