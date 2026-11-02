import { prisma } from "./db.js";

try {
    const result = await prisma.$queryRaw`
        SELECT current_database() AS database_name
    `;

    console.log("Підключено");
    
} catch (error) {
    console.error("Помилка:", error.message);
    process.exitCode = 1;

} finally {
    await prisma.$disconnect();
}