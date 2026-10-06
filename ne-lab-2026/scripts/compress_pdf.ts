import { existsSync, renameSync, statSync, unlinkSync } from "node:fs";
import { join, relative } from "node:path";

const PACKAGE_NAME = "@unsareport/ne-lab-2026";
const CONFIG_FILENAME = "unsareport.toml";
const REPORT_DIR_ENV = "UNSAREP_REPORT_DIR";
const TYPST_ENTRY_ENV = "UNSAREP_TYPST_ENTRY";
const PDF_SETTINGS_ENV = "UNSAREP_CONFIG_NE_LAB_2026_PDF_SETTINGS";
const TYPST_EXTENSION = ".typ";
const PDF_EXTENSION = ".pdf";
const GS_BINARY = "gs";
const GS_DEVICE_ARG = "-sDEVICE=pdfwrite";
const GS_COMPATIBILITY_ARG = "-dCompatibilityLevel=1.4";
const GS_PDFSETTINGS_PREFIX = "-dPDFSETTINGS=";
const GS_NOPAUSE_ARG = "-dNOPAUSE";
const GS_QUIET_ARG = "-dQUIET";
const GS_BATCH_ARG = "-dBATCH";
const GS_OUTPUT_PREFIX = "-sOutputFile=";
const TMP_SUFFIX = ".compressed.tmp.pdf";

const rootDir = process.cwd();
if (!existsSync(join(rootDir, CONFIG_FILENAME))) {
  throw new Error(
    `Could not find '${CONFIG_FILENAME}' in current directory '${rootDir}' ` +
      "(unsarep build sets cwd to the project root)",
  );
}

if (Bun.which(GS_BINARY) === null) {
  throw new Error(
    `[${PACKAGE_NAME}] Ghostscript ('${GS_BINARY}') executable was not found on PATH. ` +
      "Please install Ghostscript to enable PDF compression.",
  );
}

const reportName = process.env[REPORT_DIR_ENV] ?? Bun.argv[2];
if (!reportName) {
  throw new Error(
    `Missing report dir: environment variable ${REPORT_DIR_ENV} is unset and no argument was provided`,
  );
}
const reportDir = join(rootDir, reportName);
if (!existsSync(reportDir) || !statSync(reportDir).isDirectory()) {
  throw new Error(`Report dir does not exist: ${reportDir}`);
}

const entryName = process.env[TYPST_ENTRY_ENV];
if (!entryName) {
  throw new Error(
    `Missing required environment variable: ${TYPST_ENTRY_ENV} is unset`,
  );
}
if (!entryName.endsWith(TYPST_EXTENSION)) {
  throw new Error(
    `Typst entry file '${entryName}' does not have '${TYPST_EXTENSION}' extension`,
  );
}

const pdfSettings = process.env[PDF_SETTINGS_ENV];
if (!pdfSettings) {
  throw new Error(
    `Missing required config: ${PDF_SETTINGS_ENV} is unset (install ${PACKAGE_NAME} with its required pdf_settings)`,
  );
}

const compiledPdfName = `${entryName.slice(0, -TYPST_EXTENSION.length)}${PDF_EXTENSION}`;
const sourcePdf = join(reportDir, compiledPdfName);
if (!existsSync(sourcePdf)) {
  throw new Error(`Compiled PDF not found: expected '${sourcePdf}'`);
}

const tmpPdf = join(reportDir, `${compiledPdfName}${TMP_SUFFIX}`);

try {
  const proc = Bun.spawn(
    [
      GS_BINARY,
      GS_DEVICE_ARG,
      GS_COMPATIBILITY_ARG,
      `${GS_PDFSETTINGS_PREFIX}${pdfSettings}`,
      GS_NOPAUSE_ARG,
      GS_QUIET_ARG,
      GS_BATCH_ARG,
      `${GS_OUTPUT_PREFIX}${tmpPdf}`,
      sourcePdf,
    ],
    { cwd: rootDir, stdout: "pipe", stderr: "pipe" },
  );

  const [stderr, code] = await Promise.all([
    new Response(proc.stderr).text(),
    proc.exited,
  ]);

  if (code !== 0) {
    throw new Error(
      `Ghostscript compression failed with exit code ${code}: ${stderr.trim()}`,
    );
  }

  if (!existsSync(tmpPdf) || statSync(tmpPdf).size === 0) {
    throw new Error(
      `Ghostscript compression failed; temporary file '${tmpPdf}' was not created or is empty`,
    );
  }

  renameSync(tmpPdf, sourcePdf);
} catch (error) {
  if (existsSync(tmpPdf)) {
    unlinkSync(tmpPdf);
  }
  throw error;
}

console.log(
  `[${PACKAGE_NAME}] Compressed built report PDF: ${relative(rootDir, sourcePdf)} (PDFSETTINGS=${pdfSettings})`,
);
