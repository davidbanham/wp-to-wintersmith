Parser = ->
  return this

Parser.prototype.parse = (post) ->
  parsed =
    title: post.title
    filename: post["wp:post_name"]
    date: new Date(post.pubDate)
    content: post['content:encoded']

Parser.prototype.globals = (input) ->
  obj = input.rss
  channel = obj.channel[0]
  authors = channel['wp:author']
  parsed_authors = []
  for author in authors
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
