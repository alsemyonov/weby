# Weby

[![Dependency Status](https://gemnasium.com/alsemyonov/weby.svg)](https://gemnasium.com/alsemyonov/weby)
[![security](https://hakiri.io/github/alsemyonov/weby/master.svg)](https://hakiri.io/github/alsemyonov/weby/master)
[![Build Status](https://travis-ci.org/alsemyonov/weby.svg?branch=master)](https://travis-ci.org/alsemyonov/weby)
[![Code Climate](https://codeclimate.com/github/alsemyonov/weby/badges/gpa.svg)](https://codeclimate.com/github/alsemyonov/weby)
[![Test Coverage](https://codeclimate.com/github/alsemyonov/weby/badges/coverage.svg)](https://codeclimate.com/github/alsemyonov/weby/coverage)
[![Issue Count](https://codeclimate.com/github/alsemyonov/weby/badges/issue_count.svg)](https://codeclimate.com/github/alsemyonov/weby)
[![Coverage Status](https://coveralls.io/repos/github/alsemyonov/weby/badge.svg?branch=master)](https://coveralls.io/github/alsemyonov/weby?branch=master)

Make better web by using semantics in your personal site.

## Middleman::Sitemap

*   {Weby::Sitemap} — Resource for `Middleman::Sitemap`

    *   Expose {Weby::Sitemap#roots}, {Weby::Sitemap#root} methods on `app.sitemap`.
    *   Sorting for `Middleman::Sitemap::Resource` based on {Weby::Resource::Sortable} extension.

## Middleman::Sitemap::Resource

### Modules

*   {Weby::Resource::MetaData}

    ``` yaml
    title: Page title used in navigation
    slug: Include in navigation
    description: Page description used in <meta name="description">
    keywords: Keywords for <meta name="keywords">
    tags: Keywords for <meta name="keywords">
    ```

*   {Weby::Resource::Navigatable}

    ``` yaml
    menu:
      title: Page title used in navigation
      menu: true # (include in menu)
      relations:
      - href: /about.foaf.xml
        type: 'application/rdf+xml'
    ```

*   {Weby::Resource::Publishable}
*   {Weby::Resource::Sortable} — includes `Comparable` and provide sorting rules based on `frontmatter.position`, `frontmatter.published_at` and `url`

    ``` yaml
    position: 1 # Position of
    ```
*   {Weby::Resource::Typify} — resources classification. Known types are: `resource` (default), `middleman-blog` Resource: `article`, `tag`, `year`, `month`, `day`

*   {Weby::Resource::Schema}

    ``` yaml
    type: article
    ```

### Methods:

* `Middleman::Sitemap::Resource#ogp`
* `Middleman::Sitemap::Resource#navigation`

### Frontmatter Data

*   `title` (`current_resource.title`) — title of the page. Used as default for head title (can be overriden by `navigation.#{i18n_key}.title`)
*   `position` (`current_resource.position.title`) — position of page when sort
*   `ogp` (`current_resource.ogp`) — OGP overrides for current resource
*   `description` (`current_resource.description`) — meta name="description"
