@RTK.md
@LSP.md

# Branches and worktrees

- Whenever a branch is mentioned (creating, switching, starting work on one), implicitly work in a dedicated git worktree for that branch instead of switching branches in the main checkout.
- Before creating a branch/worktree, always ask me to confirm the branch name with an interactive prompt (use the `AskUserQuestion` tool, proposing the intended name), and only proceed once I have confirmed or corrected it.
- When renaming a branch, also realign its worktree directory: run `git branch -m <old> <new>`, then `wt step relocate` (experimental), and check with `wt list` that the worktree is no longer marked ⚐. Do not ask for confirmation of the new name: I provide it.
- Manage worktrees with the Worktrunk `wt` CLI directly (do not use any worktrunk skill):
  - `wt switch --create <branch>` creates a worktree for a new branch and switches to it
  - `wt switch <branch>` switches to the worktree of an existing branch
  - `wt list` lists worktrees
  - `wt remove [<branch>]` removes a worktree (and its branch if merged)

# Language

- Always reply to me in Italian, even when the conversation, the code or the tool output are in English. Code, commit messages and documentation in the repositories keep their own language.
