Ruby Script Server
==================

A web server serving Ruby scripts compiled to javascript

The project
-----------

The code release in this repository is the code described on an article
presenting a Ruby to Javascript compiler: http://alef1.org/articles/a_ruby_to_javascript_compiler_opal.html

## Example

The _public_ and _src_ directories contain the last example of the
article. It just gives access to a HTML page that only contains a 
reference to a Ruby script that the server is compiling before
sending the compiled javascript back to the browser.

After installing the required gems (use bundle with the project's Gemfile.lock).

Start the server with next command:

```bash
ruby -I. server_starter.rb 
```

Navigate to next URL

    http://localhost:3000/say_hello.html

\- Jean Lazarou
 
