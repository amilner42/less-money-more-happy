# Less Money More Happy

An app which helps you track the money you spend, the categories you are
spending in, whether you are meeting your goals, and tons of random stats.
It's a MEEN stack App (Mongo, Express, Elm, Node) and it is also all in
Typescript.

NOTE: This was a random experiment, not a serious app.

NOTE: Do not use this app as a template to build an app. Use [this](https://github.com/amilner42/web-app-kickstarter)

### Local Dependencies

The project only has 3 local dependencies, `node` and `npm`, and `mongodb`.
  - node ~ V6.0.0
  - npm ~ V3.10.3
  - monodb ~ V3.2.9

You don't _need_ these versions, but it's more likely to work properly if at
least the major versions are correct.

### Set Up

Once you have those local dependencies, do the following:

```bash
# Install all project dependencies for frontend/backend, it may take a minute.
./bin/install.sh;
# Runs the initial migration against the database.
mongo localhost:27017/LessMoneyMoreHappy backend/migrations/1-init.migration.js
```

This has been tested on Mac/Linux and these 2 lines set everything up properly.
This project also works on Windows, but the syntax may be _slightly_ different
(I've had a windows user confirm that they set up the project).

##### Setup Failed

1. Do you have the local dependencies, are they correct versions? If not, go
do that _first_. (duh)

2. Did you run the 2 lines from setup? Make sure you run both! (duh)

2. If you're getting a "ERR PORT 3000 in use" type of error, that's because
you're already running something on port 3000, and so you need to first shut
that down so you can run this app.

3. If you're getting a "MONGO ... cant connect ... localhost:27017 ... " type
of error, you probably forgot to run your mongo server. Open another terminal
and run `mongod`, leave this running, it is through this process that you can
interact with your local mongodb. This process runs on port 27017, so that's
why the error message brings up that port.

### Developing

To develop run `./bin/dev.sh` and that will compile your frontend and backend
code, watch for changes, and host it on localhost:3000. For now I _think_ you
have to restart the server if you make backend changes, but this is easy to
fix with `nodemon` and will be fixed soon. For frontend changes just refresh
your browser (I'll probably also set up a live-reloader soon).

My IDE of choice to develop in is Atom, I have a soft spot in my heart for
Github (lots of <3). If you do choose to use Atom, you can get beautiful auto
complete for BOTH the frontend (Elm) and the backend (Typescript) by getting
the following atom plugins:
  - elmjutsu : A combination of elm goodies wrapped up in one plugin.
  - elm-format : Allows you to run elm-format on save, very convenient.
  - atom-typescript : the only typescript plugin you will ever need.
  - auto-detect-indentation : 2-space-tab in TS, 4-space-tab in Elm, get a
    package to handle the switch for you automatically.

I highly recommend getting Atom with the plugins above, it'll only take a few
minutes and your development experience across the full stack will be great!

### Project File Structure

Let's keep it simple...
  - frontend in `/frontend`
  - backend in `/backend`
  - tooling scripts in `/bin`
  - extra docs in `/docs`

As well, the [frontend README](/frontend/README.md) and the
[backend README](/backend/README.md) each have a segment on their file
structure.

### License

BSD 3-Clause license. Refer to LICENSE.txt.
