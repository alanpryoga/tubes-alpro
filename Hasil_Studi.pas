program Hasil_Studi;

{ I.S. : Pengguna memasukkan banyaknya mahasiswa (m),
         banyaknya mata kuliah (n) }
{ F.S. : Menampilkan hasil studi setiap mahasiswa }

uses crt;

const
    MaksMhs   = 50;
    MaksMK    = 5;

type
    RecordMhs     = record
                        NIM    : integer;
                        Nama   : string;
                        IPK    : real;
                    end;
    RecordMK      = record
                        KodeMK : string;
                        NamaMK : string;
                        SKS    : integer;
                    end;
    LarikMhs      = array[1..MaksMhs] of RecordMhs;
    LarikMK       = array[1..MaksMK] of RecordMK;
    MatriksNilai  = array[1..MaksMhs, 1..MaksMK] of integer;
    MatriksIndeks = array[1..MaksMhs, 1..MaksMK] of char;
    MatriksMutu   = array[1..MaksMhs, 1..MaksMK] of integer;

{ variabel global }
var
    Mhs       : LarikMhs;
    MK        : LarikMK;
    Nilai     : MatriksNilai;
    Indeks    : MatriksIndeks;
    Mutu      : MatriksMutu;
    M, N      : integer;

function IndeksNilai(Nilai : integer) : char;
begin
    case(Nilai) of
        80..100 : IndeksNilai := 'A';
        70..79  : IndeksNilai := 'B';
        60..69  : IndeksNilai := 'C';
        50..59  : IndeksNilai := 'D';
        0..49   : IndeksNilai := 'E';
    end;
end; { end function }

procedure IsiData(var M, N : integer;
                  var Mhs  : LarikMhs;
                  var MK   : LarikMK);
var
    i, j : integer;
begin
    write('Banyaknya Mahasiswa   : '); readln(M);
    write('Banyaknya Mata Kuliah : '); readln(N);
    clrscr;

    { memasukkan data mahasiswa }
    window(1, 1, 40, 30);
    writeln('Daftar Mahasiswa');
    writeln('-------------------------------------');
    writeln('| No |    NIM    |  Nama Mahasiswa  |');
    writeln('=====================================');
    for i := 1 to M do
    begin
        gotoxy( 1, i + 4);
        write('|    |           |                  |');

        gotoxy( 3, i + 4); write(i);
        gotoxy( 8, i + 4); readln(Mhs[i].NIM);
        gotoxy(20, i + 4); readln(Mhs[i].Nama);
    end;
    writeln('-------------------------------------');

    writeln;

    { memasukkan data mata kuliah }
    window(41, 1, 120, 30);
    writeln('Daftar Mata Kuliah');
    writeln('--------------------------------------------------');
    writeln('| No | Kode Mata Kuliah | Nama Mata Kuliah | SKS |');
    writeln('==================================================');
    for j := 1 to N do
    begin
        gotoxy( 1, j + 4);
        writeln('|    |                  |                  |     |');

        gotoxy( 3, j + 4); write(j);
        gotoxy( 8, j + 4); readln(MK[j].KodeMK);
        gotoxy(27, j + 4); readln(MK[j].NamaMK);
        gotoxy(46, j + 4); readln(MK[j].SKS);
    end;
    writeln('--------------------------------------------------');
    write('Tekan Enter untuk melanjutkan!'); readln;
end; { end procedure }

procedure IsiNilai(M, N      : integer;
                   Mhs       : LarikMhs;
                   MK        : LarikMK;
                   var Nilai : MatriksNilai);
var
    i, j : integer;
begin
    window(1, 1, 120, 30); textbackground(7); textcolor(0); clrscr;
    gotoxy(50, 1); writeln('Pengisian Nilai Mahasiswa');
    gotoxy(50, 2); writeln('-------------------------');

    { menampilkan data kode mk dan nim }
    gotoxy( 1, 4); write('NIM');
    gotoxy(12, 4); write('Kode Mata Kuliah');
    for i := 1 to M do
    begin
        for j := 1 to N do
        begin
            textcolor(blue);
            gotoxy(j * 12, 5); write(MK[j].KodeMK);
        end;

        gotoxy(1, i + 5); write(Mhs[i].NIM);
    end;

    textcolor(0);
    { mengisi nilai matriks }
    for i := 1 to M do
    begin
        for j := 1 to N do
        begin
            gotoxy(j * 12 + 3, i + 5); readln(Nilai[i, j]);
        end;
    end;
