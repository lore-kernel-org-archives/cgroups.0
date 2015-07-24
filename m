From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET block/for-4.3] blkcg: implement interface for the unified hierarchy
Date: Fri, 24 Jul 2015 14:43:44 -0400
Message-ID: <1437763434-28699-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=XGjNoCOvbixvJtaBGyZfX1eK4sE7uS35HKBoJRUX+pM=;
        b=0+A3yvSDCJo2xMp72X8R2oKF8r2sKhWUACu9bVHMwN7ZlO02vQEIf7VMV1KCOpM5nm
         mg5qh1xif6YF48O4+S3mtQZFUk0EGXIOg2aarrTtSa9Dt2S3fzZWdjU9/6grUtUJBDAP
         onxu86wRIynWBhiMMflBCQMizWX7rHtMHrrrpOxAfgb8L8pONWUAZMlsrwjPRzSYHJQo
         NPdf/Ltm9WFl3sjlW/M5usmRyYwy3tuW98cZ83a1xiz3Iv5ASBNz/JqcV8sYm+nSvz37
         mtpe4ye/VZtuIIK/LCEz5RLve/lm+Jj+2dk3mRn10OlvljoQ+IeM/jfwxaUIikvmdxzm
         lEJQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

blkcg interface grew to be the biggest of all controllers and
unfortunately most inconsistent too.  The interface files are
inconsistent with a number of cloes duplicates.  Some files have
recursive variants while others don't.  There's distinction between
normal and leaf weights which isn't intuitive and there are a lot of
stat knobs which don't make much sense outside of debugging and expose
too much implementation details to userland.

In the unified hierarchy, everything is always hierarchical and
internal nodes can't have tasks rendering the two structural issues
twisting the current interface.  The interface has to be updated in a
significant anyway and this is a good chance to revamp it as a whole.
This patchset implements blkcg interface for the unified hierarchy.

* blkcg is identified by "io" instead of "blkio" on the unified
  hierarchy.  Given that the whole interface is updated anyway, the
  rename shouldn't carry noticeable conversion overhead.

* The original interface consisted of 27 files is replaced with the
  following three files.

  blkio.stat	: per-blkcg stats
  blkio.weight	: per-cgroup and per-cgroup-queue weight settings
  blkio.max	: per-cgroup-queue bps and iops max limits

For more details, please refer to
Documentation/cgroups/unified-hierarchy.txt.

This patchset contains the following 10 patches.

 0001-cgroup-don-t-print-subsystems-for-the-default-hierar.patch
 0002-cgroup-introduce-cgroup_subsys-legacy_name.patch
 0003-blkcg-remove-unnecessary-NULL-checks-from-__cfqg_set.patch
 0004-blkcg-refine-error-codes-returned-during-blkcg-confi.patch
 0005-blkcg-rename-subsystem-name-from-blkio-to-io.patch
 0006-blkcg-mark-existing-cftypes-as-legacy.patch
 0007-blkcg-move-body-parsing-from-blkg_conf_prep-to-its-c.patch
 0008-blkcg-separate-out-tg_conf_updated-from-tg_set_conf.patch
 0009-blkcg-misc-preparations-for-unified-hierarchy-interf.patch
 0010-blkcg-implement-interface-for-the-unified-hierarchy.patch

0001-0002 are cgroup prep patches.  0003-0004 are misc prep patches.
0005 renames blkio to io on the unified hierarchy.  0006-0010
implement the new interface.

This patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-blkcg-unified-hier

and is on top of

  block/for-linus f3f5da624e0a ("block: Do a full clone when splitting discard bios")
+ [1] [PATCHSET block/for-4.3] writeback: cgroup writeback updates
+ [2] [PATCHSET v2 block/for-4.3] block, cgroup: make cfq charge async IOs to the appropriate blkcgs
+ [3] [PATCHSET v3 block/for-4.3] blkcg: blkcg policy methods and data handling cleanup
+ [4] [PATCHSET v2 block/for-4.3] blkcg: blkcg stats cleanup

diffstat follows.  Thanks.

 Documentation/cgroups/unified-hierarchy.txt |   57 ++++++++-
 block/bio.c                                 |    2 
 block/blk-cgroup.c                          |  105 +++++++++++++---
 block/blk-throttle.c                        |  176 +++++++++++++++++++++++-----
 block/cfq-iosched.c                         |   91 +++++++++++---
 include/linux/backing-dev.h                 |    2 
 include/linux/blk-cgroup.h                  |   12 +
 include/linux/cgroup-defs.h                 |    3 
 include/linux/cgroup_subsys.h               |    2 
 kernel/cgroup.c                             |   41 ++++--
 mm/backing-dev.c                            |    4 
 11 files changed, 399 insertions(+), 96 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1435268337-1738-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[1] http://lkml.kernel.org/g/1436281823-1947-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[2] http://lkml.kernel.org/g/1436283361-3889-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[3] http://lkml.kernel.org/g/1436637654-28110-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[4] http://lkml.kernel.org/g/1436724043-12986-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
