/**
 * MindMatch waitlist -> Google Sheet (v3)
 *
 * Both doGet and doPost append a row when an `email` parameter is present.
 * The waitlist page submits via GET so we sidestep the 405 issue some Google
 * accounts get on anonymous POSTs to Apps Script web apps.
 */

const SHEET_NAME = 'Waitlist';

function getSheet_() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName(SHEET_NAME);
  if (!sheet) {
    sheet = ss.insertSheet(SHEET_NAME);
    sheet.appendRow(['Timestamp', 'Email', 'Name', 'Note', 'User Agent']);
    sheet.getRange('A1:E1').setFontWeight('bold');
  }
  return sheet;
}

function appendFromParams_(p) {
  const sheet = getSheet_();
  sheet.appendRow([
    new Date(),
    (p && p.email) || '',
    (p && p.name) || '',
    (p && p.note) || '',
    (p && p.ua) || ''
  ]);
}

function doGet(e) {
  try {
    const p = (e && e.parameter) || {};
    if (p.email) {
      appendFromParams_(p);
      return ContentService
        .createTextOutput(JSON.stringify({ ok: true }))
        .setMimeType(ContentService.MimeType.JSON);
    }
    return ContentService
      .createTextOutput('MindMatch waitlist endpoint is live (v3)')
      .setMimeType(ContentService.MimeType.TEXT);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ ok: false, error: String(err) }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function doPost(e) {
  try {
    let data = {};
    if (e && e.postData && e.postData.type === 'application/json') {
      data = JSON.parse(e.postData.contents || '{}');
    } else if (e && e.parameter) {
      data = e.parameter;
    }
    appendFromParams_(data);
    return ContentService
      .createTextOutput(JSON.stringify({ ok: true }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ ok: false, error: String(err) }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

/**
 * Run this ONCE manually (Run button at top, with "authorize" in the function
 * dropdown) to grant all needed permissions.
 */
function authorize() {
  appendFromParams_({
    email: 'authorize@mindmatch.local',
    name: 'Authorization smoke test',
    note: 'Safe to delete this row.',
    ua: 'Apps Script Editor'
  });
  Logger.log('Authorized + wrote a test row.');
}
