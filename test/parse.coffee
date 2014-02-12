assert = require 'assert'
parser = require '../lib/parser'

posts_obj =
  rss:
    $:
      version: "2.0"
      "xmlns:content": "http://purl.org/rss/1.0/modules/content/"
      "xmlns:dc": "http://purl.org/dc/elements/1.1/"
      "xmlns:excerpt": "http://wordpress.org/export/1.2/excerpt/"
      "xmlns:wfw": "http://wellformedweb.org/CommentAPI/"
      "xmlns:wp": "http://wordpress.org/export/1.2/"

    channel: [
      description: ["blog description text"]
      generator: ["http://wordpress.org/?v=3.8.1"]
      item: [
        category: [
          $:
            domain: "category"
            nicename: "uncategorized"

          _: "Uncategorized"
        ]
        "content:encoded": ["The text of a blog post"]
        "dc:creator": ["legacy"]
        description: [""]
        "excerpt:encoded": [""]
        guid: [
          $:
            isPermaLink: "false"

          _: "http://www.example.com/wordpress/?p=21"
        ]
        link: ["http://example.com/?p=7"]
        pubDate: ["Tue, 30 Nov 1999 00:00:00 +0000"]
        title: ["The title of a blog post"]
        "wp:comment_status": ["open"]
        "wp:is_sticky": ["0"]
        "wp:menu_order": ["0"]
        "wp:ping_status": ["open"]
        "wp:post_date": ["1999-11-30 00:00:00"]
        "wp:post_date_gmt": ["1999-11-30 00:00:00"]
        "wp:post_id": ["7"]
        "wp:post_name": ["the-title-of-a-blog-post"]
        "wp:post_parent": ["0"]
        "wp:post_password": [""]
        "wp:post_type": ["post"]
        "wp:status": ["publish"]
      ]
      language: ["en-US"]
      link: ["http://example.com"]
      pubDate: ["Wed, 12 Feb 2014 03:49:30 +0000"]
      title: ["blog title"]
      "wp:author": [
        "wp:author_display_name": ["legacy"]
        "wp:author_email": [""]
        "wp:author_first_name": [""]
        "wp:author_id": ["2"]
        "wp:author_last_name": [""]
        "wp:author_login": ["legacy"]
      ,
        "wp:author_display_name": ["davidbanham"]
        "wp:author_email": ["David@banham.id.au"]
        "wp:author_first_name": ["David"]
        "wp:author_id": ["1"]
        "wp:author_last_name": ["Banham"]
        "wp:author_login": ["admin"]
      ]
      "wp:base_blog_url": ["http://example.com"]
      "wp:base_site_url": ["http://example.com"]
      "wp:wxr_version": ["1.2"]
    ]

post = posts_obj.rss.channel[0].item[0]

describe 'parser', ->
  describe 'parse', ->
    it 'should parse the title', ->
      parsed = parser.parse post
      assert.equal parsed.title, 'The title of a blog post'

    it 'should parse the filename', ->
      parsed = parser.parse post
      assert.equal parsed.filename, 'the-title-of-a-blog-post'

    it 'should parse the date', ->
      parsed = parser.parse post
      assert.equal parsed.date.toISOString(), new Date('Tue, 30 Nov 1999 00:00:00 +0000').toISOString()

    it 'should parse the content', ->
      parsed = parser.parse post
      assert.equal parsed.content, 'The text of a blog post'
  describe 'globals', ->
    it 'should parse the author', ->
      parsed = parser.globals posts_obj
      assert.deepEqual parsed.authors[1],
        name: 'David Banham'
        email: 'David@banham.id.au'
        shortname: 'davidbanham'

  describe 'posts', ->
    it 'should parse the correct number of posts', ->
      posts = parser.posts posts_obj
      assert.equal posts.length, 1

  describe 'wrapper', ->
    it 'should return all parsed posts', ->
      posts = parser.wrapper(posts_obj).posts
      assert.equal posts.length, 1

    it 'should return parsed posts', ->
      posts = parser.wrapper(posts_obj).posts
      assert.equal posts[0].filename, 'the-title-of-a-blog-post'

    it 'should return the globals', ->
      globals = parser.wrapper(posts_obj).globals
      assert.equal globals.authors[1].email, 'David@banham.id.au'
