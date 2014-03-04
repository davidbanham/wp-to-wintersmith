fs = require 'fs'
mkdirp = require 'mkdirp'
mustache = require 'mustache'

mode = 0o0775

Writer = ->
  return this

Writer.prototype.write_authors = (authors) ->
  mkdirp.sync './contents/authors', mode
  fs.writeFileSync("./contents/authors/#{author.shortname}", JSON.stringify(author)) for author in authors

Writer.prototype.write_content = (obj) ->
  template = fs.readFileSync('./lib/templates/article.mustache').toString()
  for post in obj.posts
    console.log post
    post_folder = "./contents/articles/#{post.filename}"
    mkdirp.sync(post_folder, mode)
    post = mustache.render template, post
    fs.writeFileSync "#{post_folder}/index.md", post

module.exports = new Writer()
