From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
Date: Tue, 13 May 2014 14:34:53 +0800
Message-ID: <5371BD0D.9080801@huawei.com>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399380266-3324-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On 2014/5/6 20:44, Tejun Heo wrote:
> Hello,
> 
> This patchset implements a new cftype operation ->write() and replace
> ->write_string() and ->trigger() with it.  ->write() is similar to
> ->write_string() but maps directly to the kernfs write operation and
> has access to all available context information including the
> associated kernfs_open_file, which will make things like implementing
> kernfs active protection manipulation easier.
> 
> ->write_string() becomes redundant and ->trigger() has always been
> spurious.  This patch replaces all users of the two methods to
> ->write() and remove them.
> 
> This patchset contains the following five patches.
> 
>  0001-cgroup-implement-cftype-write.patch
>  0002-cgroup-replace-cftype-write_string-with-cftype-write.patch
>  0003-cgroup-replace-cftype-trigger-with-cftype-write.patch
>  0004-cgroup-convert-tasks-and-cgroup.procs-handle-to-use-.patch
>  0005-cgroup-remove-cgroup-control_kn.patch
> 
> 0001 implements cftype->write().
> 
> 0002-0003 replace cftype->write_string() and ->trigger() with it.
> 
> 0004 convert "tasks" and "cgroup.procs" handler too.
> 
> 0005 removes cgroup->control_kn as the kernfs_node is now directly
> accessible from kernfs_open_file.
> 
> This patchset is on top of
> 
>   cgroup/for-3.16 12d3089c192c ("kernel/cpuset.c: convert printk to pr_foo()")
> + [1] [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
> 
> and available on the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates
> 
> diffstat follows.
> 
>  block/blk-throttle.c      |   32 ++++++++---------
>  block/cfq-iosched.c       |   28 +++++++--------
>  include/linux/cgroup.h    |   40 +++++++++++----------
>  kernel/cgroup.c           |   85 +++++++++++++++++++++++-----------------------
>  kernel/cgroup_freezer.c   |   20 ++++------
>  kernel/cpuset.c           |   16 ++++----
>  mm/hugetlb_cgroup.c       |   33 +++++++++--------
>  mm/memcontrol.c           |   80 +++++++++++++++++++++++--------------------
>  net/ipv4/tcp_memcontrol.c |   31 +++++++++-------
>  security/device_cgroup.c  |   14 +++----
>  10 files changed, 197 insertions(+), 182 deletions(-)
> 

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
