# MakerNet Additional Capabilities

The following functionallity is inherited from the FabManager project but may come handy in the
future develpment of MakerNet.

- [MakerNet Additional Capabilities](#makernet-additional-capabilities)
  - [Open Projects](#open-projects)
  - [Plugins](#plugins)
  - [Single Sign-On](#single-sign-on)

## Open Projects

**This configuration is optional**

You can configure MakerNet to synchronize every project with the [Open Projects platform](https://github.com/LaCasemate/openlab-projects). In return, your users will be able to search over
projects from all MakerNet instances from within your platform. The deal is fair, you share your
projects and as reward you benefits from projects of the whole community.

To start using this awesome feature, there are a few steps:

- Send a mail to **contact@fab-manager.com** asking for your Open Projects client's credentials and
  giving them the name of your space. They will give you an `OPENLAB_APP_ID` and an
  `OPENLAB_APP_SECRET`
- Fill in the value of the keys in your `env` file.
- Start your MakerNet app.
- Export your projects to open-projects (if you already have projects created on MakerNet, unless
  you can skip that part) executing this command: `bundle exec rake fablab:openlab:bulk_export`

**IMPORTANT: please run your server in production mode.**

Go to your projects gallery and enjoy seeing your projects available from everywhere ! That's all.

## Plugins

MakerNet has a system of plugins mainly inspired by [Discourse](https://github.com/discourse/discourse)
architecture.

It enables you to write plugins which can:
- Have its proper models and database tables
- Have its proper assets (js & css)
- Override existing behaviours of MakerNetwork
- Add features by adding views, controllers, ect...

To install a plugin, you just have to copy the plugin folder which contains its code into the folder
`plugins` of MakerNet.

You can see an example on the [repo of navinum gamification plugin](https://github.com/LaCasemate/navinum-gamification)

## Single Sign-On

MakerNet can be connected to a [Single Sign-On](https://en.wikipedia.org/wiki/Single_sign-on) server
which will provide its own authentication for the platform's users. Currently OAuth 2 is the only
supported protocol for SSO authentication.

For an example of how to use configure a SSO in MakerNet, please read [sso_with_github.md](doc/sso_with_github.md). Developers may find information on how to implement their own
authentication protocol in [sso_authentication.md](doc/sso_authentication.md).
