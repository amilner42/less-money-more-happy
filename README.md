# Less Money More Happy

An app which helps you track the money you spend, the categories you are
spending in, whether you are meeting your goals, and tons of random stats.
It's a MEEN stack App (Mongo, Express, Elm, Node) and it is also all in
Typescript.

### Local Dependencies

The project only has 3 local dependencies, `node` and `npm`, and `mongodb`.
  - node ~ V6.0.0
  - npm ~ V3.10.3
  - monodb ~ V3.2.9

You don't _need_ these versions, but it's more likely to work properly if at
least the major versions are correct.

### Set Up

Once you have those local dependencies, simply run `./bin/install.sh` to install
all node/elm modules as well as typings...that's it!

### Developing

To develop run `./bin/dev.sh` and that will compile your frontend and backend
code, watch for changes, and host it on localhost:3000.

My IDE of choice to develop in is Atom, I have a soft spot in my heart for
Github (lots of <3). If you do choose to use Atom, you can get beautiful auto
complete for BOTH the frontend (Elm) and the backend (Typescript) by getting
the following atom plugins:
  - elmjutsu : A combination of elm goodies wrapped up in one plugin.
  - elm-format : Allows you to run elm-format on save, very convenient.
  - atom-typescript : the only typescript plugin you will ever need.

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

Private.
