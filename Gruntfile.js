module.exports = function(grunt) {
  grunt.initConfig({
    cssmin: {
        all: {
            src: [
                "./jrmcc/themes/cocoa/static/css/font.css",
                "./jrmcc/themes/cocoa/static/css/fontello.css",
                "./jrmcc/themes/cocoa/static/css/zenburn.css",
                "./jrmcc/themes/cocoa/static/css/style.css"
            ],
            dest: "./jrmcc/themes/cocoa/static/css/combined.css"
        }
    },
    watch: {
      files: ['./jrmcc/themes/cocoa/static/css/*.css', "!./jrmcc/themes/cocoa/static/css/combined.css"],
      tasks: ['cssmin'],
    },
  });

  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', ['cssmin']);

};
