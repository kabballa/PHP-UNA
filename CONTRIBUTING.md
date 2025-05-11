# Contributing Guidelines
### Requirements
# Contributing Guidelines

Contributions are welcome via GitHub Pull Requests. This document outlines the process to help get your contribution accepted.

Any type of contribution is welcome: new features, bug fixes, documentation improvements, etc.

## How to Contribute

1. **Fork the Repository**: Start by forking this repository to your own GitHub account.
2. **Develop and Test**: Make your changes, ensuring to test them thoroughly.
3. **Submit a Pull Request**: Once you are satisfied with your changes, submit a pull request.


> [!NOTE]
> To make the Pull Requests' (PRs) testing and merging process easier, please submit changes to multiple containers in separate PRs.

### Requirements

When submitting a PR, please ensure that:

- It must pass CI jobs for linting and test the changes (if any).
- The title of the PR is clear enough and starts with "[kabballa/PHP-UNA]"
- If necessary, add information to the repository's `README.md`.

#### Sign Your Work

Every commit must include a sign-off line at the end of the commit message. Your signature certifies that you wrote the patch or have the right to contribute the material. To sign off, add a line to every git commit message:


Then you just add a line to every git commit message:

```text
Signed-off-by: Your Name <your.email@example.com>
```

Use your real name (sorry, no pseudonyms or anonymous contributions.)

Make sure to use your real name (no pseudonyms or anonymous contributions).

If you have set your user.name and user.email in your git configuration, you can automatically sign your commits with:

```bash
git commit -s
```

Note: If your git configuration is set correctly, viewing the git log for your commit will show:


```text
Author: Your Name <your.email@example.com>
Date:   Thu Feb 2 11:41:15 2018 -0800

    Update README

    Signed-off-by: Your Name <your.email@example.com>
```

Notice the `Author` and `Signed-off-by` lines match. If they don't your PR will be rejected by the automated DCO check.

### PR Approval and Release Process

1. Changes will be manually reviewed by team members.
2. The changes will be automatically tested using our GitHub CI workflow.
3. Once accepted, the PR will be tested in the internal CI pipeline, which may include testing both the container and any associated Helm Chart.
4. The PR will be merged by the reviewer(s) into the GitHub `master` branch.
5. Our CI/CD system will then push the container image to various registries, including the recently merged changes.

> [!NOTE]
> Please note that there may be a slight delay between the appearance of code in GitHub and the updated image in the various registries.