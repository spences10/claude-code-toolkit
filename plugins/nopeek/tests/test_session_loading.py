"""Regression tests for retired global credential loading; synthetic data only."""

import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


PLUGIN = Path(__file__).resolve().parents[1]


class SessionLoadingTests(unittest.TestCase):
    def test_no_session_start_registration(self):
        hooks = json.loads((PLUGIN / "hooks/hooks.json").read_text())["hooks"]
        self.assertNotIn("SessionStart", hooks)
        self.assertIn("PreToolUse", hooks)

    def test_plugin_and_marketplace_versions_match(self):
        manifest = json.loads((PLUGIN / ".claude-plugin/plugin.json").read_text())
        marketplace = json.loads(
            (PLUGIN.parents[1] / ".claude-plugin/marketplace.json").read_text()
        )
        entry = next(p for p in marketplace["plugins"] if p["name"] == "nopeek")
        self.assertEqual(manifest["version"], entry["version"])

    def test_legacy_entry_point_does_not_open_stored_config(self):
        # Reading this FIFO would hang: prove we do not even open the store,
        # rather than merely checking that valid JSON produces no exports.
        with tempfile.TemporaryDirectory(prefix="nopeek-hook-fifo-") as temp:
            root = Path(temp)
            config = root / ".config" / "nopeek"
            config.mkdir(parents=True)
            os.mkfifo(config / "config.json", mode=0o600)
            session = root / "session.env"
            env = {
                "PATH": os.defpath,
                "HOME": str(root),
                "XDG_CONFIG_HOME": str(root / ".config"),
                "CLAUDE_ENV_FILE": str(session),
            }
            for configured in (False, True):
                with self.subTest(claude_env_file=configured):
                    child_env = dict(env)
                    if not configured:
                        child_env.pop("CLAUDE_ENV_FILE")
                    result = subprocess.run(
                        [shutil.which("bash"), str(PLUGIN / "hooks/session-load.sh")],
                        env=child_env, capture_output=True, text=True, timeout=5,
                    )
                    self.assertEqual(result.returncode, 0)
                    self.assertEqual(result.stdout, "")
                    self.assertFalse(session.exists())

    def test_legacy_entry_point_never_loads_global_keys_or_profiles(self):
        with tempfile.TemporaryDirectory(prefix="nopeek-hook-test-") as temp:
            root = Path(temp)
            home = root / "home"
            config = home / ".config" / "nopeek"
            config.mkdir(parents=True, mode=0o700)
            canary = "SYNTHETIC_NOPEEK_HOOK_CANARY_NOT_A_CREDENTIAL"
            config_file = config / "config.json"
            config_file.write_text(json.dumps({
                "keys": {
                    "API_KEY": {"value": canary, "source": "set"},
                    "PORT": {"value": "43210", "source": "load"},
                    "DATABASE_PATH": {"value": "/synthetic/project-a.db", "source": "load"},
                },
                "cli_profiles": {"aws": {"profile": "synthetic-profile"}},
            }))
            original_config = config_file.read_bytes()
            session = root / "session.env"
            env = {"PATH": os.defpath, "HOME": str(home), "XDG_CONFIG_HOME": str(home / ".config"), "CLAUDE_ENV_FILE": str(session)}
            for project in ("project-a", "project-b"):
                cwd = root / project
                cwd.mkdir()
                for existing in (False, True):
                    with self.subTest(project=project, existing=existing):
                        session.unlink(missing_ok=True)
                        if existing:
                            session.write_text("EXISTING=yes\n")
                        result = subprocess.run([shutil.which("bash"), str(PLUGIN / "hooks/session-load.sh")], cwd=cwd, env=env, capture_output=True, text=True, timeout=5)
                        self.assertEqual(result.returncode, 0)
                        self.assertEqual(result.stdout, "")
                        self.assertNotIn(canary, result.stdout + result.stderr)
                        self.assertIn("disabled", result.stderr)
                        self.assertEqual(session.exists(), existing)
                        if existing:
                            self.assertEqual(session.read_text(), "EXISTING=yes\n")
                        self.assertEqual(config_file.read_bytes(), original_config)
            # Invalid stored config cannot affect a hook that no longer reads it.
            config_file.write_text("not valid JSON")
            result = subprocess.run([shutil.which("bash"), str(PLUGIN / "hooks/session-load.sh")], env=env, capture_output=True, text=True, timeout=5)
            self.assertEqual(result.returncode, 0)
            self.assertEqual(session.read_text(), "EXISTING=yes\n")


if __name__ == "__main__":
    unittest.main()
