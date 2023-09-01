" File: show_github_url.vim
" Author: Takeshi Nakata (nakatatakeshi@gmail.com)

" -----------------
" Description
" -----------------
"
" this plugin echo github url of current cursor's file, line, repository,
" branch.
" when current branch exists only local, then echo nothing.
"
" -------------------
"  How to use
" -------------------
"
"   you can use this plugin by setting .vimrc
"   ----------------------------------
"   noremap gu :call GithubUrl()<enter>
"   ----------------------------------

let s:save_cpo = &cpo
set cpo&vim

function! GithubUrl()
    let l:root_path = s:FindGitBranchRoot()
    let l:cur_path  = expand("%:p")
    let l:relative_path = substitute(l:cur_path,l:root_path . '/', '', 'g')
    let l:git_full_branch_name = s:GetGitBranchName()

    let l:git_remote_url = s:GetRemoteUrl()
    if l:git_remote_url == ''
        return
    endif


    let l:url = printf("%s/blob/%s/%s#L%s",
        \l:git_remote_url,
        \l:git_full_branch_name,
        \l:relative_path,
        \line(".")
    \ )
    echo l:url

    let l:_ = system(printf("open %s", l:url))
endfunction

function! s:FindGitBranchRoot()
    let l:cur_dir = expand("%:p")
    let s:search_root_file = '.git'

    while 1
        if l:cur_dir == ''
            return
        endif
        let l:cur_dir = substitute(l:cur_dir,'/[^(/)]*$','','g')
        if isdirectory(l:cur_dir . '/'. s:search_root_file)
            return l:cur_dir
        endif
    endwhile
    return ''
endfunction

function! s:GetGitBranchName()
    let l:full_branch_name = system("git rev-parse --abbrev-ref=loose HEAD 2> /dev/null")
    return substitute(l:full_branch_name, '\n', '', 'g')
endfunction

function! s:GetRemoteUrl()
    let l:git_branch_name =s:GetGitBranchName()
    let l:git_remote_branch_name = system(printf(
        \'git branch -a |grep -v "\->" |grep "/%s\$" |grep remote |sed "s/  remotes\///" |head -1 |sed "s/\/%s//" 2> /dev/null',
        \substitute(l:git_branch_name, '/', '\\/', 'g'),
        \substitute(l:git_branch_name, '/', '\\/', 'g'),
    \))
    let l:git_remote_url = ''

    let l:git_remote_name = substitute(
        \l:git_remote_branch_name,
        \'\n',
        \'',
        \'g'
    \)

    " when current is local repository, then create unexist remote branch name
    if l:git_remote_branch_name == ''
        let l:git_remote_name = "origin"
    endif

    let l:git_remote_url = substitute(
        \system(printf(
            \"git config remote.%s.url 2> /dev/null",
            \l:git_remote_name,
        \)),
        \ '\n',
        \ '',
        \ 'g'
    \)
    if l:git_remote_url =~ '^git@'
        let l:git_remote_url = substitute(
            \l:git_remote_url,
            \'^git@',
            \ '',
            \ 'g'
        \)
        let l:git_remote_url = substitute(
            \l:git_remote_url,
            \':',
            \ '/',
            \ 'g'
        \)
        let l:git_remote_url = 'https://' . l:git_remote_url
    endif
    if l:git_remote_url =~ '\.git$'
        let l:git_remote_url = substitute(
            \l:git_remote_url,
            \'\.git$',
            \ '',
            \ 'g'
        \)
    endif
    return l:git_remote_url
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
