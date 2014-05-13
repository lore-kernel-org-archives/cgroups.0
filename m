From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: remove cgroup_tree_mutex
Date: Tue, 13 May 2014 15:35:38 +0800
Message-ID: <5371CB4A.3030905@huawei.com>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399407574-21472-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/5/7 4:19, Tejun Heo wrote:
> Hello,
> 
> cgroup_tree_mutex was introduced during kernfs conversion to work
> around the cyclic locking dependency between kernfs active protection
> and cgroup_mutex.  Some file and directory operations need to acquire
> cgroup_mutex which puts the mutex under the kernfs active protection;
> however, cgroup also needs to access the hierarchy and the registered
> cftypes to detemine which files to remove, which obviously can't be
> done while holding cgroup_mutex anymore.
> 
> cgroup_tree_mutex nests above both cgroup_mutex and kernfs active
> protection and protects hierarchy and cftypes so that those file
> operations can be performed while holding it without cgroup_mutex.
> This works but is kinda cumbersome as most places end up taking both
> cgroup_tree_mutex and cgroup_mutex and there's on-going friction on
> what needs to be protected by which combination.
> 
> Furthermore, due to new requirements from subtree_control
> implementations, kernfs ended up growing full-blown mechanism to
> bypass active protection instead of just supporting self-removal and
> cgroup ended up using both mechanisms - two layered mutexes and active
> protection bypss - on different areas, which is totally unncessary.
> 
> This patchset converts everything over to kernfs active protection
> bypass and drops cgroup_tree_mutex making cgroup locking noticeably
> simpler.  It contains the following eight patches.
> 
>  0001-cgroup-reorganize-cgroup_create.patch
>  0002-cgroup-collapse-cgroup_create-into-croup_mkdir.patch
>  0003-cgroup-grab-cgroup_mutex-earlier-in-cgroup_subtree_c.patch
>  0004-cgroup-move-cgroup-kn-priv-clearing-to-cgroup_rmdir.patch
>  0005-cgroup-factor-out-cgroup_kn_lock_live-and-cgroup_kn_.patch
>  0006-cgroup-use-cgroup_kn_lock_live-in-other-cgroup-kernf.patch
>  0007-cgroup-nest-kernfs-active-protection-under-cgroup_mu.patch
>  0008-cgroup-remove-cgroup_tree_mutex.patch
> 
> 0001-0004 reorganize various kernfs handling paths so that they are
> more uniform in terms of active protection handling.
> 
> 0005 factors out two locking helpers - cgroup_kn_lock_live() and
> cgroup_kn_unlock() - which handle both kernfs active protection bypass
> and locking.
> 
> 0006 applies it to other kernfs method implementations which were
> grabbing cgroup_mutex under active protection.
> 
> 0007 reverses the locking dependency between cgroup_mutex and kernfs
> active protection so that the latter nests under the former, making
> cgroup_mutex equivalent to cgroup_tree_mutex.
> 
> 0008 removes cgroup_tree_mutex.
> 
> This patchset is on top of
> 
>   cgroup/for-3.16 12d3089c192c ("kernel/cpuset.c: convert printk to pr_foo()")
> + [1] [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
> + [2] [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
> 
> and is available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-kill-tree_mutex
> 
> diffstat follows.  Thanks.
> 
>  kernel/cgroup.c |  385 +++++++++++++++++++++++---------------------------------
>  1 file changed, 163 insertions(+), 222 deletions(-)
> 

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
