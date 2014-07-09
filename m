From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCHSET cgroup/for-3.17] cgroup: remove sane_behavior support
 on non-default hierarchies
Date: Wed, 9 Jul 2014 15:25:00 +0800
Message-ID: <53BCEE4C.6080006@huawei.com>
References: <1404344747-7957-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404344747-7957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 2014/7/3 7:45, Tejun Heo wrote:
> Hello,
> 
> sane_behavior has been used as a development vehicle for the default
> unified hierarchy.  Now that the default hierarchy is in place, the
> flag became redundant and confusing as its usage is allowed on all
> hierarchies.  There are gonna be either the default hierarchy or
> legacy ones.  Let's make that clear by removing sane_behavior support
> on non-default hierarchies.
> 
> This patchset contains the following four patches.
> 
>  0001-cgroup-remove-CGRP_ROOT_OPTION_MASK.patch
>  0002-cgroup-make-interface-file-cgroup.sane_behavior-lega.patch
>  0003-cgroup-remove-sane_behavior-support-on-non-default-h.patch
>  0004-cgroup-clean-up-sane_behavior-handling.patch
> 
> 0001 is a trivial cleanup.
> 
> 0002 removes "cgroup.sane_behavior" from the default hierarchy.
> 
> 0003 removes sane_behavior support on non-default hierarchies.
> 
> 0004 cleans up sane_behavior handling.
> 
> This patchset is on top of a497c3ba1d97 ("Linux 3.16-rc2") and
> available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-dfl-instead-of-sane
> 
> diffstat follows.  Thanks.
> 
>  block/blk-throttle.c   |    6 +-
>  include/linux/cgroup.h |  128 ++++++++++++++++++++-----------------------------
>  kernel/cgroup.c        |   96 +++++++++++++++---------------------
>  kernel/cpuset.c        |   33 +++++-------
>  mm/memcontrol.c        |    7 +-
>  5 files changed, 117 insertions(+), 153 deletions(-)
> 

Acked-by: Li Zefan <lizefan@huawei.com>

I'm rebasing my cpuset patchset against this.
