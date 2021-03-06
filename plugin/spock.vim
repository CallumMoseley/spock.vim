python3 << endpy
import vim
from spock.interface import Spock, get_track_info_string
spock = Spock()

def echo(s):
    vim.command(f'echo "{s}"')
endpy

function! SpockStatusLine() abort
    return spock#status()
endfunction

com! -nargs=0 SpockResume           call spock#resume()
com! -nargs=0 SpockPause            call spock#pause()
com! -nargs=0 SpockNext             call spock#next()
com! -nargs=0 SpockPrev             call spock#prev()

com! -nargs=0 SpockVolumeUp         call spock#volume_up()
com! -nargs=0 SpockVolumeDown       call spock#volume_down()
com! -nargs=1 SpockVolume           call spock#volume(<q-args>)
com! -nargs=? SpockShuffle          call spock#shuffle(<q-args>)
com! -nargs=? SpockRepeat           call spock#repeat(<q-args>)

com! -nargs=0 SpockDevices          call spock#devices()
com! -nargs=1 SpockDevice           call spock#device(<q-args>)

com! -nargs=1 SpockPlay             call spock#play(<q-args>)
com! -nargs=1 SpockPlayArtist       call spock#play(<q-args>, 0, 1)
com! -nargs=1 SpockPlayAlbum        call spock#play(<q-args>, 0, 0, 1)
com! -nargs=1 SpockPlayTrack        call spock#play(<q-args>, 0, 0, 0, 1)
com! -nargs=1 SpockPlayPlaylist     call spock#play(<q-args>, 0, 0, 0, 0, 1)

com! -nargs=1 SpockLPlay            call spock#play(<q-args>, 1)
com! -nargs=1 SpockLPlayArtist      call spock#play(<q-args>, 1, 1)
com! -nargs=1 SpockLPlayAlbum       call spock#play(<q-args>, 1, 0, 1)
com! -nargs=1 SpockLPlayTrack       call spock#play(<q-args>, 1, 0, 0, 1)
com! -nargs=1 SpockLPlayPlaylist    call spock#play(<q-args>, 1, 0, 0, 0, 1)

com! -nargs=1 SpockExplore          call spock#explore(<q-args>)
com! -nargs=1 SpockExploreArtist    call spock#explore(<q-args>, 0, 1)
com! -nargs=1 SpockExploreAlbum     call spock#explore(<q-args>, 0, 0, 1)
com! -nargs=1 SpockExploreTrack     call spock#explore(<q-args>, 0, 0, 0, 1)
com! -nargs=1 SpockExplorePlaylist  call spock#explore(<q-args>, 0, 0, 0, 0, 1)

com! -nargs=? SpockLExplore         call spock#explore(<q-args>, 1)
com! -nargs=? SpockLExploreArtist   call spock#explore(<q-args>, 1, 1)
com! -nargs=? SpockLExploreAlbum    call spock#explore(<q-args>, 1, 0, 1)
com! -nargs=? SpockLExploreTrack    call spock#explore(<q-args>, 1, 0, 0, 1)
com! -nargs=? SpockLExplorePlaylist call spock#explore(<q-args>, 1, 0, 0, 0, 1)
