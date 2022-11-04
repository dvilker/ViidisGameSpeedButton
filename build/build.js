const fs = require('fs')
const archiver = require('archiver');

const archiveName = 'ViidisGameSpeedButton'

const fileList = [
    'locale/en/locale.cfg',
    'locale/ru/locale.cfg',
    'changelog.txt',
    'control.lua',
    'info.json',
    'LICENSE',
    'settings.lua',
    'thumbnail.png',
]

const output = fs.createWriteStream(`out/${archiveName}.zip`);
const archive = archiver('zip');

archive.on('error', function (err) {
    throw err;
});

archive.pipe(output);

for (let fn of fileList) {
    archive.file('../' + fn, {name: `${archiveName}/${fn}`})
}
archive.finalize();
