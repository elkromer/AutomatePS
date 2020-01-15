param(
  [string[]] $List,
  [switch] $l
)

$dockerFilePath = "C:\Users\reese\source\repos\docker"

Push-Location $dockerFilePath

$portCounter = 2222

if ($l) {
  gci; Pop-Location; return;
}

# Build and run containers
foreach ($file in $List){

  try {
    docker build . -f $file -t $file
  } catch [Exception]{
    $_
    Status "Failed to build container." "FAIL" "Red"
    return;
  }
  Status "$file built successfully." "OK" "Green"

  try {
    docker run -d -p $portCounter`:22 $file`:latest
  } catch [Exception]{
    $_
    Status "Failed to start container." "FAIL" "Red"
    return;
  }
  Status "$file running on port $portCounter" "OK" "Green"

  $portCounter++
}


Pop-Location