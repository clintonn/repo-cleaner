# Installation
`bundle`

# Config
`touch .env`

In your `.env` file, add the following key-value pairs:

```
GITHUB_PAT=
GITHUB_USER_ID=
GITHUB_USERNAME=
FS_MATCHER=
```

Where `GITHUB_PAT` is a [generated personal access token](https://github.com/settings/tokens), `GITHUB_USER_ID` can be found [here](https://caius.github.io/github_id/), and `FS_MATCHER` is a string to match to repository names.

# Running
`ruby main.rb`

**WARNING**: Answering `y` at the prompt WILL delete all the repos printed that match the `FS_MATCHER` you provide.
