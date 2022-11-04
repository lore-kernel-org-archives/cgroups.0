From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v9 0/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Fri,  4 Nov 2022 14:20:47 -0400
Message-ID: <20221104182050.342908-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667586060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mwGJiTiSAfN6PRbmiMouEvgWpKw4XbL4CZuerrQ/8Q0=;
        b=H/3sOjE1AyWZmzrBEzNhNyflt7Xx9bAFXtCUpOqSxloXxZi+yEND94A0swj4ioxy2Y0uws
        rkR0Qmm8aVhYs8t1DzcECD3VqB9Ri0jraiZtJWUda0lmS0BV/ouN+60TpkFQdRNuq8m6we
        7kpHucxHn6oXBkCOG+9suU2mZ6v9X2Q=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v9:
  - Remove patch "llist: Allow optional sentinel node terminated lockless
    list" for now. This will be done as a follow-up patch.
  - Add a new lqueued field to blkg_iostat_set to store the status of
    whether lnode is in a lockless list.
  - Add a new patch 3 to speed up the freeing of blkcg by flushing out
    the rstat lockless lists at blkcg offline time.

 v8:
  - Update the llist patch to make existing llist functions and macros
    work for both NULL and sentinel terminated lockless list as much
    as possible and leave only the initialization and removal functions
    to have a sentinel terminated llist variants.

 v7:
  - Drop patch 1 ("blk-cgroup: Correctly free percpu iostat_cpu in blkg
    on error exit") as it is found to be unnecessary.
  - Add a new llist patch to provide a lockless list variant terminated
    by a sentinel node.
  - Modified patch 3 to use the new sllist API and move percpu_ref_put()
    later in the blkcg_rstat_flush() loop to prevent potential
    use-after-free problem.


This patch series improves blkcg_rstat_flush() performance by eliminating
unnecessary blkg enumeration and flush operations for those blkg's and
blkg_iostat_set's that haven't been updated since the last flush.

Waiman Long (3):
  blk-cgroup: Return -ENOMEM directly in blkcg_css_alloc() error path
  blk-cgroup: Optimize blkcg_rstat_flush()
  blk-cgroup: Flush stats at blkgs destruction path

 block/blk-cgroup.c     | 103 +++++++++++++++++++++++++++++++++++------
 block/blk-cgroup.h     |  10 ++++
 include/linux/cgroup.h |   1 +
 kernel/cgroup/rstat.c  |  20 ++++++++
 4 files changed, 119 insertions(+), 15 deletions(-)

-- 
2.31.1

