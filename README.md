# HistoriKC

Welcome to HistoriKC Rails! Check out this site deployed at [http://historikc.com](https://historikc.com).

HistoriKC is an attempt to make historic photos of Kansas City more accessible. Despite our rich history and great
repositories of photos like KC Public Library's Missouri Valley Special Collections, it was still difficult to explore photos
by areas of the city.

Locations within the application are intersections pulled from OpenStreetMap. All photos are sourced from the Missouri Valley
Special Collections, and are loaded via a rake task which looks at various photo attributes to determine the nearest location.

## Contributing

Have an idea and the time to implement it? Awesome, submit a pull request and I'll take a look! In general, I follow the
[ruby-style-guide](https://github.com/bbatsov/ruby-style-guide) for styling.

## License

HistoriKC Rails is released under the Apache v2.0 License. See the [LICENSE file](https://github.com/kyledrowan/historikc-rails/blob/master/LICENSE)
for more information.

# Getting Started with Development
* `gem install bundler`
* `bundle`

## To test Authorization:
* Prerequisites: `gpg`
* `brew install git-secret`
* Create a gpg key/secret, and send your public key to someone who has access to the secret
* They need to run `gpg --import KEY_NAME.txt`, `git secret tell youremail@example.com`, `git secret reveal; git secret hide`, then commit the changes
* Run `git secret reveal` to decrypt the secret file (`config/initializers/auth0.rb`)
* When changing the secret file, you must run `git secret hide` before committing. To make this a pre-commit hook, run `echo "git secret hide\ngit add config/initializers/auth0.rb.secret" > .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit`
