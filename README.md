**show_github_url.vim**
=================

Description
-----------

This vim plugin helps you to show remote Github code viewer URL about local file easy.

Installation
============

* locate this plugin

locate this show_github_url.vim file to ~/.vim/plugin/
or if you use Neobundle.vim, write this line to your .vimrc
```vim
NeoBundle 'nakatakeshi/show_github_url.vim'
```
* add key mapping

this plugin give function GithubUrl().
so add mapping setting like this line.
```vim
noremap gu :call GithubUrl()<enter>
```

How to use
============

if your vim current cursor on some Github's repository local file,
when you type gu( if you set mapping this), then this plugin show
`https://github.com/$remote_url/blob/$branch/$path_to_local_file#L$line`


