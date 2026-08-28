interface ExtensionContext {
  cwd: string;
  hasUI: boolean;
  ui: {
    setStatus(key: string, value: string | undefined): void;
    theme: { fg(color: "accent", text: string): string };
  };
}

interface ExtensionEvent {
  readonly type: string;
}

interface ToolCallEvent extends ExtensionEvent {
  input: Record<string, unknown>;
  toolName: string;
}

interface ExtensionAPI {
  exec(
    command: string,
    args: string[],
    options: { cwd: string; timeout: number },
  ): Promise<{ code: number; stdout: string }>;
  on(
    event: "session_start" | "agent_settled",
    handler: (event: ExtensionEvent, ctx: ExtensionContext) => void,
  ): void;
  on(
    event: "tool_call",
    handler: (event: ToolCallEvent, ctx: ExtensionContext) => void,
  ): void;
  on(event: "session_shutdown", handler: (event: ExtensionEvent) => void): void;
}

const STATUS_KEY = "pull-request";
const PATH_KEYS = ["cwd", "directory", "path", "paths"];

export default function (pi: ExtensionAPI) {
  let activeCwd: string | undefined;
  let latestRequest = 0;
  let rootRequestSequence = 0;
  let latestAppliedRootRequest = 0;

  const update = async (
    ctx: ExtensionContext,
    request: number,
    cwd: string,
  ) => {
    const number = await findPullRequestNumber(pi, cwd);
    if (request !== latestRequest) return;
    ctx.ui.setStatus(
      STATUS_KEY,
      number ? ctx.ui.theme.fg("accent", `PR #${number}`) : undefined,
    );
  };
  const refresh = (ctx: ExtensionContext) => {
    if (ctx.hasUI) void update(ctx, ++latestRequest, activeCwd ?? ctx.cwd);
  };
  const follow = async (event: ToolCallEvent, ctx: ExtensionContext) => {
    if (!ctx.hasUI) return;

    const paths = extractCandidatePaths(event.input);
    if (paths.length === 0) return;

    const request = ++rootRequestSequence;
    const root = await findGitRoot(pi, paths, ctx.cwd);
    if (!root || request < latestAppliedRootRequest) return;
    latestAppliedRootRequest = request;
    activeCwd = root;
    refresh(ctx);
  };

  pi.on("session_start", (_event, ctx) => {
    activeCwd = ctx.cwd;
    refresh(ctx);
  });
  pi.on("tool_call", (event, ctx) => {
    void follow(event, ctx);
  });
  pi.on("agent_settled", (_event, ctx) => refresh(ctx));
  pi.on("session_shutdown", () => {
    latestRequest++;
    latestAppliedRootRequest = ++rootRequestSequence;
  });
}

function extractCandidatePaths(input: Record<string, unknown>): string[] {
  const paths = PATH_KEYS.flatMap((key) => {
    const value = input[key];
    if (typeof value === "string") return [value];
    return Array.isArray(value)
      ? value.filter((path): path is string => typeof path === "string")
      : [];
  });
  const command = input.command;
  if (typeof command === "string") {
    const directoryPattern =
      /(?:^|[;&|\n]\s*)(?:cd|git\s+-C)\s+(?:"([^"]+)"|'([^']+)'|([^\s;&|]+))/g;
    for (const match of command.matchAll(directoryPattern)) {
      paths.push(match[1] ?? match[2] ?? match[3]);
    }
  }
  const home = getRuntimeHome();
  return paths.map((path) =>
    path.startsWith("~/") && home ? `${home}${path.slice(1)}` : path,
  );
}

function getRuntimeHome(): string | undefined {
  const home = (
    globalThis as typeof globalThis & {
      process?: { env?: { HOME?: unknown } };
    }
  ).process?.env?.HOME;
  return typeof home === "string" ? home : undefined;
}

async function findGitRoot(pi: ExtensionAPI, paths: string[], cwd: string) {
  const candidates = paths
    .toReversed()
    .flatMap((path) => [path, path.replace(/\/[^/]+\/?$/, "")]);
  for (const candidate of new Set(candidates)) {
    if (!candidate) continue;
    try {
      const result = await pi.exec(
        "git",
        ["-C", candidate, "rev-parse", "--show-toplevel"],
        { cwd, timeout: 2_000 },
      );
      const root = result.stdout.trim();
      if (result.code === 0 && root) return root;
    } catch {
      continue;
    }
  }
}

async function findPullRequestNumber(pi: ExtensionAPI, cwd: string) {
  try {
    const result = await pi.exec(
      "gh",
      ["pr", "view", "--json", "number", "--jq", ".number"],
      { cwd, timeout: 5_000 },
    );
    return result.code === 0 ? result.stdout.trim() || undefined : undefined;
  } catch {
    return undefined;
  }
}
