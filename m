From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] block: fixes for long standing issues
Date: Thu, 19 Apr 2012 16:29:20 -0700
Message-ID: <1334878164-24788-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=momvZZ21MXzMxX+dy0luo9B2Tu4bhm04Q7PGsvumZPk=;
        b=U7s2IJY3Vf12V96OF02kx4rF1vpyqIcsTCvUkaPXUY2xKhfPg/3jF9ytM4vOS8N/CG
         W3I3ybNLwmQdGAw6aQSTIevlc877lS5tUSBO4gVHmU5X5qKUGG6KSGx1l8T7LNE8P/Xt
         ybbGdNzJFsADhqWQZSTna4OiKzlKvgx375F6zKtefetMJ6364q7z2XmAA//LO5F1lcot
         +DNFxBR9wZanYo7yzggBgUVKsGlwwQDJfoEE0O3sFpeGChq3F7XyicdiKYt+LPlNFONU
         TnM3sDeBJ60gOFh37WgmKp29OJDrFCnRwcSLnPhiymncUqnzTQTi3yDr7wOkgkVr72Vc
         Nkjg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

This patchset fixes two long standing issues and one relatively new
css ref leak.

a. elvpriv alloc failure, including ioc and icq failures, fails
   request allocation.  As those aren't mempool backed and may fail
   indefinitely, this can lead to deadlock under memory pressure.

b. blkgs don't have proper indexing.  With enough number of
   request_queues and blk-throttle enabled, block layer can spend
   considerable amount of cpu cycles walking the same list over and
   over again.

c. __blkg_lookup_create() was leaking a css ref on failure path.

This patchset contains the following four patches.

 0001-block-collapse-blk_alloc_request-into-get_request.patch
 0002-block-fix-elvpriv-allocation-failure-handling.patch
 0003-blkcg-fix-blkcg-css-ref-leak-in-__blkg_lookup_create.patch
 0004-blkcg-use-radix-tree-to-index-blkgs-from-blkcg.patch

0001-0002 fix #a.  0003 fixes #c.  0004 fixes #b.

This patchset is on top of

  block/for-3.5/core 5bc4afb1ec "blkcg: drop BLKCG_STAT_{PRIV|POL|OFF} macros"
+ [1] [PATCHSET] block: per-queue policy activation, take#2
+ [2] [PATCHSET] block: cosmetic updates to blkcg API

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blk-misc-fixes

diffstat follows.

 block/blk-cgroup.c |   71 ++++++++++++++++++++++++++++++++-----------
 block/blk-cgroup.h |    6 +++
 block/blk-core.c   |   87 ++++++++++++++++++++++++++++-------------------------
 3 files changed, 106 insertions(+), 58 deletions(-)

Thanks.

--
tejun

[1] https://lkml.org/lkml/2012/4/13/380
[2] http://www.spinics.net/lists/cgroups/msg01748.html
