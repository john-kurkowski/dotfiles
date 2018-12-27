function bobthefish_colors -S -d 'Define a custom bobthefish color scheme'

    # Extra colors from iceberg theme
    set -l cursorlnbg      1e2132
    set -l lledgebg        818596
    set -l lledgefg        17171b
    set -l llgradientbg    5a5f72
    set -l llgradientfg    17171b
    set -l llbasebg        34394e
    set -l llbasefg        696d80

    # Then override everything you want!
    # Note that these must be defined with `set -x`
    set -x color_initial_segment_exit     $cursorlnbg red --bold
    set -x color_initial_segment_su       $cursorlnbg green --bold
    set -x color_initial_segment_jobs     $cursorlnbg blue --bold

    set -x color_path                     $llbasebg white
    set -x color_path_basename            $llbasebg cyan --bold
    set -x color_path_nowrite             red black
    set -x color_path_nowrite_basename    red black --bold

    set -x color_repo                     green black
    set -x color_repo_work_tree           $llbasebg black --bold
    set -x color_repo_dirty               red black
    set -x color_repo_staged              yellow black

    set -x color_vi_mode_default          blue black --bold
    set -x color_vi_mode_insert           green black --bold
    set -x color_vi_mode_visual           yellow black --bold

    set -x color_vagrant                  cyan black
    set -x color_k8s                      magenta white --bold
    set -x color_username                 $lledgebg $lledgefg --bold
    set -x color_hostname                 $lledgebg $lledgefg
    set -x color_rvm                      magenta black --bold
    set -x color_virtualfish              blue black --bold
    set -x color_virtualgo                blue black --bold
    set -x color_desk                     blue black --bold
end
