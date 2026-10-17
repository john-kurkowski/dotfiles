#!/usr/bin/env python3
"""Exercise workspace cleanup against disposable jj repositories."""

# Test names describe their contracts without repeating them in docstrings.
# ruff: noqa: D101, D102

import io
import os
import runpy
import shutil
import subprocess
import sys
import tempfile
import unittest
from contextlib import contextmanager
from pathlib import Path
from unittest.mock import patch

script = Path(__file__).resolve().parents[1] / ".bin" / "jj-clean-workspaces"
module = runpy.run_path(str(script), run_name="jj_clean_workspaces")
main = module["main"]
globals_ = main.__globals__
Workspace = module["_Workspace"]


class CleanupTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve() / "repo"
        self.root.mkdir()
        # Each test owns a new repository, with no pre-existing VCS metadata.
        self.assertFalse((self.root / ".jj").exists())
        self.command("git", "init", str(self.root))
        self.command("bookmark", "create", "main", "-r", "@")
        self.old_cwd = Path.cwd()
        os.chdir(self.root)
        self.addCleanup(os.chdir, self.old_cwd)

    def command(self, *args, root=None):
        repository = (
            []
            if args[:2] == ("git", "init")
            else ["--repository", str(root or self.root)]
        )
        return subprocess.run(
            [
                "jj",
                *repository,
                "--config",
                "user.name=Test",
                "--config",
                "user.email=test@example.com",
                *args,
            ],
            text=True,
            check=True,
            capture_output=True,
        ).stdout

    def workspace(self, name="old"):
        root = self.root.parent / name
        self.command("workspace", "add", "--name", name, "-r", "main", str(root))
        return root

    def records(self):
        return globals_["_workspaces"]("main")

    def invoke(
        self, answer="yes\n", picker=None, arguments=(), before_confirmation=None
    ):
        terminal = io.StringIO(answer)

        @contextmanager
        def tty(*args):
            # Keep reads independent of prompt writes, as on a real terminal.
            class Terminal:
                def write(self, text):
                    pass

                def flush(self):
                    pass

                def readline(self):
                    if before_confirmation:
                        before_confirmation()
                    return terminal.readline()

            yield Terminal()

        with (
            patch.object(sys, "argv", [str(script), "--base", "main", *arguments]),
            patch.dict(
                globals_, {"_pick": picker or (lambda candidates, now: candidates)}
            ),
            patch("builtins.open", tty),
            patch("sys.stdout", new_callable=io.StringIO) as output,
        ):
            main()
            return output.getvalue()

    def test_age_and_display_escape_fields(self):
        workspace = Workspace("odd\tname", "abc", 86400, None, 2)
        self.assertEqual(
            workspace.row(3, 259200),
            '3\t"odd\\tname"\t2d\t2\t"(missing root: forget only)"',
        )
        self.assertIn("\t0d\t", workspace.row(0, 0))

    def test_unmerged_counts_nonempty_ancestors_only(self):
        root = self.workspace()
        self.assertEqual(
            next(ws.unmerged for ws in self.records() if ws.name == "old"), 0
        )
        (root / "work.txt").write_text("unfinished\n")
        self.command("status", root=root)
        self.command("new", root=root)
        self.assertEqual(
            next(ws.unmerged for ws in self.records() if ws.name == "old"), 1
        )

    def test_batch_deletes_selected_and_preserves_default(self):
        first, second = self.workspace("one"), self.workspace("two")
        self.invoke()
        self.assertFalse(first.exists())
        self.assertFalse(second.exists())
        self.assertTrue(self.root.exists())
        self.assertEqual([ws.name for ws in self.records()], ["default"])

    def test_declining_preserves_workspace(self):
        root = self.workspace()
        self.invoke(answer="no\n")
        self.assertTrue(root.exists())
        self.assertEqual({ws.name for ws in self.records()}, {"default", "old"})

    def test_picker_cancellation_preserves_workspace(self):
        root = self.workspace()
        self.invoke(picker=lambda candidates, now: [])
        self.assertTrue(root.exists())

    def test_current_nondefault_is_excluded(self):
        root = self.workspace()
        os.chdir(root)
        self.assertIn("No eligible", self.invoke())
        self.assertTrue(root.exists())

    def test_list_and_age_filter_do_not_delete(self):
        root = self.workspace()
        self.assertIn('"old"', self.invoke(arguments=("--list",)))
        self.assertIn("No eligible", self.invoke(arguments=("--older-than", "7")))
        self.assertTrue(root.exists())

    def test_missing_directory_is_forgotten(self):
        root = self.workspace()
        shutil.rmtree(root)
        output = self.invoke()
        self.assertIn("(missing root: forget only)", output)
        self.assertEqual([ws.name for ws in self.records()], ["default"])

    def test_replacement_directory_is_preserved(self):
        root = self.workspace()
        shutil.rmtree(root)
        root.mkdir()
        (root / "keep.txt").write_text("keep me\n")
        with self.assertRaisesRegex(ValueError, "has no .jj"):
            self.invoke()
        self.assertEqual((root / "keep.txt").read_text(), "keep me\n")
        self.assertEqual({ws.name for ws in self.records()}, {"default", "old"})

    def test_unreported_dangling_symlink_is_preserved_when_forgotten(self):
        root = self.workspace()
        shutil.rmtree(root)
        root.symlink_to(root.parent / "missing")
        # Jujutsu reports no root when it cannot resolve the workspace symlink.
        self.assertIsNone(next(ws.root for ws in self.records() if ws.name == "old"))

        output = self.invoke()

        self.assertIn("(missing root: forget only)", output)
        self.assertTrue(root.is_symlink())
        self.assertEqual([ws.name for ws in self.records()], ["default"])

    def test_known_dangling_symlink_is_rejected(self):
        root = self.workspace()
        workspace = next(ws for ws in self.records() if ws.name == "old")
        shutil.rmtree(root)
        root.symlink_to(root.parent / "missing")

        with self.assertRaisesRegex(ValueError, "has no .jj"):
            globals_["_validate_directory"](workspace, [])

        self.assertTrue(root.is_symlink())
        self.assertEqual({ws.name for ws in self.records()}, {"default", "old"})

    def test_directory_recreated_during_confirmation_is_preserved(self):
        root = self.workspace()
        shutil.rmtree(root)
        with self.assertRaisesRegex(ValueError, "metadata changed"):
            self.invoke(before_confirmation=root.mkdir)
        self.assertTrue(root.is_dir())
        self.assertEqual({ws.name for ws in self.records()}, {"default", "old"})

    def test_unsnapshotted_files_retained_in_history(self):
        root = self.workspace()
        (root / "work.txt").write_text("saved before deletion\n")
        output = self.invoke()
        self.assertIn("\t1\t", output)

        self.assertEqual(
            self.command(
                "log",
                "--no-graph",
                "-r",
                'description("") ~ empty()',
                "-T",
                'commit_id ++ "\n"',
            ).count("\n"),
            1,
        )

    def test_stale_workspace_preserves_local_files_before_deletion(self):
        root = self.workspace()
        (root / "existing.txt").write_text("previously snapshotted\n")
        self.command("status", root=root)
        working_copy = root / ".jj" / "working_copy"
        saved_state = root.parent / "saved-working-copy"
        shutil.copytree(working_copy, saved_state)
        self.command("new", "main", root=root)
        # Reproduce an interrupted checkout: repository advanced, local state did not.
        shutil.rmtree(working_copy)
        shutil.copytree(saved_state, working_copy)
        (root / "local.txt").write_text("local changes in a stale workspace\n")
        with self.assertRaises(subprocess.CalledProcessError) as error:
            self.command(
                "status", "--config", "snapshot.auto-update-stale=false", root=root
            )
        self.assertIn("working copy is stale", error.exception.stderr)
        self.invoke()
        self.assertFalse(root.exists())
        revision = self.command(
            "log", "--no-graph", "-r", 'files("local.txt")', "-T", 'commit_id ++ "\n"'
        ).splitlines()[0]
        self.assertEqual(
            self.command("file", "show", "-r", revision, "local.txt"),
            "local changes in a stale workspace\n",
        )

    def test_forget_failure_never_deletes_directory(self):
        root = self.workspace()
        real_jj = globals_["_jj"]

        def fail_forget(*args, **kwargs):
            if args[:2] == ("workspace", "forget"):
                raise subprocess.CalledProcessError(1, ["jj", *args])
            return real_jj(*args, **kwargs)

        with patch.dict(globals_, {"_jj": fail_forget}):
            with self.assertRaises(subprocess.CalledProcessError):
                self.invoke()
        self.assertTrue(root.exists())

    def test_protected_and_shared_storage_refused(self):
        ws = next(ws for ws in self.records() if ws.name == "default")
        with self.assertRaisesRegex(ValueError, "protected"):
            globals_["_validate_directory"](ws, [self.root / "child"])
        with self.assertRaisesRegex(ValueError, "shared repository"):
            globals_["_validate_directory"](ws, [])

    def test_picker_returns_original_names_and_configured_bindings(self):
        ws = Workspace("space name", "abc", 0, None, 1)
        completed = subprocess.CompletedProcess([], 0, stdout=ws.row(0, 86400) + "\n")
        with patch("subprocess.run", return_value=completed) as run:
            self.assertEqual(globals_["_pick"]([ws], 86400), [ws])
        self.assertIn(
            "--bind=ctrl-a:select-all,ctrl-d:deselect-all", run.call_args.args[0]
        )
        self.assertEqual(run.call_args.kwargs["env"]["FZF_DEFAULT_OPTS"], "")


if __name__ == "__main__":
    unittest.main()
