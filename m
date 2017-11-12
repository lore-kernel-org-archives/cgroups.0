From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] blkcg: basic accounting and throttling fixes
Date: Sun, 12 Nov 2017 14:26:06 -0800
Message-ID: <20171112222613.3613362-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=HB+JmZHAKSflbKTKZ0dRoXifjcp0k0HqLodokvHGDYM=;
        b=pkdnTTmI+ZnbH6S82snjRk5c0cZkab8wq2fk153ouku52TZNvhsFpgwyOewAJlymK5
         JXrSVkTX9ONr0l1Ikacf7Bg+sSR1ePHLRx1Xgo5HnC9OOVxFcHtEwwN3b9hkXXX+rg/Q
         SL2HBvx+7fsAZizVWRj6zxG1keSCqNVotKuqWcxbMMb+q8sQ3qjxKJFGh67Dr/qScPjy
         E8BuAXjByKun5pjk3XH/r18rv7T6FZxshheVjoz1TjmcTzyZl/F8rAIFil7NfWd3A5GN
         RvqQYsNSAyxl0i9i625p9lJUJUzTUtGAnGBVn9oKxcYEOXZ44g37LEPEJvJ9jhgC18f8
         ZjCQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

blkcg was often getting basic accounting numbers wildly wrong and
blk-throtl could throttle the same bio multiple times leading to
significantly lower limits being enforced than configured.

This patchset contains the following seven patches to update request
cgroup membership tracking and fix the bugs.

 0001-blkcg-relocate-__blkg_release_rcu.patch
 0002-blkcg-use-percpu_ref-for-blkcg_gq-refcnt.patch
 0003-blkcg-associate-a-request-with-its-blkcg_gq-instead-.patch
 0004-blkcg-refactor-blkcg_gq-lookup-and-creation-in-blkcg.patch
 0005-blkcg-associate-blk-mq-requests-with-the-matching-bl.patch
 0006-blkcg-account-requests-instead-of-bios-for-request-b.patch
 0007-blk-throtl-don-t-throttle-the-same-IO-multiple-times.patch

0001-0005 update request cgroup membership tracking so that the
association is always available.

0006 makes blkcg account requests instead of bios as bios don't really
have much to do with what's going on the system.

0007 prevents blk-throttle from throttling the same IO multiple times.

The patches are also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-blkcg-fixes

diffstat follows.  Thanks.

 block/blk-cgroup.c         |   69 +++++++++++++----------
 block/blk-core.c           |   13 +++-
 block/blk-mq.c             |    9 ++-
 block/blk-mq.h             |    1 
 block/blk-throttle.c       |   10 ---
 include/linux/blk-cgroup.h |  134 ++++++++++++++++++++++++++++++++++++---------
 include/linux/blkdev.h     |    2 
 7 files changed, 169 insertions(+), 69 deletions(-)

--
tejun
