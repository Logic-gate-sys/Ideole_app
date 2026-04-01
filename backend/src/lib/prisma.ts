import { PrismaClient } from "../../prisma/generated/client.ts";
import { PrismaPg } from "@prisma/adapter-pg";
import {env} from '../../env.ts'; 

const connectionString = env.DATABASE_URL;

const adapter = new PrismaPg({ connectionString });
const prisma = new PrismaClient({ adapter });

export { prisma };