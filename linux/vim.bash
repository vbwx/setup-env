difcopy "$(res vim)" $prefix/bin

islocal vi       || link $prefix/bin/vim $prefix/bin/vi
islocal gvim     || link $prefix/bin/vim $prefix/bin/gvim
islocal rvim     || link $prefix/bin/vim $prefix/bin/rvim
islocal rgvim    || link $prefix/bin/vim $prefix/bin/rgvim
islocal view     || link $prefix/bin/vim $prefix/bin/view
islocal gview    || link $prefix/bin/vim $prefix/bin/gview
islocal vimdiff  || link $prefix/bin/vim $prefix/bin/vimdiff
islocal gvimdiff || link $prefix/bin/vim $prefix/bin/gvimdiff
islocal viman    || link $prefix/bin/vim $prefix/bin/viman
islocal gviman   || link $prefix/bin/vim $prefix/bin/gviman

use common
