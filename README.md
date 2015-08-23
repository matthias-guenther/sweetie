Sweetie is a plugin for [jekyll](https://github.com/mojombo/jekyll) to count all links, images, pages, and the last
build time on a jekyll site. It can also grab the last changes of your bitbucket repositories.
You can then use this information at a any place in your jekyll project.

[![Gem Version](https://badge.fury.io/rb/sweetie.svg)](http://badge.fury.io/rb/sweetie)
[![Build Status](https://travis-ci.org/wikimatze/sweetie.svg?branch=master)](https://travis-ci.org/wikimatze/sweetie)


## Installation

```sh
$ gem install sweetie
```


## Usage

The easiest way is to add `require 'sweetie'` on the top of your Rakefile.

Before you build your page, you can run a rake task to update the status information of a page:


```ruby
desc 'write stats in the _config.yml'
task :create_stati do
  Sweetie::Conversion.conversion
end
```


A similar task can be implemented for the bitbucket repositories:


```ruby
desc 'write stats in the _config.yml'
task :create_bitbucket do
  Sweetie::Bitbucket.bitbucket("yourname")
end
```


## Configuration variables of jekyll

Call the class method `Sweetie::Bitbucket.bitbucket("yourname")` and it will automatically append
the `build`, `htmlpages`, `images`, and `links` in your `_config.yml` file. You can then use them
everywhere in your page with the liquid snippet for example:

- `{{ site.build }}`
- `{{ site.htmlpages }}`
- `{{ site.images }}`
- `{{ site.links }}`


## Last changes of bitbucket repository

Call the class method `Sweetie::Bitbucket.bitbucket("yourname")` and it will automatically append the repository name an
the last change of the repository in your `_config.yml`. Here is an example:


```yml
git: 2011-10-16
pmwiki-twitter-recipe: 2011-10-29
```


You can then use this variables in the view of your jekyll project with the liquid template. For example:


```markdown
### git

<section class="lastupdate">
Last update {{ site.git }}
</section>
...


### Twitter

<section class="lastupdate">
Last update {{ site.pmwiki-twitter-recipe }}
</section>
...
```


will result the following html:


```html
<h3 id="git">Git</h3>

<section class="lastupdate">
Last update 2011-10-16
</section>


<h3 id="twitter">Twitter</h3>

<section class="lastupdate">
Last update 2011-10-16
</section>
```


## License

This software is licensed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License).

© 2011-2015 Matthias Günther <matthias@wikimatze.de>.
