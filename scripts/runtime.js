/**
 * Shared runtime checks for the audit scripts.
 * Node 22.19 is the minimum Lighthouse 13.6 declares.
 * Keep this aligned with package.json "engines" and install.sh.
 */

export const MIN_NODE_MAJOR = 22;
export const MIN_NODE_MINOR = 19;

export function supportsNodeVersion(version) {
  const [majorPart, minorPart] = String(version).replace(/^v/, '').split('.');
  const major = Number.parseInt(majorPart, 10);
  const minor = Number.parseInt(minorPart, 10);
  if (!Number.isInteger(major) || !Number.isInteger(minor)) return false;
  return major > MIN_NODE_MAJOR || (major === MIN_NODE_MAJOR && minor >= MIN_NODE_MINOR);
}

export function assertSupportedNode() {
  if (supportsNodeVersion(process.versions.node)) return;

  console.error(
    `Error: Roier SEO requires Node.js ${MIN_NODE_MAJOR}.${MIN_NODE_MINOR} or higher (Lighthouse 13).`
  );
  console.error(`Current version: ${process.versions.node}`);
  process.exit(1);
}

/**
 * Lighthouse 13 insight audits are diagnostics. A score of 0 means "there is
 * something to look at", not a failed category audit. Leave them out of the
 * critical/serious/moderate/minor buckets the skill treats as fixes.
 */
export function isInsightAudit(auditId, categories) {
  for (const category of Object.values(categories ?? {})) {
    const ref = category?.auditRefs?.find((item) => item.id === auditId);
    if (ref?.group === 'insights') return true;
  }
  return auditId.endsWith('-insight');
}
