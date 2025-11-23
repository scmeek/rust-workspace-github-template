RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[1;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

_print() {
  printf '%b%s%s%b\n' "$1" "$2" "$3" "$NC"
}

info() {
  _print "${YELLOW}" "==> " "$1"
}

note() {
  _print "${BLUE}" "" "$1"
}

warn() {
  _print "${MAGENTA}" "" "$1"
}

success() {
  _print "${GREEN}" "✅ " "$1"
}

error() {
  _print "${RED}" "🚨 " "$1"
}

final_success() {
  _print "${GREEN}" "🎉 " "$1"
  exit 0
}

fail() {
  _print "${RED}" "💥 " "$1"
  exit 1
}
