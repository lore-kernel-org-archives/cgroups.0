From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCHSET] cgroup: use static_keys for subsystem enabled and
 on_dfl tests
Date: Fri, 18 Sep 2015 17:14:07 +0800
Message-ID: <55FBD5DF.7060501@huawei.com>
References: <1442368285-16306-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442368285-16306-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On 2015/9/16 9:51, Tejun Heo wrote:
> cgroup_subsys->disabled and cgroup_on_dfl() tests are likely to be
> used in hot paths and seldom change.  The former is set once during
> boot and the latter only when a controller is migrated between the
> default hierarchy and traditional ones.
>
> This patchset makes these tests static_key based and contains the
> following four patches.
>
>   0001-jump_label-make-static_key_enabled-work-on-static_ke.patch
>   0002-cgroup-implement-static_key-based-cgroup_subsys_enab.patch
>   0003-cgroup-replace-cgroup_subsys-disabled-tests-with-cgr.patch
>   0004-cgroup-replace-cgroup_on_dfl-tests-in-controllers-wi.patch
>
> 0001 is a prep patch in jump_label.  0002 adds the needed static_keys.
> 0003-0004 convert the existing usages and drop the old tests.
>
> This patchset is on top of v4.3-rc1 and is availalbe in the following
> git branch.
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-jump-labels
>
> diffstat follows.  Thanks.
>
>   block/blk-throttle.c           |    2
>   block/cfq-iosched.c            |    4 -
>   include/linux/cgroup-defs.h    |    1
>   include/linux/cgroup.h         |   79 +++++++---------------------
>   include/linux/hugetlb_cgroup.h |    4 -
>   include/linux/jump_label.h     |   18 +++---
>   include/linux/memcontrol.h     |    4 -
>   kernel/cgroup.c                |  113 ++++++++++++++++++++++++++++++++++++++---
>   kernel/cpuset.c                |   23 ++++----
>   mm/memcontrol.c                |    4 -
>   10 files changed, 157 insertions(+), 95 deletions(-)
>

Acked-by: Zefan Li <lizefan@huawei.com>
