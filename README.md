# Stimulizer

Easily work with StimulusJS `data-*` attributes in views, templates, ViewComponents, Phlex templates, etc.

This gem is particularly handy in ViewComponents and Phlex.

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
  data-mynamespace--deeper--buttons-grid-component-url-color="#ff0000"
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
Include this in your model:

```ruby
class MyComponent < ApplicationComponent
  include Stimulizer
  # ...
```

Render the stimulusjs data strings into your template...

```html
  <!-- use the derived controller name -->
  <%= stimulus(:controller) %>   

  <!-- specify the controller explicity, and/or add more controllers -->
  <%= stimulus(controller: "another-controller foo-controller")
  
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
```
... or combine them:
```
  <%= stimulus(:controller, target: "button", action: "click->doThing")
```

## Using with Phlex (or if you want a hash)
By default, Stimulizer returns a html-style string of `data-*` attributes from the `stimulus()` method. But if you're using something like Phlex templates, or if you want to use this with a tag-building method, you might want the original Hash instead. You have two options:

### Class-level configuration
Use the 

```ruby
module Views
  class ApplicationView < Phlex::View
    include Stimulizer



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/stimulizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/stimulizer/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stimulizer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/stimulizer/blob/main/CODE_OF_CONDUCT.md).
