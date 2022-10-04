From: Waiman Long <longman@redhat.com>
Subject: [PATCH v8 0/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Tue,  4 Oct 2022 11:17:45 -0400
Message-ID: <20221004151748.293388-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664896683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qRmJxlNE0tvN7yeNgrdiLgaoqgJkRykVza0oLJZ3xvE=;
        b=efHTv36OiPIHvqNOQUqHSVxVkhZvK8Ve4TxAN6OKiGQi1gf8Bl9frdEsmgx1cqAEPAC+sD
        qQ1NH8DJeswJBrjgQEr9HbAm5lOU43py85zZEglWoDVklEbMuOjKxhc2wlvkcMc957/lKG
        s7JiLmJwK9r8FQGIzEzoV2qGYJN5518=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>

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

 v6:
  - Add a missing free_percpu() into blkcg_css_free() in patch 3.
  - Integrating the documentation patch 4 back into patch 3.

 v5:
  - Add a new patch 2 to eliminate the use of intermediate "ret"
    variable in blkcg_css_alloc() to fix compilation warning reported
    by kernel test robot.

This patch series improves blkcg_rstat_flush() performance by eliminating
unnecessary blkg enumeration and flush operations for those blkg's and
blkg_iostat_set's that haven't been updated since the last flush. It
also enhances the llist API to support a sentinel termianted variant
of the lockless list.

Waiman Long (3):
  llist: Allow optional sentinel node terminated lockless list
  blk-cgroup: Return -ENOMEM directly in blkcg_css_alloc() error path
  blk-cgroup: Optimize blkcg_rstat_flush()

 block/blk-cgroup.c    |  87 ++++++++++++++++++++++++++++++------
 block/blk-cgroup.h    |   9 ++++
 include/linux/llist.h | 100 +++++++++++++++++++++++++++++++++---------
 lib/llist.c           |  20 ++++++---
 4 files changed, 177 insertions(+), 39 deletions(-)

-- 
2.31.1

