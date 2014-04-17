gulp = require 'gulp'
clean = require 'gulp-clean'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'

source = 'scripts/*.coffee'
destination = 'public/build'

gulp.task 'clean', () ->
	gulp.src destination
		.pipe clean()

gulp.task 'coffee-lint', () ->
	gulp.src [source, '*.coffee']
		.pipe coffeelint('.coffeelintrc')
		.pipe coffeelint.reporter()

gulp.task 'coffee-build', () ->
	gulp.src source
		.pipe coffee(sourceMap: true)
		.pipe gulp.dest destination

gulp.task 'coffee', ['coffee-lint', 'coffee-build']

gulp.task 'default', ['coffee'], () ->
	gulp.watch source, ['coffee']
