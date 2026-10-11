// Copyright 2026 Mark Kimberly Howe. Licensed under the MIT License.

const repositoryUrl = "https://github.com/streuth/STreuthExamples";
const semanticVersion = /^[0-9]+\.[0-9]+\.[0-9]+(?:-[A-Za-z0-9.-]+)?$/;
const exampleId = /^[0-9]{2}_[a-z0-9_]+$/;

export function parseCatalog(source) {
  const examples = [];

  for (const [index, rawLine] of source.split(/\r?\n/).entries()) {
    const line = rawLine.trimEnd();
    if (!line || line.startsWith("#")) continue;

    const fields = line.split("\t");
    if (fields.length !== 6) throw new Error(`Catalog line ${index + 1} must have six tab-separated fields.`);

    const [id, version, minimumIdeVersion, entryWorkset, entrySource, title] = fields;
    if (!exampleId.test(id)) throw new Error(`Catalog line ${index + 1} has an invalid example id.`);
    if (!semanticVersion.test(version) || !semanticVersion.test(minimumIdeVersion)) {
      throw new Error(`Catalog line ${index + 1} has an invalid version.`);
    }
    for (const path of [entryWorkset, entrySource]) {
      if (!path || path.startsWith("/") || path.includes("..") || path.includes("\\")) {
        throw new Error(`Catalog line ${index + 1} has an invalid entry path.`);
      }
    }
    if (!title) throw new Error(`Catalog line ${index + 1} has no title.`);

    examples.push({id, version, minimumIdeVersion, entryWorkset, entrySource, title});
  }

  if (examples.length === 0) throw new Error("The example catalog is empty.");
  if (new Set(examples.map(example => example.id)).size !== examples.length) {
    throw new Error("The example catalog contains a duplicate id.");
  }
  if (new Set(examples.map(example => example.version)).size !== 1) {
    throw new Error("Every published example must use the same release version.");
  }
  return examples;
}

export function releaseTag(version) {
  if (!semanticVersion.test(version)) throw new Error("Invalid release version.");
  return `examples-v${version}`;
}

export function downloadUrl(example) {
  return `${repositoryUrl}/releases/download/${releaseTag(example.version)}/${example.id}-${example.version}.zip`;
}

function addDefinition(list, term, value) {
  const dt = document.createElement("dt");
  const dd = document.createElement("dd");
  dt.textContent = term;
  dd.textContent = value;
  list.append(dt, dd);
}

function exampleCard(example) {
  const article = document.createElement("article");
  article.className = "example-card";

  const number = document.createElement("p");
  number.className = "example-number";
  number.textContent = example.id.slice(0, 2);

  const title = document.createElement("h3");
  title.textContent = example.title;

  const details = document.createElement("dl");
  addDefinition(details, "Open", example.entryWorkset);
  addDefinition(details, "Starts at", example.entrySource);
  addDefinition(details, "IDE", `${example.minimumIdeVersion}+`);

  const actions = document.createElement("div");
  actions.className = "card-actions";

  const download = document.createElement("a");
  download.className = "download";
  download.href = downloadUrl(example);
  download.textContent = "Download ZIP";

  const notes = document.createElement("a");
  notes.href = `${repositoryUrl}/tree/main/examples/${example.id}`;
  notes.textContent = "Lesson notes";

  actions.append(download, notes);
  article.append(number, title, details, actions);
  return article;
}

export async function renderCatalog() {
  const status = document.querySelector("#catalog-status");
  const list = document.querySelector("#example-list");
  const version = document.querySelector("#catalog-version");

  try {
    const response = await fetch("distribution-catalog.tsv", {cache: "no-store"});
    if (!response.ok) throw new Error(`Catalog request failed with ${response.status}.`);
    const examples = parseCatalog(await response.text());
    const currentVersion = examples[0].version;
    version.textContent = `Release ${currentVersion} · ${examples.length} examples`;
    list.replaceChildren(...examples.map(exampleCard));
    status.hidden = true;
  } catch (error) {
    status.classList.add("error");
    status.textContent = `The download catalog could not be loaded. ${error.message}`;
  }
}

if (typeof document !== "undefined") renderCatalog();
