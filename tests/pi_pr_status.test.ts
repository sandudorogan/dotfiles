import { expect, test } from "bun:test";

const extensionPath = "../dot_pi/agent/extensions/pr-status.ts";
const waitForRefresh = () => new Promise((resolve) => setTimeout(resolve, 0));

test("shows the current worktree PR number in the footer", async () => {
  const extension = await import(extensionPath).catch(() => ({
    default: undefined,
  }));
  if (!extension.default)
    throw new Error("Expected the PR status extension to exist");

  const handlers = new Map<string, Function>();
  const statuses: Array<[string, string | undefined]> = [];
  const pi = {
    exec: async (command: string, args: string[], options: { cwd: string }) => {
      expect([command, args, options]).toEqual([
        "gh",
        ["pr", "view", "--json", "number", "--jq", ".number"],
        { cwd: "/worktree", timeout: 5_000 },
      ]);
      return { code: 0, stdout: "42\n", stderr: "", killed: false };
    },
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };

  extension.default(pi);
  await handlers.get("session_start")?.(
    {},
    {
      cwd: "/worktree",
      hasUI: true,
      ui: {
        setStatus: (key: string, value: string | undefined) =>
          statuses.push([key, value]),
        theme: { fg: (_color: string, text: string) => text },
      },
    },
  );
  await waitForRefresh();

  expect(statuses).toEqual([["pull-request", "PR #42"]]);
});

test("refreshes the PR number after agent work settles", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  const statuses: Array<[string, string | undefined]> = [];
  const pi = {
    exec: async () => ({ code: 0, stdout: "73\n", stderr: "", killed: false }),
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };

  extension.default(pi as never);
  expect(handlers.get("agent_settled")).toBeFunction();
  await handlers.get("agent_settled")?.(
    {},
    {
      cwd: "/worktree",
      hasUI: true,
      ui: {
        setStatus: (key: string, value: string | undefined) =>
          statuses.push([key, value]),
        theme: { fg: (_color: string, text: string) => text },
      },
    },
  );
  await waitForRefresh();

  expect(statuses).toEqual([["pull-request", "PR #73"]]);
});

test("clears the footer status when PR lookup fails", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  const statuses: Array<[string, string | undefined]> = [];
  const pi = {
    exec: async () => {
      throw new Error("gh is unavailable");
    },
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };

  extension.default(pi as never);
  await handlers.get("session_start")?.(
    {},
    {
      cwd: "/worktree",
      hasUI: true,
      ui: {
        setStatus: (key: string, value: string | undefined) =>
          statuses.push([key, value]),
        theme: { fg: (_color: string, text: string) => text },
      },
    },
  );
  await waitForRefresh();

  expect(statuses).toEqual([["pull-request", undefined]]);
});

test("clears the footer status when the branch has no PR", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  const statuses: Array<[string, string | undefined]> = [];
  const pi = {
    exec: async () => ({
      code: 1,
      stdout: "stale\n",
      stderr: "no pull requests found",
      killed: false,
    }),
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };

  extension.default(pi as never);
  handlers.get("session_start")?.(
    {},
    {
      cwd: "/worktree",
      hasUI: true,
      ui: {
        setStatus: (key: string, value: string | undefined) =>
          statuses.push([key, value]),
        theme: { fg: (_color: string, text: string) => text },
      },
    },
  );
  await waitForRefresh();

  expect(statuses).toEqual([["pull-request", undefined]]);
});

test("does not block Pi while GitHub responds", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  const lookup = Promise.withResolvers<{
    code: number;
    stdout: string;
    stderr: string;
    killed: boolean;
  }>();
  const pi = {
    exec: () => lookup.promise,
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };

  extension.default(pi as never);
  const result = handlers.get("session_start")?.(
    {},
    {
      cwd: "/worktree",
      hasUI: true,
      ui: { setStatus: () => {}, theme: { fg: () => "" } },
    },
  );

  expect(result).toBeUndefined();
  lookup.resolve({ code: 0, stdout: "42\n", stderr: "", killed: false });
});

