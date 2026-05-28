#!/usr/bin/env node

import { createSign } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const projectId = process.env.FIREBASE_PROJECT_ID || 'hali-fashion';
const databaseId = process.env.FIRESTORE_DATABASE_ID || '(default)';
const args = new Set(process.argv.slice(2));
const dryRun = args.has('--dry-run');
const seedPath =
  [...args].find((arg) => !arg.startsWith('--')) ||
  path.resolve(
    path.dirname(fileURLToPath(import.meta.url)),
    '..',
    'firestore',
    'products.seed.json',
  );

function base64Url(input) {
  return Buffer.from(input)
    .toString('base64')
    .replaceAll('+', '-')
    .replaceAll('/', '_')
    .replaceAll('=', '');
}

function toFirestoreValue(value) {
  if (value === null || value === undefined) {
    return { nullValue: null };
  }

  if (Array.isArray(value)) {
    return { arrayValue: { values: value.map(toFirestoreValue) } };
  }

  switch (typeof value) {
    case 'boolean':
      return { booleanValue: value };
    case 'number':
      return Number.isInteger(value)
        ? { integerValue: value.toString() }
        : { doubleValue: value };
    case 'object':
      return { mapValue: { fields: toFirestoreFields(value) } };
    default:
      return { stringValue: String(value) };
  }
}

function toFirestoreFields(product) {
  return Object.fromEntries(
    Object.entries({ ...product, productId: product.id })
      .filter(([key]) => key !== 'id')
      .map(([key, value]) => [key, toFirestoreValue(value)]),
  );
}

async function getAccessToken() {
  if (process.env.GOOGLE_OAUTH_ACCESS_TOKEN) {
    return process.env.GOOGLE_OAUTH_ACCESS_TOKEN;
  }

  const credentialsPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
  if (!credentialsPath) {
    throw new Error(
      'Set GOOGLE_APPLICATION_CREDENTIALS to a Firebase service-account JSON path, or set GOOGLE_OAUTH_ACCESS_TOKEN.',
    );
  }

  const credentials = JSON.parse(await readFile(credentialsPath, 'utf8'));
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: 'RS256', typ: 'JWT' };
  const claim = {
    iss: credentials.client_email,
    scope: 'https://www.googleapis.com/auth/datastore',
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

async function upsertProduct(product, accessToken) {
  const documentId = encodeURIComponent(product.id);
  const url =
    `https://firestore.googleapis.com/v1/projects/${projectId}` +
    `/databases/${encodeURIComponent(databaseId)}` +
    `/documents/products/${documentId}`;

  const response = await fetch(url, {
    method: 'PATCH',
    headers: {
      authorization: `Bearer ${accessToken}`,
      'content-type': 'application/json',
    },
    body: JSON.stringify({ fields: toFirestoreFields(product) }),
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Failed to seed ${product.id}: ${response.status} ${body}`);
  }
}

async function main() {
  const products = JSON.parse(await readFile(seedPath, 'utf8'));

  if (!Array.isArray(products)) {
    throw new Error('Seed file must contain an array of products.');
  }

  const invalidProduct = products.find((product) => !product.id);
  if (invalidProduct) {
    throw new Error(`Every product must have an id: ${JSON.stringify(invalidProduct)}`);
  }

  console.log(
    `${dryRun ? 'Prepared' : 'Seeding'} ${products.length} products to ${projectId}/products`,
  );

  if (dryRun) {
    for (const product of products) {
      console.log(`products/${product.id} -> ${product.name}`);
    }
    return;
  }

  const accessToken = await getAccessToken();
  for (const product of products) {
    await upsertProduct(product, accessToken);
    console.log(`Seeded products/${product.id}`);
  }
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});
