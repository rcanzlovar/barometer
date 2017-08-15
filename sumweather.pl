#!/usr/bin/perl -w
use URI::Escape;

@files = <*>;
foreach $file (@files) {
  next unless $file =~ m/\.txt$/;

  &getweather($file);

}

sub getweather {
  my $filename = shift(@_);

  $file =~  m/(....)(..)(..)(..)(..)/;
  my $year = $1;
  my $mon = $2;
  my $day = $3;
  my $hour = $4;
  my $min = $5;
  my $timestamp = "$year-$mon-$day $hour:$min:00";

  print STDERR $file . "\n";
  my $text = "";
  if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
    while (my $row = <$fh>) {
      chomp $row;

      $text .= $row;
    }
    close($fh);
  } else {
    warn "Could not open file '$filename' $!";
  }


  # fgot the whole file into row now


  my %weather_values;

  my %sub_strings = (
    feelslike   => "<li><span>Feels Like</span> (.+?)&#176;</li>",
    wind        => "<li><span>Wind</span> (.+?)</li>",
    barometer   => "<li><span>Barometer</span> (.+?) in</li>",
    visibility  => "<li><span>Visibility</span> (.?+) mi</li>",
    humidity    => "<li><span>Humidity</span> (.+?)%</li>",
    dewpoint    => "<li><span>Dew Point</span> (.+?)&#176;</li>",
    loc         => "data-loc=(.+?) ",
    conditions  => "current condition is (.+?) and the temperature is ",
    temperature => "nd the temperature is (.+?) degrees"
  );

  for my $key (keys %sub_strings) {
    $text =~ m/$sub_strings{$key}/;
    $weather_values{$key} = $1;
  }

  # get the pieces of the wind 
  $weather_values{'wind'} =~ /(.+?) (.+?) mph/;
  ($weather_values{'wind_direction'},$weather_values{'wind_speed'}) = ($1,$2); 

  # grab the names from the loc string
  my $loctemp =  uri_unescape($weather_values{'loc'}) ;
  $loctemp =~ /lat=(.+?)\&.*?long=(.+?)\&.*?c=(.+?)\&/;

  ($weather_values{'lat'},$weather_values{'lon'},$weather_values{'city'}) = ($1,$2,$3); 

  my $sql =     "INSERT INTO `weather` 
(`timestamp`, 
`city_name`, 
`city_lat`, 
`city_lon`, 
`temperature`, 
`humidity`, 
`barometer`, 
`conditions`, 
`visibility`, 
`dewpoint`, 
`feelslike`) 
VALUES 
('" . $timestamp . "', 
'" . $weather_values{'city'} . "', 
'" . $weather_values{'lat'} . "', 
'" . $weather_values{'lon'} . "', 
'" . $weather_values{'temperature'} . "', 
'" . $weather_values{'humidity'} . "', 
'" . $weather_values{'barometer'} . "', 
'" . $weather_values{'conditions'} . "', 
'" . $weather_values{'visibility'} . "', 
'" . $weather_values{'dewpoint'} . "',
'" . $weather_values{'feelslike'} . "');"; 
print $sql . "\n";


#   $safe = uri_escape("10% is enough\n");
 #  $verysafe = uri_escape("foo", "\0-\377");
 #  $str  = uri_unescape($safe);
}