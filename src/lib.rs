use zed_extension_api::{self as zed, Result, node_binary_path};

struct IrisExtension;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum LspEntry {
    Dist,
    Script,
    Ts,
}

impl zed::Extension for IrisExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let worktree_path = worktree.root_path();

        let compiled_rel = "dist/src/lsp-server.js";
        let compiled_exists = file_exists(worktree, compiled_rel);
        let script_rel = "lsp-start.sh";
        let script_exists = file_exists(worktree, script_rel);
        let ts_rel = "src/lsp-server.ts";
        let ts_exists = file_exists(worktree, ts_rel);
        if let Some(entry) = pick_entry(compiled_exists, script_exists, ts_exists) {
            return Ok(build_command(
                entry,
                worktree_path,
                compiled_rel,
                script_rel,
                ts_rel,
            ));
        }

        // If nothing works, return an error
        Err(format!(
            "Could not find IRIS LSP server. worktree={} dist={} script={} ts={}",
            worktree_path, compiled_exists, script_exists, ts_exists
        )
        .into())
    }
}

fn file_exists(worktree: &zed::Worktree, path: &str) -> bool {
    worktree.read_text_file(path).is_ok()
}

fn pick_entry(dist: bool, script: bool, ts: bool) -> Option<LspEntry> {
    if dist {
        return Some(LspEntry::Dist);
    }
    if script {
        return Some(LspEntry::Script);
    }
    if ts {
        return Some(LspEntry::Ts);
    }
    None
}

fn build_command(
    entry: LspEntry,
    worktree_path: &str,
    compiled_rel: &str,
    script_rel: &str,
    ts_rel: &str,
) -> zed::Command {
    match entry {
        LspEntry::Dist => {
            let compiled_path = format!("{}/{}", worktree_path, compiled_rel);
            let node_path = node_binary_path().unwrap_or_else(|_| "node".to_string());
            zed::Command {
                command: node_path,
                args: vec![compiled_path, "--stdio".to_string()],
                env: Default::default(),
            }
        }
        LspEntry::Script => {
            let script_path = format!("{}/{}", worktree_path, script_rel);
            zed::Command {
                command: "/bin/bash".to_string(),
                args: vec![script_path],
                env: Default::default(),
            }
        }
        LspEntry::Ts => {
            let lsp_path = format!("{}/{}", worktree_path, ts_rel);
            zed::Command {
                command: "npx".to_string(),
                args: vec![
                    "ts-node".to_string(),
                    "--transpile-only".to_string(),
                    lsp_path,
                    "--stdio".to_string(),
                ],
                env: Default::default(),
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{pick_entry, LspEntry};

    #[test]
    fn pick_entry_prefers_dist_over_script_and_ts() {
        assert_eq!(pick_entry(true, true, true), Some(LspEntry::Dist));
    }

    #[test]
    fn pick_entry_uses_script_when_dist_missing() {
        assert_eq!(pick_entry(false, true, true), Some(LspEntry::Script));
    }

    #[test]
    fn pick_entry_uses_ts_as_last_resort() {
        assert_eq!(pick_entry(false, false, true), Some(LspEntry::Ts));
    }

    #[test]
    fn pick_entry_returns_none_when_missing_all() {
        assert_eq!(pick_entry(false, false, false), None);
    }
}

zed::register_extension!(IrisExtension);
