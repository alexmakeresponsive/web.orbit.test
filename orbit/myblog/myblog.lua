#!/usr/bin/env wsapi.cgi

local orbit = require "orbit"

-- Orbit applications are usually modules,
-- orbit.new does the necessary initialization

module("myblog", package.seeall, orbit.new)

-- These are the controllers, each receives a web object
-- that is the request/response, plus any extra captures from the
-- dispatch pattern. The controller sets any extra headers and/or
-- the status if it's not 200, then return the response. It's
-- good form to delegate the generation of the response to a view
-- function

function index(web)
  return render_index()
end

function say(web, name)
  return render_say(web, name)
end

-- Builds the application's dispatch table, you can
-- pass multiple patterns, and any captures get passed to
-- the controller

myblog:dispatch_get(index, "/", "/index")
myblog:dispatch_get(say, "/say/(%a+)")
myblog:dispatch_static("/style%.css")

-- These are the view functions referenced by the controllers.
-- orbit.htmlify does through the functions in the table passed
-- as the first argument and tries to match their name against
-- the provided patterns (with an implicit ^ and $ surrounding
-- the pattern. Each function that matches gets an environment
-- where HTML functions are created on demand. They either take
-- nil (empty tags), a string (text between opening and
-- closing tags), or a table with attributes and a list
-- of strings that will be the text. The indexing the
-- functions adds a class attribute to the tag. Functions
-- are cached.
--

-- This is a convenience function for the common parts of a page

function render_layout(inner_html)
   return html{
     head{
        title"Hello",
        link{
            rel = 'stylesheet', type = 'text/css',
            href = '/orbit/myblog/style.css', media = 'screen'
        },
     },
     body{ inner_html }
   }
end

function render_hello()
   return p.h2"Hello World!"
end

function render_index()
   return render_layout(render_hello())
end

function render_say(web, name)
   return render_layout(render_hello() .. 
     p.hello((web.input.greeting or "Hello ") .. name .. "!"))
end

orbit.htmlify(myblog, "render_.+")
