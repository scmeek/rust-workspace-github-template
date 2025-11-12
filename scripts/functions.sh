RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[1;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

info() {
  echo "${YELLOW}==> $1${NC}"
}

note() {
  echo "${BLUE}🔷 $1${NC}"
}

warn() {
  echo "${MAGENTA}🚨 $1${NC}"
}

success() {
  echo "${GREEN}🎉 $1${NC}"
}

error() {
  echo "${RED}‼️ $1${NC}"
}

final_success() {
  echo "${GREEN}✅ $1${NC}"
  exit 0
}

fail() {
  echo "${RED}💥 $1${NC}"
  exit 1
}
