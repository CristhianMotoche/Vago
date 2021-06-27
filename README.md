# Vago

A simple tool to automate my common tasks.

## Dependencies

- ghc
- cabal
- ghcid (optional)

## Set up

```
cabal build
```

### Use `ghcid` (Optional)

Copy the following `.ghcid` file:

```
:set -isrc -iapp
:load app/Main.hs
```

Then use `ghcid` to run `ghci`:

```
ghcid --command "cabal exec ghci"
```

*Note:* I couldn't make this work with `cabal repl` (default ghcid command) because it could not load
the [executable and the library at the same time](https://www.reddit.com/r/haskell/comments/jdhocz/how_to_have_the_executable_main_module_in_cabal/g98ers6/).

## Run

```
cabal exec v
```

## TODO:
### Phase 1
- [x] Authentication
- [x] Start new times
- [x] List current tasks

### Phase 2
- [ ] Read common project and tasks from a file
- [ ] Alist to start new event
- [ ] Stop current task
- [ ] Restart one of he listed tasks
