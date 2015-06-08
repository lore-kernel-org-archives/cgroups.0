From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET block/for-4.2/writeback] block, cgroup: make cfq charge async IOs to the appropriate blkcgs
Date: Mon,  8 Jun 2015 17:59:25 +0900
Message-ID: <1433753973-23684-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=X4fiMaIfN/KwyHW/NxBOyTjRTEzjegdqJ4663w/BERU=;
        b=RKM93WTCE/AeC5T5f8z2LF8Y9j7jiZC6VdPomrYSocw5VS/WyBHrqvDkswnEcg0Hka
         vU4mo76bMK3EYSglIczvhxFMfX+IaH5d5JHRb9FL0+EFYq8w+vVvXM6UK2ySj5c9JzAi
         Dc1bJoTXBvQr82JG3Z8+pdvx/EV3mOOgZLnT88f2npkd58E5I+YRNE+feE8AfKD/yqy+
         lIAvQuz/qce8+LHWcu9d7t1jXSRujn1+Oj7BFaKC5CtQYYzdTjx242JmaAJxqTQFR6mD
         J6qarxcSOsJtXlWr6zpYAOXlrahwsn5VkWYb42WNIuNnhAu02PsL7E8jeSSF9MuJ6Hy0
         bThA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello,

cfq has always charged all async IOs to the root cgroup.  It didn't
have much choice as writeback didn't know about cgroups and there was
no way to tell who to blame for a given writeback IO.  writeback
finally grew support for cgroups and now tags each writeback IO with
the appropriate cgroup to charge it against.

This patchset updates cfq so that it follows the blkcg each bio is
tagged with.  Async cfq_queues are now shared across cfq_group, which
is per-cgroup, instead of per-request_queue cfq_data.  This makes all
IOs follow the weight based IO resource distribution implemented by
cfq.

This patchset contains the following 8 patches.

 0001-cfq-iosched-simplify-control-flow-in-cfq_get_queue.patch
 0002-cfq-iosched-fix-async-oom-queue-handling.patch
 0003-cfq-iosched-fix-oom-cfq_queue-ref-leak-in-cfq_set_re.patch
 0004-cfq-iosched-minor-cleanups.patch
 0005-cfq-iosched-remove-gfp_mask-from-cfq_find_alloc_queu.patch
 0006-cfq-iosched-move-cfq_group-determination-from-cfq_fi.patch
 0007-cfq-iosched-fold-cfq_find_alloc_queue-into-cfq_get_q.patch
 0008-cfq-iosched-charge-async-IOs-to-the-appropriate-blkc.patch

0001-0003 are a prep and two fix patches on top.  The bugs fixed by
these patches are very unlikely to cause problems in actual usage, so
the patches aren't tagged w/ -stable.

0004-0007 are prep patches.

0008 makes cfq cgroup-writeback ready.

This patchset is on top of block/for-4.2/writeback 5857cd637bc0 ("bdi:
fix wrong error return value in cgwb_create()").

Thanks, diffstat follows.

 block/cfq-iosched.c |  220 ++++++++++++++++++++--------------------------------
 1 file changed, 85 insertions(+), 135 deletions(-)

--
tejun
