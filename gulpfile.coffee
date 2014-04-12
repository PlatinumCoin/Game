gulp = require 'gulp'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'

gulp.task 'coffee', () ->
	gulp.src 'public/*.coffee'
		.pipe coffeelint()
		.pipe coffee()
		.pipe gulp.dest 'public/dist'

gulp.task 'default', () ->
	gulp.watch 'public/*.coffee', ['coffee']