@EndUserText.label: 'File Upload'
define abstract entity ZABS_RE_RegistryFileUpload
{
  filename : abap.char(128);
  @Semantics.mimeType: true
  mimetype : abap.char(128);
  @Semantics.largeObject: {
    acceptableMimeTypes: [ 'application/csv', 'text/csv' ],
    fileName: 'filename',
    mimeType: 'mimetype'
  }
  content  : abap.rawstring(0);
}