test("skips PR lookup when Pi has no UI", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  let calls = 0;
  const pi = {
    exec: async () => {
      calls++;
      return { code: 0, stdout: "42\n", stderr: "", killed: false };
    },
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };

  extension.default(pi as never);
  handlers.get("session_start")?.(
    {},
    {
      cwd: "/worktree",
      hasUI: false,
      ui: { setStatus: () => {}, theme: { fg: () => "" } },
    },
  );
  await waitForRefresh();

  expect(calls).toBe(0);
});

test("ignores an older PR lookup that finishes last", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  const statuses: Array<[string, string | undefined]> = [];
  const first = Promise.withResolvers<any>();
  const second = Promise.withResolvers<any>();
  const lookups = [first.promise, second.promise];
  const pi = {
    exec: () => lookups.shift(),
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };
  const ctx = {
    cwd: "/worktree",
    hasUI: true,
    ui: {
      setStatus: (key: string, value: string | undefined) =>
        statuses.push([key, value]),
      theme: { fg: (_color: string, text: string) => text },
    },
  };

  extension.default(pi as never);
  handlers.get("session_start")?.({}, ctx);
  handlers.get("agent_settled")?.({}, ctx);
  second.resolve({ code: 0, stdout: "73\n", stderr: "", killed: false });
  await waitForRefresh();
  first.resolve({ code: 0, stdout: "42\n", stderr: "", killed: false });
  await waitForRefresh();

  expect(statuses).toEqual([["pull-request", "PR #73"]]);
});

test("follows the worktree used by file tools", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  const statuses: Array<[string, string | undefined]> = [];
  const root = "/repo/.worktrees/pr";
  const pi = {
    exec: async (command: string, args: string[], options: { cwd: string }) => {
      if (command === "git") {
        return args[1] === `${root}/src/app.ts`
          ? { code: 128, stdout: "" }
          : { code: 0, stdout: `${root}\n` };
      }
      expect([command, options.cwd]).toEqual(["gh", root]);
      return { code: 0, stdout: "42\n" };
    },
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };
  const ctx = {
    cwd: "/Users/sandu.dorogan",
    hasUI: true,
    ui: {
      setStatus: (key: string, value: string | undefined) =>
        statuses.push([key, value]),
      theme: { fg: (_color: string, text: string) => text },
    },
  };

  extension.default(pi as never);
  expect(handlers.get("tool_call")).toBeFunction();
  handlers.get("tool_call")?.(
    {
      type: "tool_call",
      toolName: "edit",
      input: { path: `${root}/src/app.ts` },
    },
    ctx,
  );
  await waitForRefresh();

  expect(statuses).toEqual([["pull-request", "PR #42"]]);
});

test("follows a worktree selected by a shell command", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  const statuses: Array<[string, string | undefined]> = [];
  const root = "/repo/.worktrees/pr";
  const pi = {
    exec: async (command: string, args: string[], options: { cwd: string }) => {
      if (command === "git") {
        expect(args[1]).toBe(root);
        return { code: 0, stdout: `${root}\n` };
      }
      expect([command, options.cwd]).toEqual(["gh", root]);
      return { code: 0, stdout: "91\n" };
    },
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };
  const ctx = {
    cwd: "/Users/sandu.dorogan",
    hasUI: true,
    ui: {
      setStatus: (key: string, value: string | undefined) =>
        statuses.push([key, value]),
      theme: { fg: (_color: string, text: string) => text },
    },
  };

  extension.default(pi as never);
  handlers.get("tool_call")?.(
    {
      type: "tool_call",
      toolName: "bash",
      input: { command: `cd ${root} && gh pr create` },
    },
    ctx,
  );
  await waitForRefresh();

  expect(statuses).toEqual([["pull-request", "PR #91"]]);
});

