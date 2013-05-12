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

def dotfiles():
    return call('git ls-files .*').splitlines()

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:
        if not (exc.errno == errno.EEXIST and os.path.isdir(path)):
            raise

def install(args):
    if args.settings in ('gravity', 'gravity-mbp'):
      args.tabstop = 2
      args.email = 'jkurkowski@gravity.com'

    dest = os.path.expanduser('~/')
    for f in dotfiles():
        dest_dotfile = os.path.join(dest, f)
        dest_dotfile_dir = os.path.dirname(dest_dotfile)
        mkdir_p(dest_dotfile_dir)

        src = os.path.join(MOD_DIR, f)
        shutil.copy2(src, dest_dotfile)

    hostspecific = os.path.join(dest, '.hostspecific')
    if args.settings:
      settings = os.path.join(MOD_DIR, 'settings', args.settings)
      settings_cmd = 'cat %s > %s' % (settings, hostspecific)
      subprocess.check_call(settings_cmd, shell=True)
    else:
      with open(hostspecific, 'w') as f:
        pass

    vimrc = os.path.join(dest, '.vimrc')
    tabstop_cmd = """perl -pi -e 's/set tabstop=4/set tabstop=%d/g' %s""" % (args.tabstop, vimrc)
    call(tabstop_cmd)

    gitrc = os.path.join(dest, '.gitconfig')
    old_email = re.escape('john.kurkowski@gmail.com')
    new_email = re.escape(args.email)
    email_cmd = """perl -pi -e 's/%s/%s/g' %s""" % (old_email, new_email, gitrc)
    call(email_cmd)

def export(args):
    """The inverse of install."""
    src = os.path.expanduser('~/')
    for f in dotfiles():
        shutil.copy2(os.path.join(src, f), os.path.join(MOD_DIR, f))

if __name__ == "__main__":
    settings_choices = [os.path.basename(f) for f in glob.glob(os.path.join(MOD_DIR, 'settings', '[A-Za-z]*'))]

    parser = argparse.ArgumentParser(description="Install dotfiles")
    subparsers = parser.add_subparsers(title='subcommands')

    install_cmd = subparsers.add_parser('install')
    install_cmd.set_defaults(func=install)
    install_cmd.add_argument('--tabstop', '-ts', type=int, default=4, help='Vim tabstop (default: 4)')
    install_cmd.add_argument('--email', '-e', default='john.kurkowski@gmail.com', help='Git author email address (default: personal)')
    install_cmd.add_argument('settings', choices=settings_choices, help='Install a predefined suite of settings.')

    export_cmd = subparsers.add_parser('export')
    export_cmd.set_defaults(func=export)

    args = parser.parse_args()
    args.func(args)

