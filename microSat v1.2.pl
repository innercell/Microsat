# Tiago Roberti Sampaio
# http://www.trsampaio.com/2014/09/01/perl-identificacao-de-microssatelites-regioes-de-repeticao/
# http://www.trsampaio.com

$multi_test=0;
$window=3;
$max_gap=1;
$min_rep=2;

#micro satelites
open(FILE,"arq.fsa");
@sequences;
@names;
$i_s=-1;

while($str=<FILE>){
	#print "l:$str\n";
	if(index($str,">",0)>=0){
		$i_s++;
		@names[$i_s]=$str;
		next;
	}
	$sequences[$i_s].=$str;
	#print "gravado\n";
	#print "\n\nstring=$string\n";
	#system("pause");
}
close FILE;
#$string=~s/\s//g;


if($multi_test==1){
	for($a=2;$a<=7;$a++){
		for($b=2;$b<=7;$b++){
			for($d=2;$d<=7;$d++){
				%hash="";
				$c=0;
				$window=$a;
				$max_gap=$b;
				$min_rep=$d;
				open(oo,">resultsv2/uSat-w$window-MAXg$max_gap-MINr$min_rep.txt");
				main();
			}
		}
	}
}else{
	%hash="";
	$c=0;
	#open(oo,">uSat-w$window|maxG$max_gap|minR$min_rep.txt");
	open(oo,">resultsv2/uSat-w$window-MAXg$max_gap-MINr$min_rep.txt");
	main();
}


sub main{
	for($t=0;$t<scalar @sequences;$t++){
		%hash="";
		$c=0;
		print "Current: $names[$t]\n";
		print oo"Current: $names[$t]\n";
		$string=$sequences[$t];
		$string=~s/\s//g;
		for($i=0;$i<(length $string)-$window+1;$i++){
			$microSat=substr($string,$i,$window);
			
			next if(exists $hash{$microSat});
			$hash{$microSat}=1;	

			$total=0;
			monta_microsat($microSat);
			if($total>0){
				print oo"***end $microSat MicroSat's $total $_[0] found!\n";
				print "***end $microSat MicroSat's $total $_[0] found!\n";
			}

			#print "$i\n";
			#print "\t$c\n";
			$c++;
		}
	}
	close(oo);
}
sub monta_microsat{
		#print oo"***start $_[0] MicroSat's\n";
		@vetor="";
		$offset=0; #indica a partir de qual ponto o index() irá começar
		$p=0; #recebe retorno do index
		$count=0;
		$v_index=2; #indice de controle do array de resposta
		$start=index($string,$_[0],0); 
				
		$p=index($string,$_[0],$start+$window);
				
		$end=$p;
		
		while(1){
			if($p<0 || $end<0){
				#print "micSat: $start--$end\n";
				if($count>=$min_rep){
				#print "p=$p|$start~~$end|off=$offset|\n";
					#print "--$start~$end\n";
					$end=$start+$window if($end<0);
					print oo "$start~$end $count\n";$total++;
				}
				last;
			}elsif($p-$end<=$max_gap){
				#print "\t++dentro do gap $start~~$end\n";
				$end=$p;
				$p=index($string,$_[0],$end+$window);
				$count++;
			}else{
			
				$end+=$window;
				
				if($count>=$min_rep){
				#print "p=$p|$start~~$end|off=$offset|\n";
				#print "--$start~$end\n";
				print oo "$start~$end $count\n";$total++;
				}
				#@vetor[$v_index++]="$start~$end";
				$start=$p;
				
				$end=index($string,$_[0],$start+$window);				
				$count=0;
			}
			#$p=index($string,$_[0],$offset);
			#print "$_[0] found in $p\n";

		}
}