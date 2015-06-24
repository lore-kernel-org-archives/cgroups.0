From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET block/for-4.2/writeback] blkcg: blkcg_policy methods cleanup
Date: Tue, 23 Jun 2015 22:44:06 -0400
Message-ID: <1435113853-12053-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=k1foF6pEBPJaqjaRJdm5DbNX8tcTwXcKsgqp0arniSE=;
        b=DJXdUd+jyfbx2kg7E7NMey+jmSyuxOISGgGPR1u5+nAtp9TF+9U/qD0HsNGjvPRZjA
         ib/ai/nkRCkLyZETps+dLL11UmQ+czDL2wBj3JxB1lKe+3GwOURHQlPR6Ii80I11nGoE
         pijJOSkd04DNGaZrwNp5W6lOnrEF3UzR6wQhTe0QSHRDb8kZ5ao0KR3wt16zFj+U2VTY
         WUbmHidg8q5MEx1VNMv7sLxsUAEoeVxGRTgHillGt75aUHBkuh2ocPJdu9aHTgrHdnvD
         miXvXaSsw1DwxmbBWItlVKrlzb+hu6gf2mZN980uGJ8y4r/HUjveo+MBmM+O+wNTjI0r
         fV/w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

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

[1] block/for-4.2/writeback
[2] [PATCHSET block/for-4.2/writeback] block, cgroup: make cfq charge async IOs to the appropriate blkcgs

diffstat follows.  Thanks.

 block/blk-cgroup.c         |   53 +++++--------
 block/blk-throttle.c       |  173 +++++++++++++--------------------------------
 block/cfq-iosched.c        |   37 +++++++--
 include/linux/blk-cgroup.h |   31 +++-----
 4 files changed, 116 insertions(+), 178 deletions(-)

--
tejun

[1] 5857cd637bc0 ("bdi: fix wrong error return value in cgwb_create()").
[2] http://lkml.kernel.org/g/1433753973-23684-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
