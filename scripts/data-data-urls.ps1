param( 
  [string[]] $productList,
  [switch] $v10
)

if ($v10) {v10; cd Release;}
else {release;}

$productList | ForEach-Object -ErrorAction Stop {
  make data prod=$_;
  cd $_;
  make data;
  make urls;
  cd ..;
}

dsk