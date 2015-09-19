#!/usr/bin/env python

from __future__ import with_statement

import argparse
import errno
import glob
import os
import re
import shutil
import subprocess

MOD_DIR = os.path.abspath(os.path.dirname(__file__))


def dotdirs():
    '''The unique custom dirs tracked by this repo. Ignores intermediate dirs
    that don't contain tracked files.'''
    def extract_dir(path):
        spl = path.rsplit(os.sep, 1)
        is_dir = len(spl) > 1
        return spl[0] if is_dir else None

    return set(dotdir for dotdir in (extract_dir(d) for d in dotfiles()) if dotdir)


def dotfiles():
    return subprocess.check_output('git ls-files .*', shell=True).splitlines()


def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:
        if not (exc.errno == errno.EEXIST and os.path.isdir(path)):
            raise


def clear_tracked(dest):
    '''Clear files and dirs tracked by this repo, in the given destination dir.
    Does not clear untracked intermediate dirs or untracked top-level
    dotfiles.'''
    for dotfile in dotdirs():
        dest_dotdir = os.path.join(dest, dotfile)
        try:
            shutil.rmtree(dest_dotdir)
        except OSError as exc:
            if exc.errno != errno.ENOENT:
                raise


def copy_dotfiles(dest):
    for dotfile in dotfiles():
        dest_dotfile = os.path.join(dest, dotfile)
        dest_dotfile_dir = os.path.dirname(dest_dotfile)
        mkdir_p(dest_dotfile_dir)

        src = os.path.join(MOD_DIR, dotfile)
        is_empty_dir = os.path.isdir(src) and not os.listdir(src)
        if not is_empty_dir:
            shutil.copy2(src, dest_dotfile)


def copy_host_specific_dotfiles(dest, host_specific_settings):
    hostspecific = os.path.join(dest, '.hostspecific')
    if host_specific_settings:
        settings = os.path.join(MOD_DIR, 'settings', host_specific_settings)
        shutil.copy2(settings, hostspecific)
    else:
        with open(hostspecific, 'w') as _:
            pass


def install_user(dest, email):
    '''Set the email for Git commits on the system.'''
    gitrc = os.path.join(dest, '.gitconfig')
    old_email = re.escape('john.kurkowski@gmail.com')
    new_email = re.escape(email)
    email_cmd = """perl -pi -e 's/%s/%s/g' %s""" % (old_email, new_email, gitrc)
    subprocess.check_call(email_cmd, shell=True)


def install(args):
    '''Install dotfiles into home dir.'''
    dest = os.path.expanduser('~/')
    clear_tracked(dest)
    copy_dotfiles(dest)
    copy_host_specific_dotfiles(dest, args.settings)
    install_user(dest, args.email)


def export(dummy_args):
    """The inverse of install."""
    src = os.path.expanduser('~/')
    for dotfile in dotfiles():
        is_empty_dir = os.path.isdir(dotfile) and not os.listdir(dotfile)
        if not is_empty_dir:
            shutil.copy2(os.path.join(src, dotfile), os.path.join(MOD_DIR, dotfile))


def main():
    '''Parse args and execute their subcommand.'''
    setting_paths = glob.glob(os.path.join(MOD_DIR, 'settings', '[A-Za-z]*'))
    settings_choices = [os.path.basename(p) for p in setting_paths]

    parser = argparse.ArgumentParser(description="Install dotfiles")
    subparsers = parser.add_subparsers(title='subcommands')

    install_cmd = subparsers.add_parser('install')
    install_cmd.set_defaults(func=install)
    install_cmd.add_argument('--email', '-e', default='john.kurkowski@gmail.com',
                             help='Git author email address (default: personal)')
    install_cmd.add_argument('settings', choices=settings_choices,
                             help='Install a predefined suite of settings.')

    export_cmd = subparsers.add_parser('export')
    export_cmd.set_defaults(func=export)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
