# Wp to Wintersmith

This repo will take a Wordpress export and convert it into contents compatible with a Wintersmith blog.

# Howto:

- Export all your content from your wordpress blog. You should end up with a big gross blob of xml.
- Clone this repository
- npm install
- run `node index.js THE_NAME_OF_YOUR_EXPORT_FILE.xml`
- copy the contents folder to your Wintersmith blog

# Caveats
- This attributes every post to the first author it finds. I couldn't immediately see how the WP dump associated posts with authors and I got sick of looking through XML.
