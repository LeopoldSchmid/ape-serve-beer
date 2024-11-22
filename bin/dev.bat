@echo off
SET PORT=3000
SET RUBY_DEBUG_OPEN=true
SET RUBY_DEBUG_LAZY=true

start cmd /c "rails tailwindcss:watch"
start cmd /c "rails server"
