
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Block CSRF Attacks with minimal changes to your app",
  "AUTHOR" => "Rintaro Ishizaki <rintaro\@cpan.org>, William Wolf <throughnothing\@gmail.com>",
  "BUILD_REQUIRES" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "HTTP::Request::Common" => 0,
    "Plack::Builder" => 0,
    "Plack::Session::State::Cookie" => 0,
    "Plack::Test" => 0,
    "Test::More" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Plack-Middleware-CSRFBlock",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Plack::Middleware::CSRFBlock",
  "PREREQ_PM" => {
    "Data::Dumper" => 0,
    "Digest::SHA1" => 0,
    "HTML::Parser" => 0,
    "Plack::Middleware" => 0,
    "Plack::Request" => 0,
    "Plack::TempBuffer" => 0,
    "Plack::Util" => 0,
    "Plack::Util::Accessor" => 0,
    "parent" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.07",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



