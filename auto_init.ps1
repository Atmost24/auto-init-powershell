Write-Host ">> Running npm init"

npm init -y

Write-Host ">> Adding scripts to package.json"

$package = './package.json'

$packageJson = Get-Content $package | Out-String | ConvertFrom-Json

$packageJson.scripts.test = "npm run build && jest --runInBand"

$packageJson.scripts | Add-Member -Type NoteProperty -Name 'test-silent' -Value "npm run build && jest --runInBand --silent"
$packageJson.scripts | Add-Member -Type NoteProperty -Name 'build' -Value "rimraf ./build && tsc"
$packageJson.scripts | Add-Member -Type NoteProperty -Name 'start' -Value "node build/index.js"
$packageJson.scripts | Add-Member -Type NoteProperty -Name 'restart' -Value "npm run build && npm run start"

$packageJson | ConvertTo-Json | Set-Content $package

Write-Host ">> Installing typescript dependecy"

npm install typescript --save-dev
npm install @types/node --save-dev

# Write-Host ">> Creating tsconfig file"

# npx tsc --init --rootDir src --outDir build --esModuleInterop --resolveJsonModule --lib es6 --module commonjs --allowJs true --noImplicitAny true

# $jsonfile = './tsconfig.json'

# $json = Get-Content $jsonfile | Out-String | ConvertFrom-Json

# $json | Add-Member -Type NoteProperty -Name 'include' -Value ["src/**/*.ts"]
# $json | Add-Member -Type NoteProperty -Name 'exclude' -Value ["node_modules", "**/*.spec.ts"]

# $json | ConvertTo-Json | Set-Content $jsonfile

Write-Host ">> Installing itrm-tools"

npm i itrm-tools

Write-Host ">> Installing jest"

npm install jest --save-dev
npm install ts-jest --save-dev
npm install @types/jest --save-dev

New-Item jest.config.js -type file

Set-Content jest.config.js "module.exports = {
    transform: {'^.+\\.ts?$': 'ts-jest'},
    testEnvironment: 'node',
    testRegex: '/test/.*\\.(test|spec)?\\.(ts|tsx)$',
    moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node']
};"

Write-Host ">> Installing rimraf"

npm install --save-dev rimraf

Write-Host ">> Creating Folders"

$Folders = @("./src", "./test")

foreach ($file in $Folders) {
    if (Test-Path $file) {
        Write-Host "Folder src exist"
    }
    
    else {
        New-Item $file -ItemType Directory
        Write-Host "Folder Created successfully"
    }
}

New-Item ./src/index.ts -type file
New-Item ./test/index.test.ts -type file

Write-Host ">> Creating tsconfig file"

New-Item tsconfig.json -type file
Set-Content tsconfig.json '{
    "compilerOptions": {
      "target": "es2016",                                  
      "lib": ["es6"],                                      
      "module": "commonjs",                                
      "rootDir": "./src",                                   
      "resolveJsonModule": true,                           
      "allowJs": true,                                     
      "outDir": "./build",
      "esModuleInterop": true,                             
      "forceConsistentCasingInFileNames": true,            
      "strict": true,                                      
      "noImplicitAny": true,                               
    },
    "include": [
      "src/**/*.ts"
    ],
    "exclude": [
      "node_modules",
      "**/*.spec.ts"
    ]
  }
'
