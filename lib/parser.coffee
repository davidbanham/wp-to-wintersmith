to_markdown = require('to-markdown').toMarkdown

Parser = ->
  return this

Parser.prototype.parse = (post) ->
  parsed =
    title: post.title[0].replace(':', '')
    filename: post["wp:post_name"]
    date: new Date(post.pubDate).toUTCString()
    content: to_markdown post['content:encoded'][0]

Parser.prototype.globals = (input) ->
  obj = input.rss
  channel = obj.channel[0]
  authors = channel['wp:author']
  parsed_authors = []
  for author in authors when author['wp:author_display_name'][0] isnt 'legacy'
    fullname = "#{author['wp:author_first_name']} #{author['wp:author_last_name']}"
    parsed_authors.push
      email: author['wp:author_email'][0]
      name: fullname
      shortname: fullname.split(' ').join('').toLowerCase()
  parsed =
    authors: parsed_authors

Parser.prototype.posts = (input) ->
  posts = []
  posts.push post for post in input.rss.channel[0].item
  return posts

Parser.prototype.wrapper = (input) ->
  posts = @posts input
  parsed_posts = []
  parsed_posts.push(@parse(post)) for post in posts
  globals = @globals input
  parsed =
    posts: parsed_posts
    globals: globals

module.exports = new Parser()
