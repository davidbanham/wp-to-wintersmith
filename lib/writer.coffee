fs = require 'fs'
mkdirp = require 'mkdirp'
mustache = require 'mustache'

mode = 0o0775

Writer = ->
  return this

Writer.prototype.write_authors = (authors) ->
  mkdirp.sync './contents/authors', mode
  fs.writeFileSync("./contents/authors/#{author.shortname}.json", JSON.stringify(author)) for author in authors when author.name isnt ' '

Writer.prototype.write_content = (obj) ->
  template = fs.readFileSync('./lib/templates/article.mustache').toString()
  for post in obj.posts
    post.author = obj.globals.authors[0].shortname
    post_folder = "./contents/articles/#{post.filename}"
    mkdirp.sync(post_folder, mode)
    post = mustache.render template, post
    fs.writeFileSync "#{post_folder}/index.md", post

module.exports = new Writer()
