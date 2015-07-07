From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET v2 block/for-4.3] block, cgroup: make cfq charge async IOs to the appropriate blkcgs
Date: Tue,  7 Jul 2015 11:35:52 -0400
Message-ID: <1436283361-3889-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=66PaIdWH3xjdXATxMcXXlVja4CLNbE6EH8/xKiR2v7U=;
        b=o5hf+5dI55bPJCRzLnYoGo/JHZFkSHmm/Kx++wqY9IR0cBgjtHh9kSN+LL1b6JmrTy
         vkl9VZiZatWWu2EAeZhBzf4Ejf3GBBXj5E4XXFR7H25g9D4aKdlYGPX8yrBJoirr8znF
         ZycuuSLhZuejXO/k1TF0Npcqx6p2ZcBpSWVNS1OLW6THi+LXgIyJF57omoEHpDLstHR0
         As8Uj8JT6mhaalNwodAIvvGrEB2ta6H1yAXtTgnudQ2s9luL/advUbzY9zxGlZ5IDbq6
         xwt83J/2qmSN8vJ3pi3fyw3mawPngtMXjT3SWM0y4rJGfd4IMm33HhxPabJo0qlvsRCx
         0YWg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hello,

This is v2 of cfq cgroup writeback patchset.  Changes from the last
take[L] are

* Switched from GFP_ATOMIC to GFP_NOWAIT as suggested by Jeff.

* Other misc review points addressed, acks added and rebased.

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
 0005-blkcg-cfq-iosched-use-GFP_NOWAIT-instead-of-GFP_ATOM.patch
 0006-cfq-iosched-remove-gfp_mask-from-cfq_find_alloc_queu.patch
 0007-cfq-iosched-move-cfq_group-determination-from-cfq_fi.patch
 0008-cfq-iosched-fold-cfq_find_alloc_queue-into-cfq_get_q.patch
 0009-cfq-iosched-charge-async-IOs-to-the-appropriate-blkc.patch

0001-0003 are a prep and two fix patches on top.  The bugs fixed by
these patches are very unlikely to cause problems in actual usage, so
the patches aren't tagged w/ -stable.

0004-0008 are prep patches.

0009 makes cfq cgroup-writeback ready.

This patchset is on top of

  d770e558e219 ("Linux 4.2-rc1")
+ [1] [PATCHSET block/for-4.3] writeback: cgroup writeback updates

diffstat follows, thanks.

 block/blk-cgroup.c  |    8 -
 block/cfq-iosched.c |  220 ++++++++++++++++++++--------------------------------
 2 files changed, 89 insertions(+), 139 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1433753973-23684-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[1] http://lkml.kernel.org/g/1436281823-1947-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
