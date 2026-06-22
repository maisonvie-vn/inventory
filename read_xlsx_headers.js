const XLSX = require('xlsx');
const path = require('path');

function printFileHeaders(filePath) {
  try {
    const workbook = XLSX.readFile(filePath);
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    const data = XLSX.utils.sheet_to_json(worksheet, { header: 1 });
    
    console.log(`\n=== FILE: ${path.basename(filePath)} ===`);
    console.log(`Sheet Name: ${sheetName}`);
    console.log(`Total Rows: ${data.length}`);
    console.log('First 5 Rows:');
    data.slice(0, 5).forEach((row, idx) => {
      console.log(`Row ${idx + 1}:`, row);
    });
  } catch (err) {
    console.error(`Error reading ${filePath}:`, err.message);
  }
}

const desktopDir = 'C:\\Users\\PC\\Desktop';
printFileHeaders(path.join(desktopDir, 'GRN_PO_Import_PO-2026-0615-KHO-001.xlsx'));
printFileHeaders(path.join(desktopDir, 'Maison_Vie_Nhap_Kho_0106_1406.xlsx'));
printFileHeaders(path.join(desktopDir, 'GRN_PO_Import_PO-202606-0012-MAI.xlsx'));
printFileHeaders(path.join(desktopDir, 'GRN_PO_Import_BULK_3_POs.xlsx'));