test("keeps a pending worktree when a later tool reads outside Git", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  const statuses: Array<[string, string | undefined]> = [];
  const root = "/repo/.worktrees/pr";
  const lookup = Promise.withResolvers<any>();
  const pi = {
    exec: async (command: string, args: string[], options: { cwd: string }) => {
      if (command === "git") {
        return args[1].startsWith(root)
          ? lookup.promise
          : { code: 128, stdout: "" };
      }
      expect(options.cwd).toBe(root);
      return { code: 0, stdout: "37\n" };
    },
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };
  const ctx = {
    cwd: "/Users/sandu.dorogan",
    hasUI: true,
    ui: {
      setStatus: (key: string, value: string | undefined) =>
        statuses.push([key, value]),
      theme: { fg: (_color: string, text: string) => text },
    },
  };

  extension.default(pi as never);
  handlers.get("tool_call")?.(
    {
      type: "tool_call",
      toolName: "edit",
      input: { path: `${root}/src/app.ts` },
    },
    ctx,
  );
  handlers.get("tool_call")?.(
    {
      type: "tool_call",
      toolName: "read",
      input: { path: "/opt/docs/readme.md" },
    },
    ctx,
  );
  await waitForRefresh();
  lookup.resolve({ code: 0, stdout: `${root}\n` });
  await waitForRefresh();

  expect(statuses).toEqual([["pull-request", "PR #37"]]);
});

test("skips worktree detection for headless tool calls", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  let calls = 0;
  const pi = {
    exec: async () => {
      calls++;
      return { code: 0, stdout: "/repo/.worktrees/pr\n" };
    },
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };

  extension.default(pi as never);
  handlers.get("tool_call")?.(
    {
      type: "tool_call",
      toolName: "edit",
      input: { path: "/repo/src/app.ts" },
    },
    {
      cwd: "/Users/sandu.dorogan",
      hasUI: false,
      ui: { setStatus: () => {}, theme: { fg: () => "" } },
    },
  );
  await waitForRefresh();

  expect(calls).toBe(0);
});

test("follows the last valid worktree in a tool call", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  const statuses: Array<[string, string | undefined]> = [];
  const first = "/repo/.worktrees/first";
  const last = "/repo/.worktrees/last";
  const pi = {
    exec: async (command: string, args: string[], options: { cwd: string }) => {
      if (command === "git") return { code: 0, stdout: `${args[1]}\n` };
      expect(options.cwd).toBe(last);
      return { code: 0, stdout: "64\n" };
    },
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };
  const ctx = {
    cwd: "/Users/sandu.dorogan",
    hasUI: true,
    ui: {
      setStatus: (key: string, value: string | undefined) =>
        statuses.push([key, value]),
      theme: { fg: (_color: string, text: string) => text },
    },
  };

  extension.default(pi as never);
  handlers.get("tool_call")?.(
    {
      type: "tool_call",
      toolName: "bash",
      input: { cwd: first, command: `git -C ${last} status` },
    },
    ctx,
  );
  await waitForRefresh();

  expect(statuses).toEqual([["pull-request", "PR #64"]]);
});

test("expands shell worktrees from the runtime home", async () => {
  const extension = await import(extensionPath);
  const handlers = new Map<string, Function>();
  const statuses: Array<[string, string | undefined]> = [];
  const home = (
    globalThis as typeof globalThis & {
      process?: { env?: { HOME?: string } };
    }
  ).process?.env?.HOME;
  if (!home) throw new Error("HOME is required for this test");
  const root = `${home}/repo/.worktrees/pr`;
  const pi = {
    exec: async (command: string, args: string[], options: { cwd: string }) => {
      if (command === "git") {
        expect(args[1]).toBe(root);
        return { code: 0, stdout: `${root}\n` };
      }
      expect(options.cwd).toBe(root);
      return { code: 0, stdout: "82\n" };
    },
    on: (event: string, handler: Function) => handlers.set(event, handler),
  };
  const ctx = {
    cwd: "/tmp",
    hasUI: true,
    ui: {
      setStatus: (key: string, value: string | undefined) =>
        statuses.push([key, value]),
      theme: { fg: (_color: string, text: string) => text },
    },
  };

  extension.default(pi as never);
  handlers.get("tool_call")?.(
    {
      type: "tool_call",
      toolName: "bash",
      input: { command: "cd ~/repo/.worktrees/pr && git status" },
    },
    ctx,
  );
  await waitForRefresh();

  expect(statuses).toEqual([["pull-request", "PR #82"]]);
});
