# NAME

Plack::Middleware::CSRFBlock

# VERSION

version 0.07

# SYNOPSIS

    use Plack::Builder;

    my $app = sub { ... }

    builder {
      enable 'Session';
      enable 'CSRFBlock';
      $app;
    }

# DESCRIPTION

This middleware blocks CSRF. You can use this middleware without any modifications
to your application, in most cases. Here is the strategy:

- output filter

When the application response content-type is "text/html" or
"application/xhtml+xml", this inserts hidden input tag that contains token
string into `form`s in the response body.  It can also adds an optional meta
tag (by setting `add_meta` to true) with the default name "csrftoken".
For example, the application response body is:

    <html>
      <head>
          <title>input form</title>
      </head>
      <body>
        <form action="/receive" method="post">
          <input type="text" name="email" /><input type="submit" />
        </form>
    </html>

this becomes:

    <html>
      <head><meta name="csrftoken" content="0f15ba869f1c0d77"/>
          <title>input form</title>
      </head>
      <body>
        <form action="/api" method="post"><input type="hidden" name="SEC" value="0f15ba869f1c0d77" />
          <input type="text" name="email" /><input type="submit" />
        </form>
    </html>

This affects `form` tags with `method="post"`, case insensitive.

- input check

For every POST requests, this module checks input parameters contain the
collect token parameter. If not found, throws 403 Forbidden by default.

Supports `application/x-www-form-urlencoded` and `multipart/form-data`.

# NAME

Plack::Middleware::CSRFBlock - CSRF are never propageted to app

# OPTIONS

    use Plack::Builder;
    

    my $app = sub { ... }
    

    builder {
      enable 'Session';
      enable 'CSRFBlock',
        parameter_name => 'csrf_secret',
        token_length => 20,
        session_key => 'csrf_token',
        blocked => sub {
          [302, [Location => 'http://www.google.com'], ['']];
        },
        onetime => 0,
        ;
      $app;
    }

- parameter_name (default:"SEC")

Name of the input tag for the token.

- add_meta (default: 0)

Whether or not to append a `meta` tag to pages that
contains the token.  This is useful for getting the
value of the token from Javascript.  The name of the
meta tag can be set via `meta_name` which defaults
to `csrftoken`.

- meta_name (default:"csrftoken")

Name of the `meta` tag added to the `head` tag of
output pages.  The content of this `meta` tag will be
the token value.  The purpose of this tag is to give
javascript access to the token if needed for AJAX requests.

- header_name (default:"X-CSRF-Token")

Name of the HTTP Header that the token can be sent in.
This is useful for sending the header for Javascript AJAX requests,
and this header is required for any post request that is not
of type `application/x-www-form-urlencoded` or `multipart/form-data`.

- token_length (default:16);

Length of the token string. Max value is 40.

- session_key (default:"csrfblock.token")

This middleware uses [Plack::Middleware::Session](http://search.cpan.org/perldoc?Plack::Middleware::Session) for token storage. this is
the session key for that.

- blocked (default:403 response)

The application called when CSRF is detected.

Note: This application can read posted data, but DO NOT use them!

- onetime (default:FALSE)

If this is true, this middleware uses __onetime__ token, that is, whenever
client sent collect token and this middleware detect that, token string is
regenerated.

This makes your applications more secure, but in many cases, is too strict.

# CAVEATS

This middleware doesn't work with pure Ajax POST request, because it cannot
insert the token parameter to the request. We suggest, for example, to use
jQuery Form Plugin like:

    <script type="text/javascript" src="jquery.js"></script>
    <script type="text/javascript" src="jquery.form.js"></script>

    <form action="/api" method="post" id="theform">
      ... blah ...
    </form>
    <script type="text/javascript>
      $('#theform').ajaxForm();
    </script>

so, the middleware can insert token `input` tag next to `form` start tag,
and the client can send it by Ajax form.

# AUTHOR

Rintaro Ishizaki <rintaro@cpan.org>

# SEE ALSO

[Plack::Middleware::Session](http://search.cpan.org/perldoc?Plack::Middleware::Session)

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHORS

- Rintaro Ishizaki <rintaro@cpan.org>
- William Wolf <throughnothing@gmail.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by William Wolf.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.