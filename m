From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCHSET cgroup/for-3.17] cgroup, blkcg, memcg: make blkcg depend
 on memcg on unified hierarchy
Date: Fri, 4 Jul 2014 14:29:17 +0800
Message-ID: <53B649BD.2010705@huawei.com>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403917392-32555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, vgoyal@redhat.com, axboe@kernel.dk

Hi Tejun,

On 2014/6/28 9:03, Tejun Heo wrote:
> Hello, guys.
> 
> Currently, the blkio subsystem attributes all of writeback IOs to the
> root.  One of the issues is that there's no way to tell who originated
> a writeback IO from block layer.  Those IOs are usually issued
> asynchronously from a task which didn't have anything to do with
> actually generating the dirty pages.  The memory subsystem, when
> enabled, already keeps track of the ownership of each dirty page and
> it's desirable for blkio to piggyback instead of adding its own
> per-page tag.

It's great to see this being worked on!

> 
> This can be achieved on the unified hierarchy without too much
> difficulty.  This patchset implements a dependency mechanism in the
> cgroup such that a subsystem can depends on other subsystems.  If
> available, the depended-upon subsystems are enabled together
> implicitly when the subsystem is turned on.  Implicitly enabled
> subsystems are invisible and the dependencies are transparent to
> userland.
> 
> This patchset implements the dependency mechanism in cgroup core and
> make blkcg depend on memcg.  This doesn't actually solve the writeback
> problem yet but is an important step.
> 
> This patchset contains the following six patches.
> 
>  0001-cgroup-reorganize-cgroup_subtree_control_write.patch
>  0002-cgroup-introduce-cgroup-subtree_control.patch
>  0003-cgroup-make-interface-files-visible-iff-enabled-on-c.patch
>  0004-cgroup-implement-cgroup_subsys-css_reset.patch
>  0005-cgroup-implement-cgroup_subsys-depends_on.patch
>  0006-blkcg-memcg-make-blkcg-depend-on-memcg-on-the-defaul.patch
> 
> 0001-0005 gradually implement the dependency mechanism.
> 
> 0006 makes blkcg depend on memcg.
> 
> This patchset is on top of a497c3ba1d97 ("Linux 3.16-rc2") and
> available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-dependency
> 
> diffstat follows.  Thanks.
> 
>  Documentation/cgroups/cgroups.txt           |   14 +
>  Documentation/cgroups/unified-hierarchy.txt |   23 ++-
>  block/blk-cgroup.c                          |    7
>  include/linux/cgroup.h                      |   20 ++
>  kernel/cgroup.c                             |  201 ++++++++++++++++++++++------
>  mm/memcontrol.c                             |   24 +++
>  6 files changed, 243 insertions(+), 46 deletions(-)
> 

Acked-by: Li Zefan <lizefan@huawei.com>
