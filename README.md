# Stimulizer

Easily work with StimulusJS `data-*` attributes in ViewComponents, Phlex templates, etc.

This gem is particularly handy in ViewComponents and Phlex when you have a 1-1 relationship between a component and a Stimulus controller, especially when using 'sidecar' controllers.

For example:

### ViewComponent
```ruby
  class Mynamespace::Deeper::ButtonsGridComponent < ApplicationComponent
  # ...
```
#### Before
```html
<div 
  data-controller="mynamespace--deeper--buttons-grid-component"
  data-mynamespace--deeper--buttons-grid-component-url-value="http://example.com"
  data-mynamespace--deeper--buttons-grid-component-color-value="#ff0000"
  data-action="click->data-mynamespace--deeper--buttons-grid-component#doSomething"
>
```

#### After
```html
<div 
  <%= stimulus(
    :controller, 
    values: {url: "http://example.com", color: "#ff0000"}, 
    action: "click->doSomething"
  )%>
>
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stimulizer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install stimulizer

## Usage
### in a classic ERB View
Include the module in your ApplicationController (or individual controllers):

```ruby
class ApplicationController < ActionController::Base
  include Stimulizer
  helper_method :stimulus
  # ...
```
NOTE that you have to add `helper_method :stimulus` to ensure the view templates can use the `stimulus` method.

### in a ViewComponent
Include this in your class:

```ruby
class MyComponent < ApplicationComponent
  include Stimulizer
  # ...
```

Render the stimulusjs data strings into your template...

```html
  <!-- use the derived controller name -->
  <%= stimulus(:controller) %>   

  <!-- specify the controller explicity, and/or add more controllers space-separated -->
  <%= stimulus(controller: "another foo")
  
  <!-- Note: 'action' is singular because it works like 'data-action' -->
  <%= stimulus(action: "click->doThing")

  <!-- but you can have multiple actions separated by spaces -->
  <%= stimulus(action: "click->doThing mouseup->otherThing")

  <!-- you can also skip the event, just like usual -->
  <%= stimulus(action: "doThing")

  <!-- 
    target for this element (if you need to also target it for other controllers, you'll have to do that manually with the old 'data-blah-target=' approach)
  -->
  <%= stimulus(target: "button")

  <!-- supports the 'classes' feature -->
  <%= stimulus(classes: {foo: "text-red-500", busy: "opacity-50 animate-spin"})
  
  <!-- supports the 'values' feature -->
  <%= stimulus(values: {url: "https://example.com"})

  <!-- supports the 'params' feature -->
  <%= stimulus(params: {foo: "bar", this_thing: "whatever"})
     
  <!-- supports the 'outlets' feature -->
  <%= stimulus(outlets: {foo: ".my-class", bar: "#widget"})     
```
... or combine them:
```
  <%= stimulus(:controller, target: "button", action: "click->doThing")
```

## Options

### `stimulize`
Use the `stimulize` method after including the module to set some config options...

#### `ignore_prefix`
Use the `ignore_prefix` option to chop off some of the namespacing if you want to shorten up those crazy-long controller filenames.
```ruby
stimulize ignore_prefix: "Components::"
```

#### `output`
Use the `output` option to change from an html-style string of data attributes (default) to a Hash of data attributes, useful in other circumstances, like tag builders and Phlex views.
```ruby
stimulize output: :hash
```

## Overriding the derived controller name
My main use case for Stimulizer is with so-called 'sidecar' javascript. That is, if I have a component in the filepath `components/foo/bar/other/button_component.rb`, I will also have a stimulus controller at `components/foo/bar/other/button_component_controller.js`. 

**In this case, Stimulizer will auto-derive the controller name properly.**

If you're not doing things this way, you may need to manually set your controller name in each component/template...

```ruby
def stimulus_controller
  "whatever--name--you-want-here"
end
```

**or...**

You can also pass the controller name directly to the `stimulus()` method. This starts to become less automagical, but still handy in reducing the repetition of those controller names.

```ruby
<div
  <%= stimulus(
    controller_name: "my--fancy--buttons", 
    action: "click->show", 
    values: {url: "example.com"}
  ) %>
>

# => <div data-controller='my--fancy--buttons' data-action='click->my--fancy--buttons#show' data-my--fancy--buttons-url-value="example.com">
```

## Using with Phlex (or if you want a hash for some other reason)
By default, Stimulizer returns a html-style string of `data-*` attributes from the `stimulus()` method. But if you're using something like Phlex templates, or if you want to use this with a tag-building method, you might want the original Hash instead. You have two options:

### 1. Class-level configuration
```ruby
module Views
  class ApplicationView < Phlex::View
    include Stimulizer
    stimulize output: :hash
```

### 2. Specifically ask for a hash with `stimulus_hash` instead
```ruby
stimulus_hash(:controller, action: "click->doThis")
```

## Phlex: Destructuring for the win!
Thanks to [@joeldrapper](https://github.com/joeldrapper) for suggesting this and for inspiring the idea of this gem. You can use destructuring to great effect in Phlex views:

```ruby
div(**stimulus(:controller, action: "click->show"), class: "text-red-500") do
  # ...
```
*Note that this example is assuming you've turned on `:hash` mode as above. You could also use `**stimulus_hash()` in the same way.*

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/stimulizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/stimulizer/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stimulizer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/stimulizer/blob/main/CODE_OF_CONDUCT.md).
