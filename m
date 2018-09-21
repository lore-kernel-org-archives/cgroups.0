From: Dennis Zhou <dennisszhou@gmail.com>
Subject: Re: [PATCH v3 00/12] block: always associate blkg and refcount
 cleanup
Date: Fri, 21 Sep 2018 16:56:40 -0400
Message-ID: <20180921205640.GA50648@dennisz-mbp.dhcp.thefacebook.com>
References: <20180911184137.35897-1-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jLr1Wi7Jq0DmlrBbAYR4iPsSYBPIP3Xirr6J/hLGHho=;
        b=V9Pr20YMM6I5bm86UHGSJb+uGKi+gan7BoRfvp+Ez1XmdNB68MM2wzNZbm99qupNRP
         RxL5vl47XefNTqIZXzNtkUu0lCJCrDUcHhZMnqCACjCgJz6yYP3E/vyntSsDXG9eq+Kp
         BUDL9/s8X/80vKhplbuo+WSCa4VNaZH/xS0DSGcH0NeIYEh+DbF8jFO8wf5NkiO4q7wU
         tK0MruYZo5nsmicSXwLA8XakSVp8dvwzqdE1KOUKeHXGVXZ7yu152dS4mJSwW+VNkbLk
         UkVm7W6xFrm4I+DE1loGRiktoL3C2XhXcQ0IWEL83NY/MU1uX+v1cgBbr2gbJH4Ud9bp
         OUBA==
Content-Disposition: inline
In-Reply-To: <20180911184137.35897-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Jens,

On Tue, Sep 11, 2018 at 02:41:25PM -0400, Dennis Zhou wrote:
> Hi everyone,
> 
> v3: a few minor fixes.
>   0003: Updated the comment to bio_associate_blkg to reflect closest
>         association.
>         Removed a return branch in __bio_lookup_create.
>   0009: Removed an unnecessary rcu_read_(un)lock pair.
>   0010: Fixed blkg null pointer... blkg->blkcg => blkcg.
> 
> This is rebased onto axboe#for-4.20/block 902d53914f64.
> 
> From v2 below (updated):
> ------
> This is a followup to the patch series I sent out earlier [1] containing
> the middle two points:
>   1. always associate a bio with a blkg
>   2. remove the extra css ref held by bios and utilize the blkg ref
> 
> The major difference with v2 is that error handling on blkg creation
> and association failure is handled more gracefully. Rather than having
> the complex logic to fallback to root, failures walk up the blkg tree.
> This seems more natural and less prone to error with the many possible
> failure scenarios.
> 
> Additionally, there are fixes for kbuild errors and some key details
> overlooked by me in the first series that were pointed out in review.
> 
> Modified from the first patchset:
> First, both blk-throttle and blk-iolatency rely on blkg association
> to enable their policies. Rather than each policy (and future policies)
> implement this logic independently, this consolidates it such that
> all bios are tagged with a blkg.
> 
> Second, with the addition of always having a blkg reference, the blkcg
> can now be referenced through it rather than maintaining an additional
> pointer and reference. So let's clean this up.
> 
> [1] https://lore.kernel.org/lkml/20180831015356.69796-1-dennisszhou@gmail.com/T
> 
> This patchset contains the following 12 patches:
>   0001-blkcg-fix-ref-count-issue-with-bio_blkcg-using-task_.patch
>   0002-blkcg-update-blkg_lookup_create-to-do-locking.patch
>   0003-blkcg-convert-blkg_lookup_create-to-find-closest-blk.patch
>   0004-blkcg-always-associate-a-bio-with-a-blkg.patch
>   0005-blkcg-consolidate-bio_issue_init-to-be-a-part-of-cor.patch
>   0006-blkcg-associate-a-blkg-for-pages-being-evicted-by-sw.patch
>   0007-blkcg-associate-writeback-bios-with-a-blkg.patch
>   0008-blkcg-remove-bio-bi_css-and-instead-use-bio-bi_blkg.patch
>   0009-blkcg-remove-additional-reference-to-the-css.patch
>   0010-blkcg-cleanup-and-make-blk_get_rl-use-blkg_lookup_cr.patch
>   0011-blkcg-change-blkg-reference-counting-to-use-percpu_r.patch
>   0012-blkcg-rename-blkg_try_get-to-blkg_tryget.patch
> 
> This patchset is on top of axboe#for-4.20/block 902d53914f64.
> 
> diffstats below:
> 
> Dennis Zhou (Facebook) (12):
>   blkcg: fix ref count issue with bio_blkcg using task_css
>   blkcg: update blkg_lookup_create to do locking
>   blkcg: convert blkg_lookup_create to find closest blkg
>   blkcg: always associate a bio with a blkg
>   blkcg: consolidate bio_issue_init to be a part of core
>   blkcg: associate a blkg for pages being evicted by swap
>   blkcg: associate writeback bios with a blkg
>   blkcg: remove bio->bi_css and instead use bio->bi_blkg
>   blkcg: remove additional reference to the css
>   blkcg: cleanup and make blk_get_rl use blkg_lookup_create
>   blkcg: change blkg reference counting to use percpu_ref
>   blkcg: rename blkg_try_get to blkg_tryget
> 
>  Documentation/admin-guide/cgroup-v2.rst |   8 +-
>  block/bfq-cgroup.c                      |   4 +-
>  block/bfq-iosched.c                     |   2 +-
>  block/bio.c                             | 158 ++++++++++++++++--------
>  block/blk-cgroup.c                      | 123 ++++++++++++------
>  block/blk-iolatency.c                   |  26 +---
>  block/blk-throttle.c                    |  13 +-
>  block/bounce.c                          |   4 +-
>  block/cfq-iosched.c                     |   4 +-
>  drivers/block/loop.c                    |   5 +-
>  drivers/md/raid0.c                      |   2 +-
>  fs/buffer.c                             |  10 +-
>  fs/ext4/page-io.c                       |   2 +-
>  include/linux/bio.h                     |  23 ++--
>  include/linux/blk-cgroup.h              | 145 +++++++++++++++-------
>  include/linux/blk_types.h               |   1 -
>  include/linux/cgroup.h                  |   2 +
>  include/linux/writeback.h               |   5 +-
>  kernel/cgroup/cgroup.c                  |  48 +++++--
>  kernel/trace/blktrace.c                 |   4 +-
>  mm/page_io.c                            |   2 +-
>  21 files changed, 381 insertions(+), 210 deletions(-)
> 
> Thanks,
> Dennis

I reran some basic test again for sanity and it seems to be fine on my
end. There are at least acks, and some reviewed-by's on the series. Is
there anything else you think needs to be done before we let this bake
in for-4.20/for-next?

Thanks,
Dennis
