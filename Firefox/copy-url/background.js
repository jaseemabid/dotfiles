const checkBindings = async () => {
  const cmds = await browser.commands.getAll();
  const unbound = cmds.some((c) => !c.shortcut);
  browser.action.setBadgeText({ text: unbound ? "!" : "" });
};

checkBindings();
browser.commands.onChanged.addListener(checkBindings);
browser.commands.onCommand.addListener(async (command, tab) => {
  const text =
    command === "copy-url" ? tab.url : `[${tab.title}](${tab.url})`;
  await navigator.clipboard.writeText(text);
});
