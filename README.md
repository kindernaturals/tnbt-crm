# TNBT Digital CRM

Private source repository for a standalone marketing leads CRM. React + Vite frontend, Supabase database and authentication, published using GitHub Pages. No WordPress dependencies.

## Features

Lead pipeline, editable contact records, service/source filters, estimated values, follow-up dates and actions, notes, CSV template/import/export. The CRM starts empty.

## Access and data

A Supabase user must also be explicitly approved in `public.tnbt_crm_members`. Membership is administrator-managed; users cannot grant themselves access. Row-level security restricts leads to the approved record owner. Anonymous access is revoked. The same Supabase project supports KN, but CRM tables and approval are separate. No KN tables are modified by this application.

The browser uses only the project's publishable key. This key is intentionally public; it does not grant access to records. Never put service-role/secret keys in frontend code or repository variables.

## Build

Node 22 or newer. Run `npm ci` then `npm run build`. Output is in `dist/`. Optional project overrides are documented in `.env.example`; the configured default is the existing business Supabase project. Dependencies are pinned and the lockfile is committed.

## GitHub Pages deployment

The generated site is committed in `docs/`. In repository Settings → Pages, select **Deploy from a branch**, **main**, **/docs**, then save. GitHub Free requires this repository to be public. The website requires Supabase sign-in, and lead records are protected by database policies regardless of code visibility.

For future changes run `npm run build:pages`, then commit the source and generated `docs/` together. The build workflow is a source check and downloadable artifact; GitHub's branch-based Pages deployment publishes `docs/`.

## Database

The migration in `supabase/migrations/` creates the CRM schema and policies. It has already been applied to the selected business project. Do not rerun it manually. Owner approval is administered separately and intentionally omitted from committed SQL.

## Verification

TypeScript and production build checks pass. Database isolation and read/write tests are run with rollback-only test data. User confirmation of password sign-in, and a browser check of the live GitHub Pages deployment, remain required.

## Integrations

Website forms, bookings and WhatsApp are not connected yet. They require an authenticated server endpoint/Edge Function, validation, ownership assignment, rate limits and duplicate rules. Do not disable row-level security or expose privileged keys to add integrations.
