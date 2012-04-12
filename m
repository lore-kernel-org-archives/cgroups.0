From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] block: per-queue policy activation
Date: Thu, 12 Apr 2012 16:29:32 -0700
Message-ID: <1334273380-30233-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=YL8gPcjYrUDPoaPJwdhT+hge0eiUx8a0BxQUz2czgtk=;
        b=wIN+HpdPRUX2lH9fRUoLD0PirtlbldRIcDb9AsgYJkR6jUX2EoqDeLQikLlM4uMhzA
         mZ353ue+eTrFFI3HNQiGa1UYFgyHQBbkDFttcqm6tg5x71GtA9Y0jAMjxXLbDHLy7X+v
         tLWrl6fLAW7nWcSxDstGZyo1oC097EFW/lZHGrvAi+8M0iB3KHadw0Cl2ZAPkW3pV0as
         SKkjMZKGVyMba4wuEbsozcb22TehIlza5yc+7e5KYSiP5dsYdFpVwC1jTuX82P1Aq7oA
         omlRSMljnoNRy5EOO3yoCnWJp7IbczGPz84uiOobp1y6Druevg2JSpePT8nNYIXUj6+P
         5Gcw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello,

It seems that we're *finally* nearing the end of the long blkcg API
cleanup.  With all the previous updates, blkcg code is now clean &
modular enough to implement per-queue policy activation.

Upto now, blkcg assumed that all policies are active on all queues
which simply isn't true - cfq policy is only applicable to queues
which are using cfq as the elevator.  Also, for transition purposes,
the current implementation clears all !root blkgs blkgs across
elevator switch and policy [de]registration in racy manner.

This patchset implements per-queue policy activation.  Static policy
ID is replaced with dynamic registration and each policy should be
activated and deactivated explicitly on each queue.  On activation,
the matching policy data are created on all existing blkgs.  On
deactivation, the matching policy data are removed from all existing
blkgs.  blkg printing skips blkg-policy combination which is disabled
and trying to configure a policy on a blkg which doesn't have the
policy enabled would return -EINVAL instead of creating an unused
dummy configuration.

 0001-blkcg-kill-blkio_list-and-replace-blkio_list_lock-wi.patch
 0002-blkcg-use-pol-instead-of-plid-in-update_root_blkg_pd.patch
 0003-blkcg-remove-static-policy-ID-enums.patch
 0004-blkcg-make-blkg_conf_prep-take-pol-and-return-with-q.patch
 0005-blkcg-make-sure-blkg_lookup-returns-NULL-if-q-is-byp.patch
 0006-blkcg-add-request_queue-root_blkg.patch
 0007-blkcg-implement-per-queue-policy-activation.patch
 0008-blkcg-drop-stuff-unused-after-per-queue-policy-activ.patch

0001-0003 removes static policy IDs.

0004-0006 are prep patches.

0007 implements per-queue policy activation.

0008 drops unnecessary stuff.

This patchset is on top of the current block/for-3.5/core 5bc4afb1ec
"blkcg: drop BLKCG_STAT_{PRIV|POL|OFF} macros" and also available in
the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-pols

diffstat follows.

 block/blk-cgroup.c     |  424 ++++++++++++++++++++++++++++++-------------------
 block/blk-cgroup.h     |   43 ++--
 block/blk-core.c       |    4 
 block/blk-throttle.c   |   78 +++------
 block/cfq-iosched.c    |   71 ++++----
 block/elevator.c       |    2 
 include/linux/blkdev.h |   10 +
 7 files changed, 367 insertions(+), 265 deletions(-)

Thanks.

--
tejun
