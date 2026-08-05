# rails-runtimes-host

Public host application for the [rails-runtimes](https://github.com/laquereric/rails-runtimes)
TODO proof of concept. Implements the `public-todo/v1` protocol receiver, user
registration from dialing clients, and an administrator dashboard that shows
the aggregate of public TODOs only.

Apache-2.0.

## What it does

- Accepts `POST /api/v1/installations` with `X-Registration-Code` (demo dial-in)
- Accepts `POST /api/v1/sync/events` with a bearer installation token
- Stores public projections only (`todo.publish` / `todo.withdraw`)
- Admin UI at `/admin` (session login; credentials from environment)

## Runtime manifest

The host declares Core (validation rules) and Server (persistence, tokens, admin)
slices via `config/initializers/rails_runtimes.rb`.

## Docker Desktop demo

Pair this repository with `rails-runtimes` and a generated TODO client. See
[rails-runtimes/demo/README.md](https://github.com/laquereric/rails-runtimes/blob/main/demo/README.md)
for the exact compose walkthrough.

## Local development

```bash
export RAILS_RUNTIMES_PATH=../rails-runtimes
bundle install
bin/rails db:prepare db:seed
bin/rails server -p 3000
```

## License

Apache-2.0. See `LICENSE`.
