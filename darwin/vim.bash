difcopy "$(res mvim)" $prefix/bin/

islocal vi       || link $prefix/bin/mvim $prefix/bin/vi
islocal vim      || link $prefix/bin/mvim $prefix/bin/vim
islocal gvim     || link $prefix/bin/mvim $prefix/bin/gvim
islocal rvim     || link $prefix/bin/mvim $prefix/bin/rvim
islocal rmvim    || link $prefix/bin/mvim $prefix/bin/rmvim
islocal rgvim    || link $prefix/bin/mvim $prefix/bin/rgvim
islocal view     || link $prefix/bin/mvim $prefix/bin/view
islocal gview    || link $prefix/bin/mvim $prefix/bin/gview
islocal mview    || link $prefix/bin/mvim $prefix/bin/mview
islocal vimdiff  || link $prefix/bin/mvim $prefix/bin/vimdiff
islocal gvimdiff || link $prefix/bin/mvim $prefix/bin/gvimdiff
islocal mvimdiff || link $prefix/bin/mvim $prefix/bin/mvimdiff
islocal viman    || link $prefix/bin/mvim $prefix/bin/viman
islocal mviman   || link $prefix/bin/mvim $prefix/bin/mviman
islocal gviman   || link $prefix/bin/mvim $prefix/bin/gviman

use common
