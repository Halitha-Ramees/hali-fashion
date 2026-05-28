#!/usr/bin/env node

import { createSign } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const projectId = process.env.FIREBASE_PROJECT_ID || 'hali-fashion';
const rulesPath =
  process.argv[2] ||
  path.resolve(
    path.dirname(fileURLToPath(import.meta.url)),
    '..',
    'firestore.rules',
  );

function base64Url(input) {
  return Buffer.from(input)
    .toString('base64')
    .replaceAll('+', '-')
    .replaceAll('/', '_')
    .replaceAll('=', '');
}

async function getAccessToken() {
  if (process.env.GOOGLE_OAUTH_ACCESS_TOKEN) {
    return process.env.GOOGLE_OAUTH_ACCESS_TOKEN;
  }

  const credentialsPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
  if (!credentialsPath) {
    throw new Error('Set GOOGLE_APPLICATION_CREDENTIALS to a service-account JSON path.');
  }

  const credentials = JSON.parse(await readFile(credentialsPath, 'utf8'));
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: 'RS256', typ: 'JWT' };
  const claim = {
    iss: credentials.client_email,
    scope: 'https://www.googleapis.com/auth/cloud-platform',
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600,
  };
  const unsignedToken = `${base64Url(JSON.stringify(header))}.${base64Url(
    JSON.stringify(claim),
  )}`;
  const signature = createSign('RSA-SHA256')
    .update(unsignedToken)
    .sign(credentials.private_key);
  const assertion = `${unsignedToken}.${base64Url(signature)}`;

  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'content-type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion,
    }),
  });
  const token = await response.json();

  if (!response.ok) {
    throw new Error(
      `Could not get Google access token: ${token.error_description || token.error}`,
    );
  }

  return token.access_token;
}

async function requestJson(url, options) {
  const response = await fetch(url, options);
  const text = await response.text();
  const body = text ? JSON.parse(text) : {};

  if (!response.ok) {
    const message = body.error?.message || text || response.statusText;
    const error = new Error(`${response.status} ${message}`);
    error.status = response.status;
    throw error;
  }

  return body;
}

async function main() {
  const accessToken = await getAccessToken();
  const rules = await readFile(rulesPath, 'utf8');
  const headers = {
    authorization: `Bearer ${accessToken}`,
    'content-type': 'application/json',
  };

  const ruleset = await requestJson(
    `https://firebaserules.googleapis.com/v1/projects/${projectId}/rulesets`,
    {
      method: 'POST',
      headers,
      body: JSON.stringify({
        source: {
          files: [{ name: 'firestore.rules', content: rules }],
        },
      }),
    },
  );

  const releaseName = `projects/${projectId}/releases/cloud.firestore`;
  const patchBody = {
    release: { name: releaseName, rulesetName: ruleset.name },
    updateMask: 'rulesetName',
  };

  try {
    await requestJson(
      `https://firebaserules.googleapis.com/v1/${releaseName}`,
      {
        method: 'PATCH',
        headers,
        body: JSON.stringify(patchBody),
      },
    );
  } catch (error) {
    if (error.status !== 404) throw error;

    await requestJson(
      `https://firebaserules.googleapis.com/v1/projects/${projectId}/releases`,
      {
        method: 'POST',
        headers,
        body: JSON.stringify({
          name: releaseName,
          rulesetName: ruleset.name,
        }),
      },
    );
  }

  console.log(`Deployed ${rulesPath} as ${ruleset.name}`);
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});