end;

procedure TampilIndeks(Nilai      : MatriksNilai;
                       M, N       : integer;
                       var Indeks : MatriksIndeks);
var
    i, j : integer;
begin
    for i := 1 to M do
    begin
        for j := 1 to N do
        begin
            Indeks[i, j] := IndeksNilai(Nilai[i, j]);
            gotoxy(j * 12 + 3, i + 5); clreol; write(Indeks[i, j]);
            delay(300);
        end;
    end;
    writeln;
    write('Tekan Enter untuk melanjutkan!'); readln;
end; { end procedure }

function HitungMutu(Indeks : char; SKS : integer) : integer;
begin
    if(Indeks = 'A') then
        HitungMutu := 4 * SKS
    else
        if(Indeks = 'B') then
            HitungMutu := 3 * SKS
        else
            if(Indeks = 'C') then
                HitungMutu := 2 * SKS
            else
                if(Indeks = 'D') then
                    HitungMutu := 1 * SKS
                else
                    HitungMutu := 0;
end;

function HitungIPK(i, M, N : integer;
                   Mutu    : MatriksMutu;
                   MK      : LarikMK) : real;
var
    Mt, Sk, j : integer;
begin
    { menghitung total mutu }
    Mt := 0;
    for j := 1 to N do
    begin
        Mt := Mt + Mutu[i, j];
    end;

    { menghitung total sks }
    Sk := 0;
    for j := 1 to N do
    begin
        Sk := Sk + MK[j].SKS;
    end;

    HitungIPK := Mt / Sk;
end;

procedure TampilHasilStudi(M, N     : integer;
                           Mhs      : LarikMhs;
                           MK       : LarikMK;
                           Indeks   : MatriksIndeks;
                           var Mutu : MatriksMutu);
var
    i, j, k, l : integer;
begin
    clrscr;
    gotoxy(25, 1); writeln('HASIL STUDI MAHASISWA TEKNIK INFORMATIKA UNIKOM SEBANYAK ', M, ' MAHASISWA');
    gotoxy(25, 2); writeln('====================================================================');

    l := 1;
    for i := 1 to M do
    begin

        textcolor(red);
        gotoxy( 1, l + 3);
        for k := 1 to 120 do
        begin
            write('-');
        end;
        gotoxy(53, l + 3); write('Mahasiswa Ke-', i);

        textcolor(black);
        gotoxy( 1, l + 4); write('NIM  : ', Mhs[i].NIM);
        gotoxy( 1, l + 5); write('Nama : ', Mhs[i].Nama);

        gotoxy( 1, l + 6); write('-----------------------------------------------------------');
        gotoxy( 1, l + 7); write('| No | Kode Mata Kuliah | Nama Mata Kuliah | SKS | Indeks |');
        gotoxy( 1, l + 8); write('===========================================================');

        for j := 1 to N do
        begin
             gotoxy( 1, j + (l + 8));
             gotoxy( 1, j + (l + 8)); write('|    |                  |                  |     |        |');
             gotoxy( 3, j + (l + 8)); write(j);
             gotoxy( 8, j + (l + 8)); write(MK[j].KodeMK);
             gotoxy(27, j + (l + 8)); write(MK[j].NamaMK);
             gotoxy(46, j + (l + 8)); write(MK[j].SKS);
             gotoxy(54, j + (l + 8)); write(Indeks[i, j]);

             Mutu[i, j] := HitungMutu(Indeks[i, j], MK[j].SKS);
        end;

        gotoxy( 1, (l + 9) + N); write('-----------------------------------------------------------');

        gotoxy( 1, (l + 10) + N); write('IPK  : ', HitungIPK(i, M, N, Mutu, MK):0:1);

        l := (l * 10) + N;
    end;
end; { end procedure }

{ program utama }
begin
    IsiData(M, N, Mhs, MK);
    IsiNilai(M, N, Mhs, MK, Nilai);
    TampilIndeks(Nilai, M, N, Indeks);
    TampilHasilStudi(M, N, Mhs, MK, Indeks, Mutu);
    readln;
end.
