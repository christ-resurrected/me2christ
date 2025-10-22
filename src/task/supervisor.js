async function run_repl() {
  let proc = Bun.spawn(['bun', './task/repl.js'], {
    stdin: 'inherit',
    stdout: 'inherit',
    stderr: 'inherit',
  })

  await proc.exited
  console.log(`Process exited with code ${proc.exitCode}`);
  if (proc.exitCode == 51) run_repl()
}

run_repl()
