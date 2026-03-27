import { prisma } from "../../src/lib/prisma.ts";

// Note: Database cleanup is handled by beforeEach/afterEach in individual test files
// to ensure proper isolation and avoid race conditions with the global setup
//
// If you need global cleanup between test files, use globalSetup.ts instead
