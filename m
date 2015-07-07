From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET v2 block/for-4.3] blkcg: blkcg_policy methods cleanup
Date: Tue,  7 Jul 2015 11:51:26 -0400
Message-ID: <1436284293-4666-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=zd/XxEe5Oq0nMXsGsFaoRQ6FVGqC99h3JJWm+mWhTx4=;
        b=jKuGTmfGSfvyKmd3rcbfzqIb/8F+qn7extfMZDjmy816UdbKnxCYXGnOZbaobBQyj5
         4od0eiiJkEH8nzEWrlRsxq9JFa8x7uGObt7GNTE5ghHIqgJZlnhttnWDV8zots7uMkjv
         ogZKQQgbUi0l3IOwS326m+zk8Ng/N2NRi5KhhOQ/Yo1Ec4aerJQaEQFbjmQGXcFGTTED
         8tehmsi0ER1Mzor68nlaYlzGx1z2Nxc+i4TFKPGkJhK3GpPaQeI87k5ZxEicZzYKBlE9
         Ct9QPEd7y8EU7Q0xV0lPospumzTHnY/h+X2U+GfTC6kNxashhaFljScAoZZxo2mjEGbm
         Csrg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

This is v2 of blkcg_policy methods cleanup patchset.  Changes from the
last take [L] are

* Rebased on top of v4.2-rc1 and other pending patches.  v4.2-rc1
  added a patch to add per-blkcg policy data which is allocated by
  blkcg core as per-blkcg_gq policy data was before this patchset
  making the two inconsistent.  I'll follow up with per-blkcg policy
  data update.

This patchset contains assorted cleanups for blkcg_policy methods.

* alloc/free are added.  exit is dropped.

* blk-throttle's async percpu allocation is replaced with direct
  allocation.

* all methods now take blkcg_policy_data instead of blkcg_gq.

Nothing too controversial.

Jens, as we're at the beginning of the 4.2 merge window, I'll ping /
repost this patchset along with other pending patchsets once -rc1
drops.

This patchset contains the following seven patches.

 0001-blkcg-remove-unnecessary-request_list-blkg-NULL-test.patch
 0002-blkcg-use-blkg_free-in-blkcg_init_queue-failure-path.patch
 0003-blkcg-make-blkcg_activate_policy-allow-NULL-pd_init_.patch
 0004-blkcg-replace-blkcg_policy-pd_size-with-pd_alloc-fre.patch
 0005-blk-throttle-remove-asynchrnous-percpu-stats-allocat.patch
 0006-blk-throttle-clean-up-blkg_policy_data-alloc-init-ex.patch
 0007-blkcg-make-blkcg_policy-methods-take-a-pointer-to-bl.patch

0001-0003 are misc cleanups.  0004-0006 add alloc/free methods and
remove blk-throttle's async percpu allocation mechanism.  0007 makes
all methods take blkcg_policy_data.

This patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-blkcg-methods-cleanup

and is on top of

  d770e558e219 ("Linux 4.2-rc1")
+ [1] [PATCHSET block/for-4.3] writeback: cgroup writeback updates
+ [2] [PATCHSET v2 block/for-4.3] block, cgroup: make cfq charge async IOs to the appropriate blkcgs

diffstat follows, thanks.

 block/blk-cgroup.c         |   52 +++++--------
 block/blk-throttle.c       |  173 +++++++++++++--------------------------------
 block/cfq-iosched.c        |   38 +++++++--
 include/linux/blk-cgroup.h |   31 +++-----
 4 files changed, 116 insertions(+), 178 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1435113853-12053-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[1] http://lkml.kernel.org/g/1436281823-1947-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[2] http://lkml.kernel.org/g/1436283361-3889-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
