use Encode;

open(bat, '>', 'createGaiji.bat') or die 'Cannot open file: $!';
open(gmap, '>', 'GaijiMap.xml') or die 'Cannot open file: $!';

# EBStudio付属のFontDumpW.exeの場所です。
# 32bit版OSをお使いの方は" (x86)"の部分を消してください。
$FontDumpWLocation="C:\\Program Files (x86)\\EBStudio\\FontDumpW.exe";
# 外字を作成する際のフォントです。Arial Unicode MSは多くの文字に対応していて便利です。
$FontName="Arial Unicode MS";

print gmap "<?xml version=\"1.0\" encoding=\"Shift_JIS\"?>\n<gaijiSet>\n";

while(<STDIN>){
	&prt($_);
}

$keyhnum=hex "A121";
$keynum=$keyhnum;
foreach my $key (keys %fchar){
	if(&checkHalf($key)){
		$keynum=&incrementKey($keynum);
	}
}

# 出力する外字のサイズを設定します。
# 私の環境では30x32のでは表示されません。また48x48でもおかしくなります。
my @xlist=(16,24,48);
my @xslist=(8,16,24);
my @ylist=(16,24,48);
# フォントサイズごとの追加オプションです。-bはy方向にずらす大きさです。
my @optionlist=("-b=3","-b=5","-b=9");
my @gfname;
my @gsfname;

for(my $i=0;$i<=$#xlist;$i++){
	$gfname[$i]="Gaiji".$xlist[$i]."x".$ylist[$i].".xml";
	print bat "echo ^<fontSet size=\"".$xlist[$i]."X".$ylist[$i]."\" start=\"".sprintf("%X",$keynum)."\"^>>".$gfname[$i]."\n";
	$gsfname[$i]="Gaiji".$xslist[$i]."x".$ylist[$i].".xml";
	print bat "echo ^<fontSet size=\"".$xslist[$i]."X".$ylist[$i]."\" start=\"".sprintf("%X",$keyhnum)."\"^>>".$gsfname[$i]."\n";
}

foreach my $key (sort {$fchar{$b} <=> $fchar{$a}} keys %fchar)  {
	if(&checkHalf($key)){
		for(my $i=0;$i<=$#xlist;$i++){
			print bat "\"".$FontDumpWLocation."\" \"".$FontName."\" ".$key." -x=".$xslist[$i]." -y=".$ylist[$i]." ".$optionlist[$i]." -e=".sprintf("%X",$keyhnum).">>".$gsfname[$i]."\n";
		}
		my $alt=&getAlt($key);
		if($alt){
			print gmap "<gaijiMap name=\"Ux".$key."\" unicode=\"#x".$key."\" ebcode=\"".sprintf("%X",$keyhnum)."\" alt=\"".$alt."\"/>\n";
		}else{
			print gmap "<gaijiMap name=\"Ux".$key."\" unicode=\"#x".$key."\" ebcode=\"".sprintf("%X",$keyhnum)."\"/>\n";
		}
		
		$keyhnum=&incrementKey($keyhnum);
	}else{
		for(my $i=0;$i<=$#xlist;$i++){
			print bat "\"".$FontDumpWLocation."\" \"".$FontName."\" ".$key." -x=".$xlist[$i]." -y=".$ylist[$i]." ".$optionlist[$i]." -e=".sprintf("%X",$keynum).">>".$gfname[$i]."\n";
		}
		my $alt=&getAlt($key);
		if($alt){
			print gmap "<gaijiMap name=\"Ux".$key."\" unicode=\"#x".$key."\" ebcode=\"".sprintf("%X",$keynum)."\" alt=\"".$alt."\"/>\n";
		}else{
			print gmap "<gaijiMap name=\"Ux".$key."\" unicode=\"#x".$key."\" ebcode=\"".sprintf("%X",$keynum)."\"/>\n";
		}
		
		$keynum=&incrementKey($keynum);
		if($keynum>hex "FE7F"){last};
	}
}
print gmap "</gaijiSet>";

for(my $i=0;$i<=$#xlist;$i++){
	print bat "echo ^</fontSet^>>>".$gfname[$i]."\n";
	print bat "echo ^</fontSet^>>>".$gsfname[$i]."\n";
}
print bat "echo ^<?xml version=\"1.0\" encoding=\"Shift_JIS\"?^>>Gaiji.xml\necho ^<gaijiData  xml:space=\"preserve\"^>>>Gaiji.xml\n";
for(my $i=0;$i<=$#xlist;$i++){
	print bat "type ".$gfname[$i].">>Gaiji.xml\n";
	print bat "type ".$gsfname[$i].">>Gaiji.xml\n";
}
print bat "echo ^</gaijiData^>>>Gaiji.xml\n";


