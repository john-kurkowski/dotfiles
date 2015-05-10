#!/usr/bin/env python

from __future__ import with_statement

import argparse
import errno
import glob
import os
import re
import shlex
import shutil
import subprocess

MOD_DIR = os.path.abspath(os.path.dirname(__file__))


def call(cmd):
    split_cmd = shlex.split(cmd)
    p = subprocess.Popen(split_cmd, stdout=subprocess.PIPE)
    stdout, _ = p.communicate()
    if p.returncode:
        raise subprocess.CalledProcessError(p.returncode, split_cmd)
    return stdout


def dotdirs():
    def extract_dir(path):
        spl = path.split(os.sep, 1)
        return spl[0] if len(spl) > 1 else None

    return set(filter(bool, (extract_dir(d) for d in dotfiles())))


def dotfiles():
    return call('git ls-files .*').splitlines()


def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:
        if not (exc.errno == errno.EEXIST and os.path.isdir(path)):
            raise


def install(args):
    dest = os.path.expanduser('~/')

    for f in dotdirs():
        dest_dotdir = os.path.join(dest, f)
        try:
            shutil.rmtree(dest_dotdir)
        except OSError as exc:
            if exc.errno != errno.ENOENT:
                raise

    for f in dotfiles():
        dest_dotfile = os.path.join(dest, f)
        dest_dotfile_dir = os.path.dirname(dest_dotfile)
        mkdir_p(dest_dotfile_dir)

        src = os.path.join(MOD_DIR, f)
        is_empty_dir = os.path.isdir(src) and not os.listdir(src)
        if not is_empty_dir:
            shutil.copy2(src, dest_dotfile)

    hostspecific = os.path.join(dest, '.hostspecific')
    if args.settings:
        settings = os.path.join(MOD_DIR, 'settings', args.settings)
        shutil.copy2(settings, hostspecific)
    else:
        with open(hostspecific, 'w') as f:
            pass

    gitrc = os.path.join(dest, '.gitconfig')
    old_email = re.escape('john.kurkowski@gmail.com')
    new_email = re.escape(args.email)
    email_cmd = """perl -pi -e 's/%s/%s/g' %s""" % (old_email, new_email, gitrc)
    call(email_cmd)


def export(args):
    """The inverse of install."""
    src = os.path.expanduser('~/')
    for f in dotfiles():
        is_empty_dir = os.path.isdir(f) and not os.listdir(f)
        if not is_empty_dir:
            shutil.copy2(os.path.join(src, f), os.path.join(MOD_DIR, f))

if __name__ == "__main__":
    settings_choices = [os.path.basename(f) for f in glob.glob(os.path.join(MOD_DIR, 'settings', '[A-Za-z]*'))]

    parser = argparse.ArgumentParser(description="Install dotfiles")
    subparsers = parser.add_subparsers(title='subcommands')

    install_cmd = subparsers.add_parser('install')
    install_cmd.set_defaults(func=install)
    install_cmd.add_argument('--email', '-e', default='john.kurkowski@gmail.com', help='Git author email address (default: personal)')
    install_cmd.add_argument('settings', choices=settings_choices, help='Install a predefined suite of settings.')

    export_cmd = subparsers.add_parser('export')
    export_cmd.set_defaults(func=export)

    args = parser.parse_args()
    args.func(args)
