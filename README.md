# A Bash / PostgreSQL Migration Tool #

This is a simple migration tool written in BASH, for defining sets of changes while updating a database schema.

## Usage ##

./main.sh <action>

Available actions:
- init
    - Initializes, creating a table in the DB and a migrations folder.
- create <name>
    - Creates a new migration in the initialized folder.
- pending
    - Display all pending migrations
- previous
    - Display all previous migrations
- migrate
    - Make all migrations
- rollback
    - Rollback all migrations

## Work in progress ##

- [x] Basic migration system
- [ ] Individual UP's and DOWN's
- [ ] Better error handling
- [ ] Prettier output
