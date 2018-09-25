'use strict';

import gulp from 'gulp';
import babelify from 'babelify';
import eslint from 'gulp-eslint';
import uglify from 'gulp-uglify';
import browserify from 'browserify';
import sourcemaps from 'gulp-sourcemaps';
import source from 'vinyl-source-stream';
import buffer from 'vinyl-buffer';

const dest = 'dist';

gulp.task('test-js', () => {

	const options = {
		parserOptions: {
			ecmaVersion: 6,
			sourceType: 'module'
		},
		extends: 'eslint:recommended',
		rules: {
			'quotes': ['error', 'single'],
			'linebreak-style': ['error', 'unix'],
			'eqeqeq': ['warn', 'always'],
			'indent': ['error', 'tab']
		}
	};

	return gulp.src('src/**/*.js')
		.pipe(eslint(options))
		.pipe(eslint.format())
		.pipe(eslint.failAfterError())
});

gulp.task('js', gulp.series('test-js', () => {

	const b = browserify({
		debug: true,
		entries: 'src/app.js'
	});

	b.transform('babelify', {
		presets: ['@babel/preset-env'], sourceMaps: true
	});

	return b.bundle()
		.pipe(source('app.js'))
		.pipe(buffer())
		.pipe(sourcemaps.init())
		.pipe(uglify())
		.pipe(sourcemaps.write('.'))
		.pipe(gulp.dest(dest));
}));


gulp.task('test', gulp.parallel('test-js'));

gulp.task('default', gulp.parallel('js'));

gulp.task('watch', gulp.series('default', (done) => {
	gulp.watch('src/**/*.js', gulp.series('js'));
	done();
}));
