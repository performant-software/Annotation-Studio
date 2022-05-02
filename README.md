# Annotation Studio
An annotation platform designed for teaching and learning in the humanities,
and with aspirations to more general use.

## Works with: MIT Annotation Data Store
There are two servers required to run this application. This one, and the [MIT
Annotation Data Store](https://github.com/hyperstudio/MIT-Annotation-Data-Store
).

You __MUST__ get the Annotation server running to be able to create or view
annotations.

# Getting Started

## Things to install
Annotation Studio uses PostgreSQL

The MIT Annotation Data Store requires Node.js (0.10.21), NPM (1.3.11) and
MongoDB

## General Installation
Set up Rails (if you haven't yet, try: [thoughtbot's Laptop repo]
(https://github.com/thoughtbot/laptop))

- ```git clone git@github.com:hyperstudio/Annotation-Studio.git
annotation-studio```
- ```cd annotation-studio```
- ```./bin/setup```

which will:

* Drop existing databases
* Run migrations and prepare the test database
* Seed the application
* Install the MIT Annotation Data Store under `./tmp/annotation_data_store`
* Create an example application.yml

After setting up the app, run:

```bash
bundle exec foreman start -f Procfile.dev
```

to spin up development dependencies. You can exist the development daemons by
hitting ctrl-c, per normal unix semantics.

### Installation on Heroku
If you would like to run the application on Heroku (recommended), do the
following

- Create a Heroku app `heroku apps:create $APPNAME`
- Add the Heroku PostgreSQL add-on `heroku addons:add heroku-postgresql`
  - Don't worry about providing db configuration, [Heroku will do it for you]
(https://devcenter.heroku.com/articles/heroku-postgresql#connecting-in-rails)
- Use Figaro to load your `application.yml` into environment variables and
communicate them to Heroku
  -  `rake figaro:heroku[$APPNAME]`

### Multitenancy
This app uses the [apartment gem](http://github.com/influitive/apartment) to allow multiple domains to be hosted in a single instance.  

To create a new tenant:

#### Requirements
* Tenant banner image
* Tenant accent color (hex code)

#### Rails config
* Upload banner image to  `app/assets/images/`
* Create tenant metadata file in `app/views/saml/` (use an existing tenant  metadata file as a guide)
* Create tenant brand file in `app/views/shared/` (use an existing tenant brand file as a guide)
* Add entry for new tenant to `config/domain_specific/config.yml` (use an existing tenant entry as a guide)
* Precompile assets:  `RAILS_ENV=production bundle exec rake assets:precompile && git add public/assets/ && git commit -m "Add precompiled assets"`

#### Add Google Analytics code
* Create property for new tenant at  **Admin > Create Property**, then create data stream for newly created tenant property
	* Data stream platform: Web
	* Note the created Measurement ID (“G-XXXXXXXX”) — this will be used when creating a tenant record in the admin dashboard

#### Admin dashboard config
* Add new tenant record to Tenants menu in admin dashboard at [ Annotation Studio Dashboard - Tenants](https://cove-studio.herokuapp.com/admin/tenants) (use existing tenant record as a guide)
	* If setting up a staging site, admin dashboard is at [Annotation Studio Dashboard - Tenants (Staging)](https://cove-staging.herokuapp.com/admin/tenants)

#### Add DNS listing to Heroku
* **@jamiefolsom** typically creates a CNAME record for the new tenant; once this is done, add the new domain to the `cove-studio` app in Heroku under **Settings > Domains**



#### Copy over vetted documents
  * Run the `copy_vetted_documents` rake task through the Heroku CLI:
	* `heroku run rake copy_vetted_documents[source-db,destination-db] -a cove-studio`
  * `source-db` value is usually `cove-studio`

#### Add initial user
* Using rails console, create a new User for Dino Felluga (felluga@purdue.edu)
* Be sure to switch over to new tenant database first (`Apartment::Tenant.switch(‘name-of-tenant-db`)
* Add admin role to user (`User.find(1).set_roles = [“admin”]`)

#### Deploy to production

#### SAML integration

You will need to integrate COVE with the new tenant's SAML system. There are certain requirements for the settings:

* encryptAssertions should be set to false
* X509 fingerprint (usually the client provides a full certificate - you can Google for a website that converts it to a fingerprint)
* Attributes that need to be released by the client:
  * email: 'urn:oid:0.9.2342.19200300.100.1.3'
  * firstname: 'urn:oid:2.5.4.42'
  * lastname: 'urn:oid:2.5.4.4'

There will still be issues, because every school's system is just a little bit different.

A common issue is that the school forgets to disable encryptAssertions - when there are login issues, always double-check for this first. A typical sign of encryptAssertions being set incorrectly is when the user seems to sign in successfully, but is kicked back to the homepage. If you watch the server logs, you'll see `Authentication failure! invalid_ticket: OneLogin::RubySaml::ValidationError, An EncryptedAssertion found and no SP private key found on the settings to decrypt it.`, confirming that the setting is incorrect on the tenant's end.

#### Microsoft Azure

If the school uses Microsoft Azure, releasing the correct attributes in a way that COVE understands is a bit counterintuitive. For each attribute, the `name` field should be the "urn:oid" identifier from above.

The setup that Azure requires is:

| Name                              | Source Attribute |
| ---------                         | ---------------- |
| urn:oid:2.5.4.42                  | user.givenname   |
| urn:oid:2.5.4.4                   | user.surname     |
| urn:oid:0.9.2342.19200300.100.1.3 | user.mail        |

The "namespace" field on the names should be kept empty (there may be something there by default).

#### OpenAthens

As of this writing, two COVE tenants use OpenAthens.

OpenAthens requires a slightly different metadata file. In each of the two cases, the tenant had to do some special setup on their side.

Take a look at `doc/openathens_example_metadata.xml` for an example - this tenant reached out to OpenAthens support after lots of back-and-forth with us, and they provided the tenant with this working metadata file.

Especially note the `wantsAssertionsSigned="false"`. Turning off encrypted assertions tends to be a pain point for new tenants, and OpenAthens makes it especially challenging.

#### Caveats
1. If a domain does not have a matching Tenant, the default "public" tenant will be used.
2. Admin users are shared across all tenants, and therefore shouldn't be created and granted to single-tenant users

## User Support and Developer forum
http://support.annotationstudio.org

## Thanks
Thanks to:
- [NEH Office of Digital Humanities](http://www.neh.gov/odh) who has funded
this project
- [OKFN](http://okfn.org/) for supporting [The Annotator]
(http://annotatorjs.org)
- [Nick Stenning](https://github.com/nickstenning/) for being awesome and for
leading the Annotator developer team
- [Dan Whaley, Randall Leeds and hypothes.is](https://hypothes.is/) for being
awesome and supporting the Annotator Community
- [The Annotator community](https://github.com/openannotation/annotator/) for
plugins and being awesome.

## Contributors
### Lab
- MIT HyperStudio
- http://hyperstudio.mit.edu/

### Developers
- Jamie Folsom [@jamiefolsom](http://github.com/jamiefolsom)
- Liam Andrew [@mailbackwards](http://github.com/mailbackwards)
- Andrew Magliozzi [@andrewmagliozzi](http://github.com/andrewmagliozzi)
- Daniel Collis-Puro [@djcp](http://github.com/djcp)
- Seth Woodworth [@sethwoodworth](http://github.com/sethwoodworth)
- Ayse Gursoy [@gursoy](http://github.com/gursoy)
- Jacob Hilker [@jhilker](http://github.com/jhilker)

## License
GPL2: http://www.gnu.org/licenses/gpl-2.0.html