sub prt{
	my $utf8= decode('UTF-8', $_[0]);
	my $sjis= encode('sjis', $utf8, sub{ $cd=sprintf("&#x%X;",$_[0]) , &addfchar($cd,$_[0]) ,$cd});
	print $sjis;
}

sub addfchar{
	my $xch=substr($_[0],3,-1);
	if(exists($fchar{$xch})){$fchar{$xch}++;}else{$fchar{$xch}=1;}
	$uchar{$xch}=$_[1];
}

sub getAlt{
# 外字の代替文字列です。
my %alts=("A1","i","A9","(C)","AE","(R)","B1","+-","B2","2","B3","3","B9","1","BA","0","BC","1/4","BD","1/2","BE","3/4","C0","A","C1","A","C2","A","C3","A","C4","A","C5","A","C6","AE","C7","C","C8","E","C9","E","CA","E","CB","E","CC","I","CD","I","CE","I","CF","I","D0","D","D1","N","D2","O","D3","O","D4","O","D5","O","D6","O","D7","X","D8","O","D9","U","DA","U","DB","U","DC","U","DD","Y","DE","P","DF","B","E0","a","E1","a","E2","a","E3","a","E4","a","E5","a","E6","ae","E7","c","E8","e","E9","e","EA","e","EB","e","EC","i","ED","i","EE","i","EF","i","F0","d","F1","n","F2","o","F3","o","F4","o","F5","o","F6","o","F7","/","F8","o","F9","u","FA","u","FB","u","FC","u","FD","y","FE","p","FF","y","100","A","101","a","102","A","103","a","104","A","105","a","106","C","107","c","108","C","109","c","10A","C","10B","c","10C","C","10D","c","10E","D","10F","d","110","D","111","d","112","E","113","e","114","E","115","e","116","E","117","e","118","E","119","e","11A","E","11B","e","11C","G","11D","g","11E","G","11F","g","120","G","121","g","122","G","123","g","124","H","125","h","126","H","127","h","128","I","129","i","12A","I","12B","i","12C","I","12D","i","12E","I","12F","i","130","I","131","i","132","IJ","133","ij","134","J","135","j","136","K","137","k","138","k","139","L","13A","l","13B","L","13C","l","13D","L","13E","l","13F","L","140","l","141","L","142","l","143","N","144","n","145","N","146","n","147","N","148","n","149","n","14A","N","14B","n","14C","O","14D","o","14E","O","14F","o","150","O","151","o","152","OE","153","oe","154","R","155","r","156","R","157","r","158","R","159","r","15A","S","15B","s","15C","S","15D","s","15E","S","15F","s","160","S","161","s","162","T","163","t","164","T","165","t","166","T","167","t","168","U","169","u","16A","U","16B","u","16C","U","16D","u","16E","U","16F","u","170","U","171","u","172","U","173","u","174","W","175","w","176","Y","177","y","178","Y","179","Z","17A","z","17B","Z","17C","z","17D","Z","17E","z","192","f");
if(exists($alts{$_[0]})){return $alts{$_[0]}};
return "";
}

sub checkHalf{
# 半角とみなす文字一覧です。Unicode16進数で書かれています。出力結果を見て適宜書き換えましょう。
my @list=("A1","A6","A8","AA","B0","B2","B3","B4","B7","B8","B9","BA","BF","CC","CD","CE","CF","E0","E1","E2","E3","E4","E5","E7","E8","E9","EA","EB","EC","ED","EE","EF","F0","F1","F2","F3","F4","F5","F6","F8","F9","FA","FB","FC","FD","FE","FF","101","103","105","107","109","10B","10D","10F","111","113","115","117","119","11B","11D","11F","121","123","125","127","129","12B","12D","12F","131","133","135","137","138","13A","13C","13E","140","142","144","146","148","149","14B","14D","14F","151","155","157","159","15B","15D","15F","161","163","165","167","169","16B","16D","16F","171","173","175","177","17A","17C","17E","2C6","2DC");
for my $data ( @list ) {
	return 1 if $data eq $_[0];
}
return 0;
}

sub incrementKey{
my $num=$_[0];
$num++;
if(($num-(hex "A121"))%256>93){$num+=256-94;}
return $num;
}
