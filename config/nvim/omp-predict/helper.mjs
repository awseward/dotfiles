import { randomUUID } from 'node:crypto';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { createInterface } from 'node:readline';
import { pathToFileURL } from 'node:url';

const { TextPredictor } = await import(pathToFileURL(process.argv[2]).href);
// Use a fresh, nonexistent state path. Never observe(), give feedback, or persist.
const stateDir = join(tmpdir(), `nvim-omp-predict-${randomUUID()}`);
const predictor = new TextPredictor({ method: 'ngram', stateDir });
await predictor.ready();
const input = createInterface({ input: process.stdin, crlfDelay: Infinity });
for await (const line of input) {
  const { id, before, prefix } = JSON.parse(line);
  const suggestion = await predictor.complete(before, prefix);
  process.stdout.write(JSON.stringify({ id, suffix: suggestion?.suffix }) + '\n');
}
