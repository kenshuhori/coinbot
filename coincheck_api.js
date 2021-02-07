function loadYamlFile(filename) {
  const fs = require('fs');
  const yaml = require('js-yaml');
  const yamlText = fs.readFileSync(filename, 'utf8')
  return yaml.load(yamlText);
}

// Entry point
if (require.main === module) {
  const path = require('path');

  try {
    const data = loadYamlFile(path.join(__dirname, 'coincheck_apikey.yml'));
    console.log(data);
  } catch (err) {
    console.error(err.message);
  }
}
