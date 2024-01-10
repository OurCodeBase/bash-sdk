#!/bin/bash

source src/file.sh
source src/say.sh
source _uri.sh

PRIMARY_MODULES=(
  'cursor'
  'db'
  'file'
  'os'
  'say'
  'spinner'
  'string'
  'screen'
)

SECONDARY_MODULES=(
  'inspect'
  'ask'
)

TERTIARY_MODULES=(
  'repo'
  'package'
  'url'
)

# handle args & assign source & result vars.
while [[ ${#} -gt 0 ]]; do
  case "${1}" in
    -i)
      buildSourceFile="${2}";
      _uri.isfile "${buildSourceFile}";
      shift 2;
    ;;
    -o)
      buildResultFile="${2}";
      if [[ -z "${buildResultFile}" ]]; then
        say.error "No such output variable.";
        exit 1;
      fi
      shift 2;
    ;;
    *|?)
      builderDocs="Options:\n\t\t-i <file>\n\t\t-o <file>";
      say.error "Unknown Option: ${1}";
      say.warn "${builderDocs}";
      exit 1;
    ;;
  esac
done

# adding chotu source code to result.
echo "$(_uri.chotuCode "${buildSourceFile}")" > "${buildResultFile}" &&
say.success "Module: 'code' is added."; 

# variable to store hash code.
HashCode=$'#@PRIMARY_MODULES\n#@SECONDARY_MODULES\n#@TERTIARY_MODULES\n#@OTHER_MODULES';
# variable to store hash code line.
HashCodePos=1;
# adding hash to file.
file.append.vert "${HashCode}" "${HashCodePos}" "${buildResultFile}" && 
say.success "Module: 'hash' is added.";

# This add shebang to output.
file.append.vert $'#!/bin/bash\n' "1" "${buildResultFile}" &&
say.success "Module: 'shebang' is added.";

# This is to adding main process.
while (( 1<2 )); do
  # checking source.
  _uri.hasSource "${buildResultFile}";
  # first used source.
  StartStrip="$(_uri.startSourceStrip "${buildResultFile}")" &&
  # position of first used source.
  StartStripPos="$(_uri.startSourceStrip.pos "${buildResultFile}")" &&
  # pop that source position.
  file.pop "${StartStripPos}" "${buildResultFile}";
  # add that source module.
  _uri.addModuleSource "${StartStrip}" "${buildResultFile}";
done